@echo off
setlocal EnableExtensions DisableDelayedExpansion

:: ============================================================================
:: WinDevice-Inspector - WDI-DIAG-001
:: Windows 11 一键诊断信息采集工具（只读、本地优先、默认隐私脱敏）
:: 注意：本文件采用 UTF-8 无 BOM + CRLF，并通过 chcp 65001 适配中文路径与输出
:: ============================================================================

chcp 65001 >nul 2>&1
title WinDevice-Inspector 一键诊断信息采集工具 (WDI-DIAG-001)

echo ============================================================================
echo   WinDevice-Inspector - Windows 11 一键诊断信息采集工具 (WDI-DIAG-001)
echo ============================================================================
echo [安全声明] 本工具严格只读，不修改注册表/系统设置/驱动，不上传任何数据。
echo [隐私声明] 默认脱敏用户名、主机名、IP、MAC、序列号等隐私信息，仅本地保存。
echo.

:: 1. 解析脚本目录（去除末尾反斜杠，避免传给 PowerShell 时转义引号，兼容中文路径）
set "TOOL_ROOT=%~dp0"
if "%TOOL_ROOT:~-1%"=="\" set "TOOL_ROOT=%TOOL_ROOT:~0,-1%"

set "PS_SCRIPT=%TOOL_ROOT%\scripts\Collect-WinDiagnostics.ps1"
set "CONFIG_FILE=%TOOL_ROOT%\config\config.json"
set "OUTPUT_BASE=%TOOL_ROOT%\output"

if not exist "%PS_SCRIPT%" (
    echo [错误] 找不到核心采集脚本："%PS_SCRIPT%"
    echo 请确认已完整解压压缩包，不要在压缩包预览窗口中直接双击运行。
    echo.
    pause
    exit /b 2
)

if not exist "%CONFIG_FILE%" (
    echo [警告] 未找到配置文件 "%CONFIG_FILE%"，将使用内置默认安全与脱敏配置继续运行。
    echo.
)

:: 2. 检查 PowerShell 运行环境（优先 PowerShell 7 pwsh.exe，回退 Windows PowerShell 5.1）
set "PS_EXE="
set "PS_KIND="

where pwsh.exe >nul 2>&1
if %errorlevel%==0 (
    set "PS_EXE=pwsh.exe"
    set "PS_KIND=PowerShell 7 (pwsh.exe)"
) else if exist "%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" (
    set "PS_EXE=%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe"
    set "PS_KIND=Windows PowerShell 5.1 (powershell.exe)"
) else (
    echo [错误] 未检测到可用的 PowerShell 运行环境（pwsh.exe 或 powershell.exe）。
    echo 请在 Windows 11 系统中运行本工具。
    echo.
    pause
    exit /b 3
)

echo [环境检查] 已检测到运行引擎：%PS_KIND%
echo [目录位置] 工具目录：%TOOL_ROOT%
echo [提示] 正在启动只读诊断采集，根据设备数量和日志量通常需要 15-60 秒，请耐心等待...
echo.

:: 3. 启动只读 PowerShell 子进程（-ExecutionPolicy Bypass 仅对当前子进程生效，不修改系统策略）
"%PS_EXE%" -NoProfile -NonInteractive -ExecutionPolicy Bypass -File "%PS_SCRIPT%" -ToolRoot "%TOOL_ROOT%" -ConfigPath "%CONFIG_FILE%" -OutputBase "%OUTPUT_BASE%"
set "EXIT_CODE=%errorlevel%"

echo.
echo ============================================================================
if "%EXIT_CODE%"=="0" (
    echo [完成] 诊断信息采集已完成！请查看上方显示的报告保存路径。
    echo [提示] 您可以将 diagnostic_report.txt（或 diagnostic_data.json）发给 AI 进行深度分析。
) else (
    echo [异常] 采集脚本退出码为 %EXIT_CODE%。
    echo 请检查上方错误提示或 output 目录中的 run_log.txt 以了解详情。
)
echo ============================================================================
echo.
pause
exit /b %EXIT_CODE%
