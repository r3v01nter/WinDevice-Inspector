<#
.SYNOPSIS
    WinDevice-Inspector (WDI-DIAG-001) - Windows 11 只读一键诊断信息采集脚本
.DESCRIPTION
    严格只读采集操作系统、硬件、设备管理器、驱动、接口与外设、电源、系统日志与网络信息。
    兼容 PowerShell 7 (pwsh.exe) 与 Windows PowerShell 5.1 (powershell.exe)。
    默认对隐私敏感信息进行脱敏处理，输出 TXT 综合报告、JSON 完整数据与 CSV 表格数据。
.NOTES
    任务编号: WDI-DIAG-001
    安全原则: 严格只读；不修改注册表、系统设置、电源计划、驱动或日志；不联网、不上传。
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [string]$ToolRoot = "",

    [Parameter(Mandatory = $false)]
    [string]$ConfigPath = "",

    [Parameter(Mandatory = $false)]
    [string]$OutputBase = ""
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# 统一控制台 UTF-8 输出，兼容中文路径与中文提示
try {
    [Console]::OutputEncoding = [System.Text.UTF8Encoding]::new($false)
    $OutputEncoding = [System.Text.UTF8Encoding]::new($false)
} catch {
    # 非交互或重定向场景下忽略编码设置异常
}

# ============================================================================
# 1. 路径初始化与配置加载
# ============================================================================
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
if ([string]::IsNullOrWhiteSpace($ToolRoot)) {
    $ToolRoot = Split-Path -Parent $ScriptDir
}
if ([string]::IsNullOrWhiteSpace($ConfigPath)) {
    $ConfigPath = Join-Path $ToolRoot "config\config.json"
}
if ([string]::IsNullOrWhiteSpace($OutputBase)) {
    $OutputBase = Join-Path $ToolRoot "output"
}

$DefaultConfig = [ordered]@{
    toolVersion   = "1.0.0"
    schemaVersion = "wdi-diag-v1"
    collection    = [ordered]@{
        logLookbackDays         = 7
        maxEventsPerCategory    = 100
        includeCsvReports       = $true
        collectAllPnpDevices    = $true
        collectAllSignedDrivers = $true
        outputSubfolderPrefix   = "WDI_Diag"
    }
    privacy       = [ordered]@{
        enabled              = $true
        redactUserName       = $true
        redactComputerName   = $true
        redactIpAddress      = $true
        redactMacAddress     = $true
        redactDiskSerial     = $true
        redactDeviceUniqueId = $true
        redactOtherPii       = $true
    }
}

function Merge-Config {
    param($Defaults, $Loaded)
    $cfg = [ordered]@{
        toolVersion   = $Defaults.toolVersion
        schemaVersion = $Defaults.schemaVersion
        collection    = [ordered]@{}
        privacy       = [ordered]@{}
    }
    foreach ($k in $Defaults.collection.Keys) {
        $cfg.collection[$k] = $Defaults.collection[$k]
    }
    foreach ($k in $Defaults.privacy.Keys) {
        $cfg.privacy[$k] = $Defaults.privacy[$k]
    }
    if ($null -ne $Loaded) {
        if ($Loaded.PSObject.Properties.Name -contains 'collection' -and $null -ne $Loaded.collection) {
            foreach ($k in $Defaults.collection.Keys) {
                if ($Loaded.collection.PSObject.Properties.Name -contains $k -and $null -ne $Loaded.collection.$k) {
                    $cfg.collection[$k] = $Loaded.collection.$k
                }
            }
        }
        if ($Loaded.PSObject.Properties.Name -contains 'privacy' -and $null -ne $Loaded.privacy) {
            foreach ($k in $Defaults.privacy.Keys) {
                if ($Loaded.privacy.PSObject.Properties.Name -contains $k -and $null -ne $Loaded.privacy.$k) {
                    $cfg.privacy[$k] = [bool]$Loaded.privacy.$k
                }
            }
        }
    }
    # 边界保护
    if ([int]$cfg.collection.logLookbackDays -lt 1) { $cfg.collection.logLookbackDays = 1 }
    if ([int]$cfg.collection.logLookbackDays -gt 90) { $cfg.collection.logLookbackDays = 90 }
    if ([int]$cfg.collection.maxEventsPerCategory -lt 10) { $cfg.collection.maxEventsPerCategory = 10 }
    if ([int]$cfg.collection.maxEventsPerCategory -gt 500) { $cfg.collection.maxEventsPerCategory = 500 }
    return $cfg
}

$ConfigLoadWarning = $null
$LoadedConfig = $null
if (Test-Path -LiteralPath $ConfigPath) {
    try {
        $rawCfg = [System.IO.File]::ReadAllText($ConfigPath, [System.Text.Encoding]::UTF8)
        $LoadedConfig = $rawCfg | ConvertFrom-Json
    } catch {
        $ConfigLoadWarning = "配置文件解析失败，已回退内置默认安全配置：$($_.Exception.Message)"
    }
} else {
    $ConfigLoadWarning = "未找到配置文件，已使用内置默认安全与脱敏配置。"
}
$Config = Merge-Config -Defaults $DefaultConfig -Loaded $LoadedConfig

# 创建本次诊断输出目录
$RunStartLocal = Get-Date
$RunStartUtc = $RunStartLocal.ToUniversalTime()
$TimestampTag = $RunStartLocal.ToString("yyyyMMdd_HHmmss")
$RunDirName = "{0}_{1}" -f $Config.collection.outputSubfolderPrefix, $TimestampTag
$RunOutputDir = Join-Path $OutputBase $RunDirName
$CsvDir = Join-Path $RunOutputDir "csv"

if (-not (Test-Path -LiteralPath $OutputBase)) {
    New-Item -ItemType Directory -Path $OutputBase -Force | Out-Null
}
New-Item -ItemType Directory -Path $RunOutputDir -Force | Out-Null
if ($Config.collection.includeCsvReports) {
    New-Item -ItemType Directory -Path $CsvDir -Force | Out-Null
}

# 日志记录器
$RunLogLines = [System.Collections.Generic.List[string]]::new()
function Write-DiagLog {
    param(
        [string]$Message,
        [string]$Level = "INFO"
    )
    $line = "[{0}] [{1}] {2}" -f (Get-Date).ToString("yyyy-MM-dd HH:mm:ss"), $Level, $Message
    $RunLogLines.Add($line) | Out-Null
    Write-Host $line
}

Write-DiagLog "诊断采集启动 (WDI-DIAG-001 v$($Config.toolVersion))"
if ($ConfigLoadWarning) {
    Write-DiagLog $ConfigLoadWarning "WARN"
}

# ============================================================================
# 2. 权限检测、运行时环境与隐私脱敏工具函数
# ============================================================================
function Test-IsAdministrator {
    try {
        $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
        $principal = New-Object Security.Principal.WindowsPrincipal($identity)
        return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    } catch {
        return $false
    }
}

$IsAdmin = Test-IsAdministrator
$RawUserName = $env:USERNAME
$RawComputerName = $env:COMPUTERNAME
$PsVersionString = $PSVersionTable.PSVersion.ToString()
$PsEditionString = if ($PSVersionTable.ContainsKey('PSEdition')) { [string]$PSVersionTable.PSEdition } else { "Unknown" }

Write-DiagLog "PowerShell 环境: $PsEditionString $PsVersionString | 当前权限: $(if ($IsAdmin) { '管理员' } else { '普通用户（非管理员）' })"
Write-DiagLog "本次报告目录: $RunOutputDir"

function Test-IsAccessDeniedError {
    param($ErrorRecord)
    if ($null -eq $ErrorRecord) { return $false }
    $msg = "$($ErrorRecord.Exception.Message) $($ErrorRecord.FullyQualifiedErrorId)"
    if ($ErrorRecord.Exception -is [System.UnauthorizedAccessException]) { return $true }
    if ($msg -match '(Access is denied|UnauthorizedAccess|拒绝访问|0x80070005|PrivilegeNotHeld|权限不足)') {
        return $true
    }
    return $false
}

