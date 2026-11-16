# ADR-0001 — Initial Windows Desktop Technology

- Status: Accepted as the starting implementation baseline
- Date: 2026-11-16

## Context

WinDevice Inspector is a Windows-first desktop application. The first release prioritizes broad read-only device/system collection, event evidence, local storage, and AI diagnostic brief generation. It does not require live hardware sensor rendering.

The project needs a mature desktop framework, straightforward Windows API access, a maintainable C# codebase, and a low-friction way to launch a bundled PowerShell collector.

## Decision

- Language/runtime: C# on a supported .NET LTS release; initial target is .NET 10 LTS.
- UI: WPF.
- Initial deployment target: Windows 11 x64.
- Collection: a separate, controlled PowerShell child process using bundled read-only scripts and versioned JSON output.
- Architecture: separate App, Core, Collectors, Diagnostics, and Reporting projects as described in the technical architecture.

## Rationale

WPF is selected as the pragmatic first implementation path: mature tooling, stable Windows desktop support, strong C# integration, and no need to introduce additional UI framework complexity before the product's collection model is proven.

PowerShell remains an internal collector backend. The application owns process lifecycle, progress, cancellation, timeout, error capture, schema validation, and presentation.

## Consequences

- The initial UI is Windows-only.
- The application must detect supported PowerShell availability and report clear errors.
- Collector scripts must work with the supported PowerShell versions chosen by the project; compatibility must be tested rather than assumed.
- Framework and UI choices can be revisited only through a documented decision with evidence from a prototype.
- .NET SDK availability is a development prerequisite; implementation tasks must report missing prerequisites rather than silently installing software.

## Revisit when

A working vertical slice reveals a concrete limitation in WPF or the selected .NET LTS target that materially affects maintainability, accessibility, deployment, or user experience.