function Protect-Text {
    param([AllowNull()][string]$Text)
    if ([string]::IsNullOrEmpty($Text)) { return $Text }
    if (-not $Config.privacy.enabled) { return $Text }

    $out = $Text
    if ($Config.privacy.redactUserName -and -not [string]::IsNullOrWhiteSpace($RawUserName)) {
        $escapedUser = [regex]::Escape($RawUserName)
        $out = [regex]::Replace($out, "(?i)([A-Za-z]:\\Users\\)$escapedUser(?=(\\|$|[^A-Za-z0-9_.-]))", '${1}[USER_REDACTED]')
        $out = [regex]::Replace($out, "(?i)(?<![A-Za-z0-9_])$escapedUser(?![A-Za-z0-9_])", "[USER_REDACTED]")
    }
    if ($Config.privacy.redactComputerName -and -not [string]::IsNullOrWhiteSpace($RawComputerName)) {
        $escapedHost = [regex]::Escape($RawComputerName)
        $out = [regex]::Replace($out, "(?i)(?<![A-Za-z0-9_-])$escapedHost(?![A-Za-z0-9_-])", "[HOST_REDACTED]")
    }
    if ($Config.privacy.redactIpAddress) {
        # 保留私网前两段或公网首段以维持诊断价值，隐藏主机位
        $out = [regex]::Replace($out, '\b((?:10|172\.(?:1[6-9]|2[0-9]|3[01])|192\.168))\.\d{1,3}\.\d{1,3}\b', '$1.x.x')
        $out = [regex]::Replace($out, '\b(?!127\.0\.0\.1\b)(?!0\.0\.0\.0\b)(?!255\.255\.255\.\d+\b)(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})\b', [System.Text.RegularExpressions.MatchEvaluator]{
            param($m)
            $a = [int]$m.Groups[1].Value
            $b = [int]$m.Groups[2].Value
            $c = [int]$m.Groups[3].Value
            $d = [int]$m.Groups[4].Value
            if ($a -gt 255 -or $b -gt 255 -or $c -gt 255 -or $d -gt 255) { return $m.Value }
            if ($a -eq 192 -and $b -eq 168) { return "192.168.x.x" }
            if ($a -eq 10) { return "10.x.x.x" }
            if ($a -eq 169 -and $b -eq 254) { return "169.254.x.x" }
            return "$a.x.x.x"
        })
        # IPv6 地址脱敏（保留前缀）
        $out = [regex]::Replace($out, '\b([0-9a-fA-F]{1,4}:[0-9a-fA-F]{1,4}):(?:[0-9a-fA-F]{0,4}:){1,6}[0-9a-fA-F]{1,4}\b', '$1::[IPV6_REDACTED]')
    }
    if ($Config.privacy.redactMacAddress) {
        # 保留 OUI 前三字节便于判断网卡厂商
        $out = [regex]::Replace($out, '\b([0-9A-Fa-f]{2}[:-][0-9A-Fa-f]{2}[:-][0-9A-Fa-f]{2})[:-][0-9A-Fa-f]{2}[:-][0-9A-Fa-f]{2}[:-][0-9A-Fa-f]{2}\b', '$1:XX:XX:XX')
    }
    if ($Config.privacy.redactOtherPii) {
        $out = [regex]::Replace($out, '\bS-1-5-21-\d+-\d+-\d+-\d+\b', 'S-1-5-21-[SID_REDACTED]')
        $out = [regex]::Replace($out, '\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}\b', '[EMAIL_REDACTED]')
    }
    return $out
}

function Protect-Serial {
    param([AllowNull()][string]$Serial)
    if ([string]::IsNullOrWhiteSpace($Serial)) { return $null }
    $trimmed = $Serial.Trim()
    if (-not $Config.privacy.enabled -or -not $Config.privacy.redactDiskSerial) {
        return $trimmed
    }
    if ($trimmed.Length -le 4) {
        return "[SERIAL_REDACTED]"
    }
    return "[SERIAL_REDACTED_" + $trimmed.Substring($trimmed.Length - 4) + "]"
}

function Protect-Mac {
    param([AllowNull()][string]$Mac)
    if ([string]::IsNullOrWhiteSpace($Mac)) { return $null }
    $trimmed = $Mac.Trim()
    if (-not $Config.privacy.enabled -or -not $Config.privacy.redactMacAddress) {
        return $trimmed
    }
    return (Protect-Text -Text $trimmed)
}

function Protect-DeviceInstanceId {
    param([AllowNull()][string]$InstanceId)
    if ([string]::IsNullOrWhiteSpace($InstanceId)) { return $null }
    $trimmed = $InstanceId.Trim()
    if (-not $Config.privacy.enabled -or -not $Config.privacy.redactDeviceUniqueId) {
        return $trimmed
    }
    # 保留总线与硬件标识段（如 PCI\VEN_xxxx&DEV_xxxx、USB\VID_xxxx&PID_xxxx），脱敏末尾唯一实例/序列段
    $parts = $trimmed -split '\\'
    if ($parts.Count -ge 3) {
        $tail = $parts[$parts.Count - 1]
        if ($tail.Length -gt 4) {
            $parts[$parts.Count - 1] = "[ID_REDACTED_" + $tail.Substring($tail.Length - 4) + "]"
        } else {
            $parts[$parts.Count - 1] = "[ID_REDACTED]"
        }
        return ($parts -join '\')
    }
    return $trimmed
}

function Get-ConfigManagerErrorText {
    param([AllowNull()][object]$Code)
    if ($null -eq $Code) { return "Unknown" }
    $c = [int]$Code
    $map = @{
        0  = "Device is working properly"
        1  = "Device is not configured correctly (Code 1)"
        3  = "Driver might be corrupted or system low on memory (Code 3)"
        10 = "Device cannot start (Code 10)"
        12 = "Cannot find enough free resources (Code 12)"
        14 = "Restart required (Code 14)"
        18 = "Reinstall drivers for this device (Code 18)"
        19 = "Registry configuration incomplete or damaged (Code 19)"
        21 = "Windows is removing this device (Code 21)"
        22 = "Device is disabled (Code 22)"
        24 = "Device is not present or not working properly (Code 24)"
        28 = "Drivers are not installed (Code 28)"
        29 = "Device disabled in firmware (Code 29)"
        31 = "Device is not working properly; driver could not be loaded (Code 31)"
        32 = "Driver start type is disabled (Code 32)"
        37 = "Windows cannot initialize device driver (Code 37)"
        39 = "Driver corrupted or missing (Code 39)"
        43 = "Windows has stopped this device because it reported problems (Code 43)"
        45 = "Device is not currently connected (Code 45)"
        47 = "Device prepared for safe removal (Code 47)"
        48 = "Software for this device has been blocked (Code 48)"
        52 = "Windows cannot verify digital signature for drivers (Code 52)"
    }
    if ($map.ContainsKey($c)) { return $map[$c] }
    return "ConfigManager Error Code $c"
}

function Format-DateUtcIso {
    param($DateObj)
    if ($null -eq $DateObj) { return $null }
    try {
        return ([datetime]$DateObj).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
    } catch {
        return [string]$DateObj
    }
}

function New-CategoryResult {
    param(
        [string]$Id,
        [string]$Name,
        [string]$Status = "UNKNOWN",
        [string]$Source = "",
        $Data = $null,
        [string[]]$Warnings = @(),
        [string[]]$Errors = @(),
        [string]$CurrentStateNote = "",
        [bool]$RequiresAdmin = $false,
        [hashtable]$QueryParameters = @{},
        [int]$DurationMs = 0
    )
    return [ordered]@{
        id               = $Id
        name             = $Name
        status           = $Status
        source           = $Source
        collectedAtUtc   = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
        durationMs       = $DurationMs
        requiresAdmin    = $RequiresAdmin
        currentStateNote = $CurrentStateNote
        queryParameters  = $QueryParameters
        warnings         = @($Warnings)
        errors           = @($Errors)
        data             = $Data
    }
}

function Invoke-SafeSection {
    param(
        [string]$Id,
        [string]$Name,
        [string]$Source,
        [scriptblock]$Action
    )
    Write-DiagLog "开始采集 [$Name]..."
    $sw = [System.Diagnostics.Stopwatch]::StartNew()
    try {
        $result = & $Action
        $sw.Stop()
        $result.durationMs = [int]$sw.ElapsedMilliseconds
        Write-DiagLog "完成采集 [$Name] -> 状态: $($result.status) ($($result.durationMs) ms)"
        return $result
    } catch {
        $sw.Stop()
        $status = if (Test-IsAccessDeniedError $_) { "ACCESS_DENIED" } else { "FAILED" }
        $errMsg = Protect-Text -Text $_.Exception.Message
        Write-DiagLog "采集 [$Name] 失败 -> $status : $errMsg" "ERROR"
        return (New-CategoryResult -Id $Id -Name $Name -Status $status -Source $Source -Errors @($errMsg) -CurrentStateNote "采集过程发生异常，不得视为正常" -DurationMs ([int]$sw.ElapsedMilliseconds))
    }
}

# ============================================================================
# 3. 八大模块只读采集实现
# ============================================================================

# --- 模块 1: 操作系统 ---
$SectionOs = Invoke-SafeSection -Id "os" -Name "操作系统信息" -Source "CIM:Win32_OperatingSystem + Registry(ReadOnly)" -Action {
    $warnings = [System.Collections.Generic.List[string]]::new()
    $os = Get-CimInstance -ClassName Win32_OperatingSystem -ErrorAction Stop
    $displayVersion = $null
    $ubr = $null
    try {
        $cv = Get-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion' -ErrorAction Stop
        if ($cv.PSObject.Properties.Name -contains 'DisplayVersion') { $displayVersion = [string]$cv.DisplayVersion }
        if ($cv.PSObject.Properties.Name -contains 'UBR') { $ubr = [string]$cv.UBR }
    } catch {
        $warnings.Add("无法读取注册表 DisplayVersion/UBR：$($_.Exception.Message)")
    }

    $uptimeStr = $null
    $uptimeHours = $null
    if ($null -ne $os.LastBootUpTime) {
        $span = (Get-Date) - ([datetime]$os.LastBootUpTime)
        $uptimeHours = [math]::Round($span.TotalHours, 2)
        $uptimeStr = "{0}天 {1}小时 {2}分钟" -f [int]$span.Days, $span.Hours, $span.Minutes
    }

    $data = [ordered]@{
        caption          = $os.Caption
        version          = $os.Version
        displayVersion   = $displayVersion
        buildNumber      = $os.BuildNumber
        ubr              = $ubr
        fullBuild        = if ($ubr) { "$($os.BuildNumber).$ubr" } else { "$($os.BuildNumber)" }
        architecture     = $os.OSArchitecture
        installDateUtc   = Format-DateUtcIso $os.InstallDate
        lastBootUpUtc    = Format-DateUtcIso $os.LastBootUpTime
        uptimeReadable   = $uptimeStr
        uptimeHours      = $uptimeHours
        computerName     = Protect-Text -Text $RawComputerName
        currentUser      = Protect-Text -Text $RawUserName
        timeZoneId       = [System.TimeZoneInfo]::Local.Id
        timeZoneDisplay  = [System.TimeZoneInfo]::Local.DisplayName
    }
    return (New-CategoryResult -Id "os" -Name "操作系统信息" -Status "NORMAL" -Source "CIM:Win32_OperatingSystem + Registry(ReadOnly)" -Data $data -Warnings $warnings.ToArray() -CurrentStateNote "系统基础信息读取成功")
}

# --- 模块 2: 硬件信息 ---
$DiskCsvRows = [System.Collections.Generic.List[object]]::new()
$SectionHardware = Invoke-SafeSection -Id "hardware" -Name "硬件信息" -Source "CIM:Processor/VideoController/PhysicalMemory/BaseBoard/BIOS/Disk + Storage" -Action {
    $warnings = [System.Collections.Generic.List[string]]::new()
    $errors = [System.Collections.Generic.List[string]]::new()
    $hasAbnormal = $false
    $hasSuspected = $false
    $subFailures = 0

    # 2.1 CPU
    $cpus = @()
    try {
        $cpuRaw = @(Get-CimInstance -ClassName Win32_Processor -ErrorAction Stop)
        $cpus = @($cpuRaw | ForEach-Object {
            [ordered]@{
                name                      = if ($_.Name) { $_.Name.Trim() } else { "Unknown" }
                manufacturer              = $_.Manufacturer
                cores                     = $_.NumberOfCores
                logicalProcessors         = $_.NumberOfLogicalProcessors
                maxClockSpeedMhz          = $_.MaxClockSpeed
                status                    = $_.Status
            }
        })
    } catch {
        $subFailures++
        $errors.Add("CPU 信息读取失败：$($_.Exception.Message)")
    }

    # 2.2 GPU（同时尝试只读注册表获取 >4GB 显存，避免 32-bit AdapterRAM 溢出）
    $gpuMemMap = @{}
    try {
        $regGpus = Get-ChildItem -LiteralPath 'HKLM:\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}' -ErrorAction SilentlyContinue | Where-Object { $_.PSChildName -match '^\d{4}$' }
        foreach ($rk in $regGpus) {
            try {
                $props = Get-ItemProperty -LiteralPath $rk.PSPath -ErrorAction SilentlyContinue
                $desc = $props.DriverDesc
                $qwMem = if ($props.PSObject.Properties.Name -contains 'HardwareInformation.qwMemorySize') { $props.'HardwareInformation.qwMemorySize' } else { $null }
                if ($desc -and $qwMem) {
                    $gpuMemMap[$desc] = [int64]$qwMem
                }
            } catch { }
        }
    } catch { }

    $gpus = @()
    try {
        $gpuRaw = @(Get-CimInstance -ClassName Win32_VideoController -ErrorAction Stop)
        $gpus = @($gpuRaw | ForEach-Object {
            $vramBytes = $null
            $vramNote = "UNKNOWN"
            if ($_.Name -and $gpuMemMap.ContainsKey($_.Name)) {
                $vramBytes = $gpuMemMap[$_.Name]
                $vramNote = "Registry(qwMemorySize)"
            } elseif ($null -ne $_.AdapterRAM -and [int64]$_.AdapterRAM -gt 0) {
                $vramBytes = [int64]$_.AdapterRAM
                $vramNote = if ($vramBytes -ge 4293918720) { "Win32_VideoController(可能受32位4GB上限截断)" } else { "Win32_VideoController" }
            }
            if ($_.ConfigManagerErrorCode -and [int]$_.ConfigManagerErrorCode -ne 0) {
                $hasAbnormal = $true
            }
            [ordered]@{
                name                   = $_.Name
                adapterCompatibility   = $_.AdapterCompatibility
                vramMB                 = if ($null -ne $vramBytes) { [math]::Round($vramBytes / 1MB, 0) } else { $null }
                vramSourceNote         = $vramNote
                driverVersion          = $_.DriverVersion
                driverDateUtc          = Format-DateUtcIso $_.DriverDate
                status                 = $_.Status
                configManagerErrorCode = $_.ConfigManagerErrorCode
            }
        })
    } catch {
        $subFailures++
        $errors.Add("GPU 信息读取失败：$($_.Exception.Message)")
    }

    # 2.3 内存
    $memoryModules = @()
    $totalMemoryGB = $null
    try {
        $cs = Get-CimInstance -ClassName Win32_ComputerSystem -ErrorAction Stop
        if ($cs.TotalPhysicalMemory) {
            $totalMemoryGB = [math]::Round([double]$cs.TotalPhysicalMemory / 1GB, 2)
        }
        $memRaw = @(Get-CimInstance -ClassName Win32_PhysicalMemory -ErrorAction Stop)
        $memoryModules = @($memRaw | ForEach-Object {
            [ordered]@{
                deviceLocator        = $_.DeviceLocator
                bankLabel            = $_.BankLabel
                capacityGB           = if ($_.Capacity) { [math]::Round([double]$_.Capacity / 1GB, 2) } else { $null }
                speedMhz             = $_.Speed
                configuredClockMhz   = $_.ConfiguredClockSpeed
                manufacturer         = $_.Manufacturer
                partNumber           = if ($_.PartNumber) { $_.PartNumber.Trim() } else { $null }
                serialNumber         = Protect-Serial $_.SerialNumber
            }
        })
    } catch {
        $subFailures++
        $errors.Add("内存信息读取失败：$($_.Exception.Message)")
    }

    # 2.4 主板与 BIOS
    $motherboard = $null
    $bios = $null
    try {
        $bb = Get-CimInstance -ClassName Win32_BaseBoard -ErrorAction Stop | Select-Object -First 1
        if ($null -ne $bb) {
            $motherboard = [ordered]@{
                manufacturer = $bb.Manufacturer
                product      = $bb.Product
                version      = $bb.Version
                serialNumber = Protect-Serial $bb.SerialNumber
            }
        }
    } catch {
        $subFailures++
        $errors.Add("主板信息读取失败：$($_.Exception.Message)")
    }

    try {
        $b = Get-CimInstance -ClassName Win32_BIOS -ErrorAction Stop | Select-Object -First 1
        if ($null -ne $b) {
            $bios = [ordered]@{
                manufacturer   = $b.Manufacturer
                smbiosVersion  = $b.SMBIOSBIOSVersion
                releaseDateUtc = Format-DateUtcIso $b.ReleaseDate
                serialNumber   = Protect-Serial $b.SerialNumber
            }
        }
    } catch {
        $subFailures++
        $errors.Add("BIOS 信息读取失败：$($_.Exception.Message)")
    }

    # 2.5 磁盘与逻辑卷
    $physicalDisks = @()
    $physCmdAvailable = $null -ne (Get-Command -Name Get-PhysicalDisk -ErrorAction SilentlyContinue)
    if ($physCmdAvailable) {
        try {
            $pdRaw = @(Get-PhysicalDisk -ErrorAction Stop)
            $physicalDisks = @($pdRaw | ForEach-Object {
                $health = [string]$_.HealthStatus
                if ($health -match 'Unhealthy') { $hasAbnormal = $true }
                elseif ($health -match 'Warning') { $hasSuspected = $true }
                $row = [ordered]@{
                    recordType        = "PhysicalDisk"
                    deviceId          = [string]$_.DeviceId
                    model             = $_.FriendlyName
                    sizeGB            = if ($_.Size) { [math]::Round([double]$_.Size / 1GB, 2) } else { $null }
                    mediaType         = [string]$_.MediaType
                    busType           = [string]$_.BusType
                    healthStatus      = $health
                    operationalStatus = [string]$_.OperationalStatus
                    serialNumber      = Protect-Serial $_.SerialNumber
                }
                $DiskCsvRows.Add([PSCustomObject]$row) | Out-Null
                $row
            })
        } catch {
            $warnings.Add("Get-PhysicalDisk 读取失败，已回退 Win32_DiskDrive：$($_.Exception.Message)")
            $physCmdAvailable = $false
        }
    }
    if (-not $physCmdAvailable) {
        try {
            $ddRaw = @(Get-CimInstance -ClassName Win32_DiskDrive -ErrorAction Stop)
            $physicalDisks = @($ddRaw | ForEach-Object {
                if ($_.Status -and $_.Status -ne 'OK') { $hasSuspected = $true }
                $row = [ordered]@{
                    recordType        = "PhysicalDisk(Fallback)"
                    deviceId          = [string]$_.Index
                    model             = $_.Model
                    sizeGB            = if ($_.Size) { [math]::Round([double]$_.Size / 1GB, 2) } else { $null }
                    mediaType         = $_.MediaType
                    busType           = $_.InterfaceType
                    healthStatus      = if ($_.Status) { $_.Status } else { "UNKNOWN" }
                    operationalStatus = "UNKNOWN"
                    serialNumber      = Protect-Serial $_.SerialNumber
                }
                $DiskCsvRows.Add([PSCustomObject]$row) | Out-Null
                $row
            })
        } catch {
            $subFailures++
            $errors.Add("物理磁盘读取失败：$($_.Exception.Message)")
        }
    }

    $logicalVolumes = @()
    try {
        $volRaw = @(Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DriveType=3" -ErrorAction Stop)
        $logicalVolumes = @($volRaw | ForEach-Object {
            $sizeGb = if ($_.Size) { [math]::Round([double]$_.Size / 1GB, 2) } else { $null }
            $freeGb = if ($null -ne $_.FreeSpace) { [math]::Round([double]$_.FreeSpace / 1GB, 2) } else { $null }
            $freePct = if ($_.Size -and $_.Size -gt 0) { [math]::Round(([double]$_.FreeSpace / [double]$_.Size) * 100, 1) } else { $null }
            if ($null -ne $freePct -and $freePct -lt 5) { $hasSuspected = $true; $warnings.Add("逻辑卷 $($_.DeviceID) 剩余空间低于 5%（${freePct}%）") }
            $vRow = [ordered]@{
                recordType        = "LogicalVolume"
                deviceId          = $_.DeviceID
                model             = $_.VolumeName
                sizeGB            = $sizeGb
                mediaType         = $_.FileSystem
                busType           = "FixedDrive"
                healthStatus      = if ($null -ne $freePct) { "Free ${freePct}% (${freeGb} GB)" } else { "UNKNOWN" }
                operationalStatus = "Mounted"
                serialNumber      = $null
            }
            $DiskCsvRows.Add([PSCustomObject]$vRow) | Out-Null
            [ordered]@{
                driveLetter = $_.DeviceID
                volumeName  = $_.VolumeName
                fileSystem  = $_.FileSystem
                sizeGB      = $sizeGb
                freeSpaceGB = $freeGb
                freePercent = $freePct
            }
        })
    } catch {
        $subFailures++
        $errors.Add("逻辑卷读取失败：$($_.Exception.Message)")
    }

    $status = "NORMAL"
    if ($hasAbnormal) { $status = "ABNORMAL" }
    elseif ($subFailures -ge 5) { $status = "FAILED" }
    elseif ($hasSuspected -or $subFailures -gt 0) { $status = "SUSPECTED" }

    $data = [ordered]@{
        cpus           = $cpus
        gpus           = $gpus
        totalMemoryGB  = $totalMemoryGB
        memoryModules  = $memoryModules
        motherboard    = $motherboard
        bios           = $bios
        physicalDisks  = $physicalDisks
        logicalVolumes = $logicalVolumes
    }
    return (New-CategoryResult -Id "hardware" -Name "硬件信息" -Status $status -Source "CIM + Storage(ReadOnly)" -Data $data -Warnings $warnings.ToArray() -Errors $errors.ToArray() -CurrentStateNote "硬件基础清单采集完成；软件读取不含温度/电压/烤机数据")
}

# --- 模块 4（提前加载驱动映射，供模块 3 设备管理器关联驱动绑定） ---
$DriverLookupByDeviceId = @{}
$DriverCsvRows = [System.Collections.Generic.List[object]]::new()
$SectionDrivers = Invoke-SafeSection -Id "drivers" -Name "驱动信息" -Source "CIM:Win32_PnPSignedDriver" -Action {
    $warnings = [System.Collections.Generic.List[string]]::new()
    $rawDrivers = @(Get-CimInstance -ClassName Win32_PnPSignedDriver -ErrorAction Stop)
    $list = [System.Collections.Generic.List[object]]::new()
    $unsignedOrWarnCount = 0

    foreach ($d in $rawDrivers) {
        if ([string]::IsNullOrWhiteSpace($d.DeviceName) -and [string]::IsNullOrWhiteSpace($d.InfName)) { continue }
        $rawId = [string]$d.DeviceID
        $drvInfo = [ordered]@{
            driverName     = $d.InfName
            friendlyName   = $d.FriendlyName
            deviceName     = $d.DeviceName
            deviceClass    = $d.DeviceClass
            provider       = $d.DriverProviderName
            version        = $d.DriverVersion
            driverDateUtc  = Format-DateUtcIso $d.DriverDate
            isSigned       = $d.IsSigned
            signer         = $d.Signer
            deviceIdMasked = Protect-DeviceInstanceId $rawId
        }
        if ($d.IsSigned -eq $false) { $unsignedOrWarnCount++ }
        if (-not [string]::IsNullOrWhiteSpace($rawId) -and -not $DriverLookupByDeviceId.ContainsKey($rawId)) {
            $DriverLookupByDeviceId[$rawId] = $drvInfo
        }
        $list.Add($drvInfo) | Out-Null
        $DriverCsvRows.Add([PSCustomObject]$drvInfo) | Out-Null
    }

    $status = "NORMAL"
    if ($list.Count -eq 0) {
        $status = "UNKNOWN"
        $warnings.Add("未枚举到任何签名驱动记录，结果不可直接判为正常。")
    } elseif ($unsignedOrWarnCount -gt 0) {
        $status = "SUSPECTED"
        $warnings.Add("检测到 $unsignedOrWarnCount 项未签名驱动记录，建议人工确认来源。")
    }

    $data = [ordered]@{
        totalDrivers      = $list.Count
        unsignedCount     = $unsignedOrWarnCount
        drivers           = if ($Config.collection.collectAllSignedDrivers) { $list.ToArray() } else { @($list | Select-Object -First 200) }
    }
    return (New-CategoryResult -Id "drivers" -Name "驱动信息" -Status $status -Source "CIM:Win32_PnPSignedDriver" -Data $data -Warnings $warnings.ToArray() -CurrentStateNote "已枚举签名驱动清单并供设备管理器关联")
}

# --- 模块 3: 设备管理器（全部即插即用设备） ---
$PnpCsvRows = [System.Collections.Generic.List[object]]::new()
$AllPnpRawCache = @()
$SectionDeviceManager = Invoke-SafeSection -Id "device_manager" -Name "设备管理器（即插即用设备）" -Source "CIM:Win32_PnPEntity" -Action {
    $warnings = [System.Collections.Generic.List[string]]::new()
    $entities = @(Get-CimInstance -ClassName Win32_PnPEntity -ErrorAction Stop)
    $AllPnpRawCache = $entities

    $allDevices = [System.Collections.Generic.List[object]]::new()
    $abnormalDevices = [System.Collections.Generic.List[object]]::new()
    $missingDriverDevices = [System.Collections.Generic.List[object]]::new()
    $unknownDevices = [System.Collections.Generic.List[object]]::new()
    $disabledDevices = [System.Collections.Generic.List[object]]::new()

    foreach ($e in $entities) {
        $rawId = [string]$e.PNPDeviceID
        $errCode = if ($null -ne $e.ConfigManagerErrorCode) { [int]$e.ConfigManagerErrorCode } else { -1 }
        $boundDriver = if ($rawId -and $DriverLookupByDeviceId.ContainsKey($rawId)) { $DriverLookupByDeviceId[$rawId] } else { $null }
        $isUnknown = ($e.PNPClass -eq 'Unknown') -or ($e.Name -match '(?i)(Unknown Device|未知设备)')
        $isDisabled = ($errCode -eq 22)
        $isMissingDriver = ($errCode -eq 28)
        $isError = ($errCode -gt 0 -and $errCode -ne 22)

        $devStatus = "NORMAL"
        if ($isError -or $isMissingDriver) { $devStatus = "ABNORMAL" }
        elseif ($isDisabled -or $isUnknown) { $devStatus = "SUSPECTED" }
        elseif ($errCode -lt 0) { $devStatus = "UNKNOWN" }

        $item = [ordered]@{
            name                   = $e.Name
            deviceClass            = $e.PNPClass
            manufacturer           = $e.Manufacturer
            instanceId             = Protect-DeviceInstanceId $rawId
            pnpStatus              = $e.Status
            configManagerErrorCode = $errCode
            errorDescription       = Get-ConfigManagerErrorText $errCode
            driverBound            = ($null -ne $boundDriver)
            driverName             = if ($boundDriver) { $boundDriver.driverName } else { $null }
            driverVersion          = if ($boundDriver) { $boundDriver.version } else { $null }
            driverProvider         = if ($boundDriver) { $boundDriver.provider } else { $null }
            diagnosticStatus       = $devStatus
        }

        $allDevices.Add($item) | Out-Null
        $PnpCsvRows.Add([PSCustomObject]$item) | Out-Null

        if ($isError -or $isMissingDriver) { $abnormalDevices.Add($item) | Out-Null }
        if ($isMissingDriver) { $missingDriverDevices.Add($item) | Out-Null }
        if ($isUnknown) { $unknownDevices.Add($item) | Out-Null }
        if ($isDisabled) { $disabledDevices.Add($item) | Out-Null }
    }

    $overall = "NORMAL"
    if ($abnormalDevices.Count -gt 0 -or $missingDriverDevices.Count -gt 0) {
        $overall = "ABNORMAL"
        $warnings.Add("发现 $($abnormalDevices.Count) 个异常设备、$($missingDriverDevices.Count) 个驱动缺失设备。")
    } elseif ($unknownDevices.Count -gt 0 -or $disabledDevices.Count -gt 0) {
        $overall = "SUSPECTED"
        $warnings.Add("发现 $($unknownDevices.Count) 个未知设备、$($disabledDevices.Count) 个已禁用设备，请核实是否为主动禁用。")
    } elseif ($allDevices.Count -eq 0) {
        $overall = "UNKNOWN"
        $warnings.Add("未枚举到任何即插即用设备。")
    }

    $data = [ordered]@{
        totalCount           = $allDevices.Count
        abnormalCount        = $abnormalDevices.Count
        missingDriverCount   = $missingDriverDevices.Count
        unknownDeviceCount   = $unknownDevices.Count
        disabledDeviceCount  = $disabledDevices.Count
        abnormalDevices      = $abnormalDevices.ToArray()
        missingDriverDevices = $missingDriverDevices.ToArray()
        unknownDevices       = $unknownDevices.ToArray()
        disabledDevices      = $disabledDevices.ToArray()
        allDevices           = if ($Config.collection.collectAllPnpDevices) { $allDevices.ToArray() } else { @() }
    }
    return (New-CategoryResult -Id "device_manager" -Name "设备管理器（即插即用设备）" -Status $overall -Source "CIM:Win32_PnPEntity" -Data $data -Warnings $warnings.ToArray() -CurrentStateNote "已枚举当前实时 PnP 设备状态与错误码")
}

# --- 模块 5: 接口与外设 ---
$SectionInterfaces = Invoke-SafeSection -Id "interfaces_and_peripherals" -Name "接口与外设" -Source "CIM:Win32_PnPEntity 分类归集 + StorageControllers" -Action {
    $warnings = [System.Collections.Generic.List[string]]::new()
    $sourceList = if ($AllPnpRawCache.Count -gt 0) { $AllPnpRawCache } else { @(Get-CimInstance -ClassName Win32_PnPEntity -ErrorAction Stop) }

    function Select-DevicesByFilter {
        param($Items, [scriptblock]$Predicate)
        return @($Items | Where-Object $Predicate | ForEach-Object {
            [ordered]@{
                name                   = $_.Name
                deviceClass            = $_.PNPClass
                manufacturer           = $_.Manufacturer
                instanceId             = Protect-DeviceInstanceId ([string]$_.PNPDeviceID)
                pnpStatus              = $_.Status
                configManagerErrorCode = $_.ConfigManagerErrorCode
            }
        })
    }

    $usbDevices       = Select-DevicesByFilter $sourceList { $_.PNPClass -eq 'USB' -or ([string]$_.PNPDeviceID) -like 'USB\*' }
    $pciDevices       = Select-DevicesByFilter $sourceList { ([string]$_.PNPDeviceID) -like 'PCI\*' }
    $storageCtrl      = Select-DevicesByFilter $sourceList { $_.PNPClass -in @('SCSIAdapter', 'HDC') -or $_.Name -match '(?i)(NVMe|SATA|AHCI|RAID|Storage Controller)' }
    $networkDevices   = Select-DevicesByFilter $sourceList { $_.PNPClass -eq 'Net' }
    $audioDevices     = Select-DevicesByFilter $sourceList { $_.PNPClass -in @('MEDIA', 'AudioEndpoint') }
    $bluetoothDevices = Select-DevicesByFilter $sourceList { $_.PNPClass -eq 'Bluetooth' }
    $displayDevices   = Select-DevicesByFilter $sourceList { $_.PNPClass -in @('Monitor', 'Display') }
    $otherPeripherals = Select-DevicesByFilter $sourceList { $_.PNPClass -in @('HIDClass', 'Camera', 'Image', 'Ports', 'Biometric', 'SmartCardReader', 'Keyboard', 'Mouse') }

    $abnCount = @($sourceList | Where-Object {
        $_.PNPClass -in @('USB', 'SCSIAdapter', 'HDC', 'Net', 'MEDIA', 'AudioEndpoint', 'Bluetooth', 'Monitor', 'Display', 'HIDClass', 'Ports') -and
        $null -ne $_.ConfigManagerErrorCode -and [int]$_.ConfigManagerErrorCode -gt 0 -and [int]$_.ConfigManagerErrorCode -ne 22
    }).Count

    $status = if ($abnCount -gt 0) { "ABNORMAL" } elseif ($sourceList.Count -eq 0) { "UNKNOWN" } else { "NORMAL" }
    if ($abnCount -gt 0) { $warnings.Add("接口与外设类别中发现 $abnCount 个非 0 错误码设备。") }
    if ($bluetoothDevices.Count -eq 0) { $warnings.Add("未检测到蓝牙设备（若本机无蓝牙硬件则属正常）。") }

    $data = [ordered]@{
        counts = [ordered]@{
            usb                = $usbDevices.Count
            pci                = $pciDevices.Count
            sataNvmeController = $storageCtrl.Count
            networkAdapter     = $networkDevices.Count
            audio              = $audioDevices.Count
            bluetooth          = $bluetoothDevices.Count
            display            = $displayDevices.Count
            otherPeripherals   = $otherPeripherals.Count
        }
        usbDevices         = $usbDevices
        pciDevices         = $pciDevices
        storageControllers = $storageCtrl
        networkDevices     = $networkDevices
        audioDevices       = $audioDevices
        bluetoothDevices   = $bluetoothDevices
        displayDevices     = $displayDevices
        otherPeripherals   = $otherPeripherals
    }
    return (New-CategoryResult -Id "interfaces_and_peripherals" -Name "接口与外设" -Status $status -Source "CIM:Win32_PnPEntity" -Data $data -Warnings $warnings.ToArray() -CurrentStateNote "已按 USB/PCI/SATA-NVMe/网卡/音频/蓝牙/显示/外设分类枚举")
}

# --- 模块 6: 电源信息 ---
$SectionPower = Invoke-SafeSection -Id "power" -Name "电源信息" -Source "powercfg(ReadOnly) + CIM:Win32_Battery" -Action {
    $warnings = [System.Collections.Generic.List[string]]::new()
    $warnings.Add("重要边界声明：软件无法直接检测电源供应器（PSU）硬件质量、供电纹波或负载能力，PSU 硬件健康状态恒定标记为 UNKNOWN。")

    $activeScheme = $null
    $allSchemes = @()
    $sleepStates = @()
    $powercfgFailed = $false

    try {
        $activeScheme = (& powercfg.exe /getactivescheme 2>&1 | Out-String).Trim()
        $listRaw = (& powercfg.exe /list 2>&1 | Out-String)
        $allSchemes = @($listRaw -split "`r?`n" | Where-Object { $_ -match 'GUID' } | ForEach-Object { $_.Trim() })
        $sleepRaw = (& powercfg.exe /availablesleepstates 2>&1 | Out-String)
        $sleepStates = @($sleepRaw -split "`r?`n" | Where-Object { -not [string]::IsNullOrWhiteSpace($_) } | ForEach-Object { $_.Trim() })
    } catch {
        $powercfgFailed = $true
        $warnings.Add("powercfg 只读查询失败：$($_.Exception.Message)")
    }

    $batteryStatus = "NOT_SUPPORTED"
    $batteries = @()
    try {
        $batRaw = @(Get-CimInstance -ClassName Win32_Battery -ErrorAction Stop)
        if ($batRaw.Count -gt 0) {
            $batteryStatus = "NORMAL"
            $batteries = @($batRaw | ForEach-Object {
                if ($_.Status -and $_.Status -ne 'OK') { $batteryStatus = "SUSPECTED" }
                [ordered]@{
                    name                     = $_.Name
                    status                   = $_.Status
                    batteryStatusCode        = $_.BatteryStatus
                    estimatedChargeRemaining = $_.EstimatedChargeRemaining
                    estimatedRunTimeMinutes  = $_.EstimatedRunTime
                    designVoltageMv          = $_.DesignVoltage
                }
            })
        }
    } catch {
        $batteryStatus = "FAILED"
        $warnings.Add("电池状态查询失败：$($_.Exception.Message)")
    }

    # 查询最近回溯窗口内 Kernel-Power 41 关键事件计数（仅作电源异常线索，不直接断言 PSU 损坏）
    $kp41Count = $null
    try {
        $startTime = (Get-Date).AddDays(-[int]$Config.collection.logLookbackDays)
        $kpEvents = @(Get-WinEvent -FilterHashtable @{ LogName = 'System'; ProviderName = 'Microsoft-Windows-Kernel-Power'; Id = 41; StartTime = $startTime } -ErrorAction SilentlyContinue)
        $kp41Count = $kpEvents.Count
    } catch {
        $kp41Count = $null
    }

    $status = "NORMAL"
    if ($powercfgFailed) { $status = "FAILED" }
    elseif ($null -ne $kp41Count -and $kp41Count -gt 0) {
        $status = "SUSPECTED"
        $warnings.Add("最近 $($Config.collection.logLookbackDays) 天内存在 $kp41Count 条 Kernel-Power 41（意外断电/重启）历史记录；该事件可能由供电、驱动、过热或强制关机引起，不能仅凭此断言 PSU 故障。")
    }

    $data = [ordered]@{
        activePowerScheme            = $activeScheme
        availablePowerSchemes        = $allSchemes
        supportedSleepStates         = $sleepStates
        batteryCollectionStatus      = $batteryStatus
        batteries                    = $batteries
        recentKernelPower41Count     = $kp41Count
        psuHardwareQualityStatus     = "UNKNOWN"
        psuHardwareQualityNote       = "无法通过纯软件测量电源供应器（PSU）硬件质量或真实供电稳定性，必须标记为 UNKNOWN。"
    }
    return (New-CategoryResult -Id "power" -Name "电源信息" -Status $status -Source "powercfg(ReadOnly) + Win32_Battery + Kernel-Power" -Data $data -Warnings $warnings.ToArray() -CurrentStateNote "电源计划与睡眠能力已读取；PSU 硬件质量不可测（UNKNOWN）")
}

# --- 模块 7: 系统日志 ---
$EventCsvRows = [System.Collections.Generic.List[object]]::new()
$SectionLogs = Invoke-SafeSection -Id "system_logs" -Name "系统日志与可靠性事件" -Source "Get-WinEvent(ReadOnly)" -Action {
    $lookbackDays = [int]$Config.collection.logLookbackDays
    $maxPerCat = [int]$Config.collection.maxEventsPerCategory
    $queryEndLocal = Get-Date
    $queryStartLocal = $queryEndLocal.AddDays(-$lookbackDays)
    $queryParams = [ordered]@{
        lookbackDays         = $lookbackDays
        maxEventsPerCategory = $maxPerCat
        queryStartUtc        = $queryStartLocal.ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
        queryEndUtc          = $queryEndLocal.ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
    }

    $warnings = [System.Collections.Generic.List[string]]::new()
    $errors = [System.Collections.Generic.List[string]]::new()
    $accessDeniedCount = 0
    $failedCount = 0

    function Invoke-EventQuery {
        param(
            [string]$CategoryTag,
            [hashtable]$FilterHash,
            [int]$MaxEvents
        )
        try {
            $evts = @(Get-WinEvent -FilterHashtable $FilterHash -MaxEvents $MaxEvents -ErrorAction Stop)
            $mapped = @($evts | ForEach-Object {
                $msg = if ($_.Message) {
                    $clean = ($_.Message -replace '\r?\n', ' ')
                    if ($clean.Length -gt 320) { $clean = $clean.Substring(0, 320) + "..." }
                    Protect-Text -Text $clean
                } else { "" }
                $row = [ordered]@{
                    category        = $CategoryTag
                    timeCreatedUtc  = Format-DateUtcIso $_.TimeCreated
                    logName         = $_.LogName
                    providerName    = $_.ProviderName
                    eventId         = $_.Id
                    level           = $_.LevelDisplayName
                    message         = $msg
                }
                $EventCsvRows.Add([PSCustomObject]$row) | Out-Null
                $row
            })
            return [ordered]@{ status = "NORMAL"; count = $mapped.Count; events = $mapped; note = $null }
        } catch {
            # 没有匹配事件时 Get-WinEvent 会抛出 NoMatchingEventsFound，这属于正常空结果
            if ($_.Exception.Message -match '(No events were found|找不到任何事件)' -or $_.FullyQualifiedErrorId -match 'NoMatchingEventsFound') {
                return [ordered]@{ status = "NORMAL"; count = 0; events = @(); note = "查询时间窗口内无匹配记录" }
            }
            if (Test-IsAccessDeniedError $_) {
                return [ordered]@{ status = "ACCESS_DENIED"; count = $null; events = @(); note = "权限不足，无法读取该日志通道或筛选器" }
            }
            return [ordered]@{ status = "FAILED"; count = $null; events = @(); note = Protect-Text -Text $_.Exception.Message }
        }
    }

    $qSystemErrors   = Invoke-EventQuery "SystemError"    @{ LogName = 'System'; Level = @(1, 2); StartTime = $queryStartLocal } $maxPerCat
    $qSystemWarnings = Invoke-EventQuery "SystemWarning"  @{ LogName = 'System'; Level = 3;       StartTime = $queryStartLocal } $maxPerCat
    $qUnexpectedPwr  = Invoke-EventQuery "KernelPower_UnexpectedShutdown" @{ LogName = 'System'; Id = @(41, 6008, 1074); StartTime = $queryStartLocal } $maxPerCat
    $qBugcheck       = Invoke-EventQuery "BugCheck_BSOD"  @{ LogName = 'System'; Id = @(1001, 161, 162); StartTime = $queryStartLocal } $maxPerCat
    $qDriverErrors   = Invoke-EventQuery "Driver_ServiceError" @{ LogName = 'System'; Id = @(219, 7000, 7001, 7026, 7031); StartTime = $queryStartLocal } $maxPerCat
    $qWhea           = Invoke-EventQuery "WHEA_Hardware"  @{ LogName = 'System'; ProviderName = 'Microsoft-Windows-WHEA-Logger'; StartTime = $queryStartLocal } $maxPerCat
    $qStorageErrors  = Invoke-EventQuery "Storage_Disk"   @{ LogName = 'System'; ProviderName = @('disk', 'ntfs', 'storahci', 'stornvme', 'volsnap', 'partmgr'); Level = @(1, 2, 3); StartTime = $queryStartLocal } $maxPerCat

    $allQueries = @($qSystemErrors, $qSystemWarnings, $qUnexpectedPwr, $qBugcheck, $qDriverErrors, $qWhea, $qStorageErrors)
    foreach ($q in $allQueries) {
        if ($q.status -eq "ACCESS_DENIED") { $accessDeniedCount++ }
        elseif ($q.status -eq "FAILED") { $failedCount++ }
    }

    $criticalHistorical = 0
    if ($qUnexpectedPwr.count) { $criticalHistorical += $qUnexpectedPwr.count }
    if ($qBugcheck.count)      { $criticalHistorical += $qBugcheck.count }
    if ($qWhea.count)          { $criticalHistorical += $qWhea.count }
    if ($qStorageErrors.count) { $criticalHistorical += $qStorageErrors.count }

    $overall = "NORMAL"
    if ($failedCount -eq $allQueries.Count) {
        $overall = "FAILED"
        $errors.Add("全部系统日志查询均失败，不得判断为正常。")
    } elseif ($accessDeniedCount -eq $allQueries.Count) {
        $overall = "ACCESS_DENIED"
        $warnings.Add("权限不足，无法读取系统日志，可尝试管理员权限重跑。")
    } elseif ($criticalHistorical -gt 0 -or ($qSystemErrors.count -and $qSystemErrors.count -gt 0)) {
        $overall = "SUSPECTED"
        $warnings.Add("最近 $lookbackDays 天内存在历史错误/关键事件（意外关机/蓝屏/WHEA/存储/系统错误）。注意：日志属历史事件线索，严禁仅凭单一日志断言硬件损坏，需结合当前状态与复现情况综合判断。")
    } elseif ($failedCount -gt 0 -or $accessDeniedCount -gt 0) {
        $overall = "SUSPECTED"
        $warnings.Add("部分日志类别读取受限或失败（权限不足: $accessDeniedCount，失败: $failedCount）。")
    }

    $data = [ordered]@{
        queryWindowNote             = "默认回溯最近 $lookbackDays 天，每类最多保留 $maxPerCat 条；以下均为历史事件记录，区别于当前实时状态。"
        systemErrors                = $qSystemErrors
        systemWarnings              = $qSystemWarnings
        unexpectedShutdownAndPower  = $qUnexpectedPwr
        bugcheckAndBsod             = $qBugcheck
        driverAndServiceErrors      = $qDriverErrors
        wheaHardwareEvents          = $qWhea
        storageAndDiskErrors        = $qStorageErrors
    }
    return (New-CategoryResult -Id "system_logs" -Name "系统日志与可靠性事件" -Status $overall -Source "Get-WinEvent(System)" -Data $data -Warnings $warnings.ToArray() -Errors $errors.ToArray() -CurrentStateNote "已区分历史事件与当前实时状态；空查询按 0 条正常记录" -QueryParameters $queryParams)
}

# --- 模块 8: 网络信息 ---
$NetCsvRows = [System.Collections.Generic.List[object]]::new()
$SectionNetwork = Invoke-SafeSection -Id "network" -Name "网络信息" -Source "NetAdapter/NetIPConfiguration + CIM:Win32_NetworkAdapterConfiguration" -Action {
    $warnings = [System.Collections.Generic.List[string]]::new()
    $adapters = [System.Collections.Generic.List[object]]::new()
    $hasAbnormal = $false

    $useNetAdapter = ($null -ne (Get-Command -Name Get-NetAdapter -ErrorAction SilentlyContinue))
    if ($useNetAdapter) {
        try {
            $netRaw = @(Get-NetAdapter -ErrorAction Stop)
            $ipConfigs = @{}
            try {
                foreach ($ic in @(Get-NetIPConfiguration -ErrorAction SilentlyContinue)) {
                    $ipConfigs[$ic.InterfaceIndex] = $ic
                }
            } catch { }

            foreach ($n in $netRaw) {
                $ic = if ($ipConfigs.ContainsKey($n.ifIndex)) { $ipConfigs[$n.ifIndex] } else { $null }
                $ipv4 = if ($ic -and $ic.IPv4Address) { @($ic.IPv4Address | ForEach-Object { Protect-Text -Text $_.IPAddress }) } else { @() }
                $ipv6 = if ($ic -and $ic.IPv6Address) { @($ic.IPv6Address | ForEach-Object { Protect-Text -Text $_.IPAddress }) } else { @() }
                $gw   = if ($ic -and $ic.IPv4DefaultGateway) { @($ic.IPv4DefaultGateway | ForEach-Object { Protect-Text -Text $_.NextHop }) } else { @() }
                $dns  = if ($ic -and $ic.DNSServer) { @($ic.DNSServer | ForEach-Object { $_.ServerAddresses } | ForEach-Object { Protect-Text -Text $_ }) } else { @() }

                $item = [ordered]@{
                    name            = $n.Name
                    description     = $n.InterfaceDescription
                    status          = [string]$n.Status
                    linkSpeed       = [string]$n.LinkSpeed
                    macAddress      = Protect-Mac ([string]$n.MacAddress)
                    driverName      = $n.DriverFileName
                    driverVersion   = $n.DriverVersion
                    driverDate      = [string]$n.DriverDate
                    driverProvider  = $n.DriverProvider
                    ipv4Addresses   = $ipv4
                    ipv6Addresses   = $ipv6
                    defaultGateways = $gw
                    dnsServers      = $dns
                }
                if ($n.Status -match '(?i)(Error|Not Present)') { $hasAbnormal = $true }
                $adapters.Add($item) | Out-Null
                $NetCsvRows.Add([PSCustomObject]@{
                    name           = $item.name
                    description    = $item.description
                    status         = $item.status
                    linkSpeed      = $item.linkSpeed
                    macAddress     = $item.macAddress
                    driverVersion  = $item.driverVersion
                    ipv4           = ($ipv4 -join '; ')
                    gateways       = ($gw -join '; ')
                    dns            = ($dns -join '; ')
                }) | Out-Null
            }
        } catch {
            $warnings.Add("Get-NetAdapter 读取失败，回退 CIM 查询：$($_.Exception.Message)")
            $useNetAdapter = $false
        }
    }

    if (-not $useNetAdapter) {
        $cimNet = @(Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration -Filter "IPEnabled=TRUE" -ErrorAction Stop)
        foreach ($c in $cimNet) {
            $ips = if ($c.IPAddress) { @($c.IPAddress | ForEach-Object { Protect-Text -Text $_ }) } else { @() }
            $gws = if ($c.DefaultIPGateway) { @($c.DefaultIPGateway | ForEach-Object { Protect-Text -Text $_ }) } else { @() }
            $dns = if ($c.DNSServerSearchOrder) { @($c.DNSServerSearchOrder | ForEach-Object { Protect-Text -Text $_ }) } else { @() }
            $item = [ordered]@{
                name            = $c.ServiceName
                description     = $c.Description
                status          = "IPEnabled"
                linkSpeed       = "UNKNOWN"
                macAddress      = Protect-Mac ([string]$c.MACAddress)
                driverName      = $null
                driverVersion   = $null
                driverDate      = $null
                driverProvider  = $null
                ipv4Addresses   = $ips
                ipv6Addresses   = @()
                defaultGateways = $gws
                dnsServers      = $dns
            }
            $adapters.Add($item) | Out-Null
            $NetCsvRows.Add([PSCustomObject]@{
                name          = $item.name
                description   = $item.description
                status        = $item.status
                linkSpeed     = $item.linkSpeed
                macAddress    = $item.macAddress
                driverVersion = ""
                ipv4          = ($ips -join '; ')
                gateways      = ($gws -join '; ')
                dns           = ($dns -join '; ')
            }) | Out-Null
        }
    }

    $status = if ($hasAbnormal) { "ABNORMAL" } elseif ($adapters.Count -eq 0) { "UNKNOWN" } else { "NORMAL" }
    $data = [ordered]@{
        adapterCount = $adapters.Count
        adapters     = $adapters.ToArray()
    }
    return (New-CategoryResult -Id "network" -Name "网络信息" -Status $status -Source "NetAdapter / CIM(ReadOnly)" -Data $data -Warnings $warnings.ToArray() -CurrentStateNote "已采集网卡状态、驱动及脱敏后的 IP/MAC/DNS/网关信息")
}

# ============================================================================
# 4. 汇总诊断报告并输出 JSON / CSV / TXT / RUN_LOG
# ============================================================================
$Categories = @(
    $SectionOs,
    $SectionHardware,
    $SectionDeviceManager,
    $SectionDrivers,
    $SectionInterfaces,
    $SectionPower,
    $SectionLogs,
    $SectionNetwork
)

$StatusCounts = [ordered]@{
    NORMAL        = 0
    ABNORMAL      = 0
    UNKNOWN       = 0
    FAILED        = 0
    ACCESS_DENIED = 0
    NOT_SUPPORTED = 0
    SUSPECTED     = 0
}
foreach ($c in $Categories) {
    if ($StatusCounts.Contains($c.status)) {
        $StatusCounts[$c.status]++
    }
}

$FinishedUtc = (Get-Date).ToUniversalTime()
$TotalDurationMs = [int](($FinishedUtc - $RunStartUtc).TotalMilliseconds)

$FullReport = [ordered]@{
    schemaVersion   = $Config.schemaVersion
    toolName        = "WinDevice-Inspector Standalone Diagnostic Collector (WDI-DIAG-001)"
    toolVersion     = $Config.toolVersion
    collectedAtUtc  = $RunStartUtc.ToString("yyyy-MM-ddTHH:mm:ssZ")
    finishedAtUtc   = $FinishedUtc.ToString("yyyy-MM-ddTHH:mm:ssZ")
    totalDurationMs = $TotalDurationMs
    timeZoneId      = [System.TimeZoneInfo]::Local.Id
    environment     = [ordered]@{
        powerShellEdition = $PsEditionString
        powerShellVersion = $PsVersionString
        isAdministrator   = $IsAdmin
        readOnlyGuaranteed = $true
    }
    privacySettings = $Config.privacy
    summary         = [ordered]@{
        categoryStatusCounts = $StatusCounts
        evidenceRules        = @(
            "禁止将读取失败或权限不足判断为 NORMAL。",
            "禁止仅凭单一历史日志事件断言硬件损坏。",
            "软件无法直接测量 PSU 电源硬件质量，PSU 状态恒为 UNKNOWN。",
            "已区分当前实时状态（设备管理器/磁盘健康）与历史日志事件。"
        )
    }
    categories      = $Categories
}

# 4.1 写出 JSON（UTF-8 无 BOM）
$JsonPath = Join-Path $RunOutputDir "diagnostic_data.json"
$JsonContent = $FullReport | ConvertTo-Json -Depth 12
[System.IO.File]::WriteAllText($JsonPath, $JsonContent, [System.Text.UTF8Encoding]::new($false))
Write-DiagLog "已生成完整 JSON 数据: $JsonPath"

# 4.2 写出 CSV（UTF-8 带 BOM，防止中文 Excel 乱码）
$CsvGenerated = [System.Collections.Generic.List[string]]::new()
function Export-Utf8BomCsv {
    param($Rows, [string]$Path)
    if ($null -eq $Rows -or $Rows.Count -eq 0) { return }
    $csvLines = $Rows | ConvertTo-Csv -NoTypeInformation
    $csvText = ($csvLines -join "`r`n") + "`r`n"
    [System.IO.File]::WriteAllText($Path, $csvText, [System.Text.UTF8Encoding]::new($true))
    $CsvGenerated.Add($Path) | Out-Null
}

if ($Config.collection.includeCsvReports) {
    Export-Utf8BomCsv -Rows $PnpCsvRows    -Path (Join-Path $CsvDir "devices_pnp.csv")
    Export-Utf8BomCsv -Rows $DriverCsvRows -Path (Join-Path $CsvDir "drivers.csv")
    Export-Utf8BomCsv -Rows $EventCsvRows  -Path (Join-Path $CsvDir "system_events.csv")
    Export-Utf8BomCsv -Rows $DiskCsvRows   -Path (Join-Path $CsvDir "disks_and_volumes.csv")
    Export-Utf8BomCsv -Rows $NetCsvRows    -Path (Join-Path $CsvDir "network_adapters.csv")
    Write-DiagLog "已生成 $($CsvGenerated.Count) 份 CSV 表格文件（目录: $CsvDir）"
}

# 4.3 写出 TXT 综合诊断报告（UTF-8 带 BOM，便于 Windows 记事本及 AI 直接阅读）
$TxtPath = Join-Path $RunOutputDir "diagnostic_report.txt"
$sb = [System.Text.StringBuilder]::new()
$null = $sb.AppendLine("================================================================================")
$null = $sb.AppendLine("  WinDevice-Inspector 综合诊断报告 (WDI-DIAG-001)")
$null = $sb.AppendLine("================================================================================")
$null = $sb.AppendLine("采集开始时间 (UTC) : $($FullReport.collectedAtUtc)")
$null = $sb.AppendLine("本地时区           : $($FullReport.timeZoneId)")
$null = $sb.AppendLine("采集总耗时         : $TotalDurationMs ms")
$null = $sb.AppendLine("PowerShell 环境    : $PsEditionString $PsVersionString")
$null = $sb.AppendLine("运行权限           : $(if ($IsAdmin) { '管理员权限' } else { '普通用户权限（未提权）' })")
$null = $sb.AppendLine("隐私脱敏总开关     : $(if ($Config.privacy.enabled) { '已开启（默认脱敏用户名/主机名/IP/MAC/序列号/设备唯一ID）' } else { '已关闭（含原始标识，分享前请自行核查）' })")
$null = $sb.AppendLine("只读安全声明       : 本次采集严格只读，未修改注册表、系统设置、驱动或日志，未上传任何数据。")
$null = $sb.AppendLine("")
$null = $sb.AppendLine("--------------------------------------------------------------------------------")
$null = $sb.AppendLine("一、各采集模块状态总览（区分实时状态与历史线索）")
$null = $sb.AppendLine("--------------------------------------------------------------------------------")
foreach ($c in $Categories) {
    $null = $sb.AppendLine(("  - [{0,-13}] {1} ({2} ms) | {3}" -f $c.status, $c.name, $c.durationMs, $c.currentStateNote))
    foreach ($w in $c.warnings) {
        $null = $sb.AppendLine("      [提示] $w")
    }
    foreach ($e in $c.errors) {
        $null = $sb.AppendLine("      [错误] $e")
    }
}

$null = $sb.AppendLine("")
$null = $sb.AppendLine("--------------------------------------------------------------------------------")
$null = $sb.AppendLine("二、重点异常与可疑线索摘要（供 AI 快速定位）")
$null = $sb.AppendLine("--------------------------------------------------------------------------------")
if ($SectionDeviceManager.data) {
    $dm = $SectionDeviceManager.data
    $null = $sb.AppendLine("  设备管理器统计: 总设备 $($dm.totalCount) | 异常 $($dm.abnormalCount) | 驱动缺失 $($dm.missingDriverCount) | 未知 $($dm.unknownDeviceCount) | 已禁用 $($dm.disabledDeviceCount)")
    foreach ($ad in @($dm.abnormalDevices | Select-Object -First 30)) {
        $null = $sb.AppendLine("    * [异常设备] $($ad.name) | 类别:$($ad.deviceClass) | 错误码:$($ad.configManagerErrorCode) ($($ad.errorDescription)) | ID:$($ad.instanceId)")
    }
    foreach ($ud in @($dm.unknownDevices | Select-Object -First 20)) {
        $null = $sb.AppendLine("    * [未知设备] $($ud.name) | 错误码:$($ud.configManagerErrorCode) | ID:$($ud.instanceId)")
    }
}
if ($SectionPower.data) {
    $null = $sb.AppendLine("  电源与 PSU 声明: PSU 硬件质量 = $($SectionPower.data.psuHardwareQualityStatus)（$($SectionPower.data.psuHardwareQualityNote)）")
    $null = $sb.AppendLine("  当前电源计划   : $($SectionPower.data.activePowerScheme)")
    $null = $sb.AppendLine("  电池状态       : $($SectionPower.data.batteryCollectionStatus)")
}
if ($SectionLogs.data) {
    $ld = $SectionLogs.data
    $null = $sb.AppendLine("  日志查询窗口   : $($SectionLogs.queryParameters.queryStartUtc) ~ $($SectionLogs.queryParameters.queryEndUtc)（最近 $($SectionLogs.queryParameters.lookbackDays) 天）")
    $null = $sb.AppendLine("  系统错误(L1/2) : $($ld.systemErrors.count) [$($ld.systemErrors.status)] | 系统警告(L3): $($ld.systemWarnings.count) [$($ld.systemWarnings.status)]")
    $null = $sb.AppendLine("  意外关机/KP41  : $($ld.unexpectedShutdownAndPower.count) [$($ld.unexpectedShutdownAndPower.status)] | 蓝屏/BugCheck: $($ld.bugcheckAndBsod.count) [$($ld.bugcheckAndBsod.status)]")
    $null = $sb.AppendLine("  WHEA 硬件事件  : $($ld.wheaHardwareEvents.count) [$($ld.wheaHardwareEvents.status)] | 驱动错误: $($ld.driverAndServiceErrors.count) [$($ld.driverAndServiceErrors.status)] | 存储错误: $($ld.storageAndDiskErrors.count) [$($ld.storageAndDiskErrors.status)]")
}

$null = $sb.AppendLine("")
$null = $sb.AppendLine("--------------------------------------------------------------------------------")
$null = $sb.AppendLine("三、系统与核心硬件摘要")
$null = $sb.AppendLine("--------------------------------------------------------------------------------")
if ($SectionOs.data) {
    $o = $SectionOs.data
    $null = $sb.AppendLine("  操作系统 : $($o.caption) ($($o.displayVersion) / Build $($o.fullBuild) / $($o.architecture))")
    $null = $sb.AppendLine("  安装日期 : $($o.installDateUtc) | 上次启动: $($o.lastBootUpUtc) | 已运行: $($o.uptimeReadable)")
}
if ($SectionHardware.data) {
    $h = $SectionHardware.data
    foreach ($cpu in $h.cpus) {
        $null = $sb.AppendLine("  CPU      : $($cpu.name) | $($cpu.cores) 核 / $($cpu.logicalProcessors) 线程 | 基准最大 $($cpu.maxClockSpeedMhz) MHz")
    }
    foreach ($gpu in $h.gpus) {
        $null = $sb.AppendLine("  GPU      : $($gpu.name) | 显存: $($gpu.vramMB) MB ($($gpu.vramSourceNote)) | 驱动: $($gpu.driverVersion) ($($gpu.driverDateUtc)) | 状态: $($gpu.status)")
    }
    $null = $sb.AppendLine("  总内存   : $($h.totalMemoryGB) GB（共 $(@($h.memoryModules).Count) 条可识别内存插槽）")
    if ($h.motherboard) {
        $null = $sb.AppendLine("  主板     : $($h.motherboard.manufacturer) $($h.motherboard.product) ($($h.motherboard.version))")
    }
    if ($h.bios) {
        $null = $sb.AppendLine("  BIOS     : $($h.bios.manufacturer) $($h.bios.smbiosVersion) ($($h.bios.releaseDateUtc))")
    }
    foreach ($pd in $h.physicalDisks) {
        $null = $sb.AppendLine("  物理磁盘 : $($pd.model) | $($pd.sizeGB) GB | $($pd.mediaType) / $($pd.busType) | 健康: $($pd.healthStatus) | 序列号: $($pd.serialNumber)")
    }
    foreach ($lv in $h.logicalVolumes) {
        $null = $sb.AppendLine("  逻辑卷   : $($lv.driveLetter) ($($lv.fileSystem)) | 总计 $($lv.sizeGB) GB | 剩余 $($lv.freeSpaceGB) GB ($($lv.freePercent)%)")
    }
}

$null = $sb.AppendLine("")
$null = $sb.AppendLine("--------------------------------------------------------------------------------")
$null = $sb.AppendLine("四、接口与外设 / 网络摘要")
$null = $sb.AppendLine("--------------------------------------------------------------------------------")
if ($SectionInterfaces.data) {
    $cnt = $SectionInterfaces.data.counts
    $null = $sb.AppendLine("  接口统计 : USB=$($cnt.usb), PCI=$($cnt.pci), SATA/NVMe控制器=$($cnt.sataNvmeController), 网卡=$($cnt.networkAdapter), 音频=$($cnt.audio), 蓝牙=$($cnt.bluetooth), 显示=$($cnt.display), 其他外设=$($cnt.otherPeripherals)")
}
if ($SectionNetwork.data) {
    foreach ($na in $SectionNetwork.data.adapters) {
        $null = $sb.AppendLine("  网卡     : $($na.name) ($($na.description)) | 状态:$($na.status) | 速率:$($na.linkSpeed) | MAC:$($na.macAddress) | IP:$($na.ipv4Addresses -join ', ')")
    }
}

$null = $sb.AppendLine("")
$null = $sb.AppendLine("--------------------------------------------------------------------------------")
$null = $sb.AppendLine("五、给 AI 分析师的阅读指引")
$null = $sb.AppendLine("--------------------------------------------------------------------------------")
$null = $sb.AppendLine("  1. 如需完整设备列表、驱动版本与原始事件明细，请同时参考同目录 diagnostic_data.json 及 csv/ 表格。")
$null = $sb.AppendLine("  2. 任何标注为 FAILED / ACCESS_DENIED / UNKNOWN / NOT_SUPPORTED 的项目均不可视为正常。")
$null = $sb.AppendLine("  3. 历史日志事件（如单次 Kernel-Power 41 或 WHEA）仅作排查线索，请结合当前实时状态与用户症状综合分析。")
$null = $sb.AppendLine("================================================================================")

[System.IO.File]::WriteAllText($TxtPath, $sb.ToString(), [System.Text.UTF8Encoding]::new($true))
Write-DiagLog "已生成综合 TXT 报告: $TxtPath"

# 4.4 写出运行日志
$LogPath = Join-Path $RunOutputDir "run_log.txt"
[System.IO.File]::WriteAllText($LogPath, ($RunLogLines -join "`r`n") + "`r`n", [System.Text.UTF8Encoding]::new($true))

Write-Host ""
Write-Host "================ 诊断报告已生成 ================"
Write-Host "保存目录: $RunOutputDir"
Write-Host "  - 综合文本报告 : diagnostic_report.txt"
Write-Host "  - 完整结构数据 : diagnostic_data.json"
if ($Config.collection.includeCsvReports) {
    Write-Host "  - CSV 表格目录 : csv\"
}
Write-Host "  - 采集运行日志 : run_log.txt"
Write-Host "================================================"
exit 0
