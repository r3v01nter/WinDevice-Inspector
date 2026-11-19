# Contributing to WinDevice Inspector

Thank you for helping improve WinDevice Inspector. The project is currently preparing its first implementation task.

## Before making changes

1. Read `README.md`.
2. Open the Chinese [task center](docs/任务中心/README.md) and check [the current task](docs/任务中心/当前任务.md).
3. Read `docs/PROJECT_OVERVIEW.md` and `docs/PRODUCT_REQUIREMENTS.md`.
4. Read `docs/TECHNICAL_ARCHITECTURE.md` and `docs/REPOSITORY_STRUCTURE.md`.
5. Read `docs/AI_COLLABORATION.md` and the linked task brief.
6. Inspect the current repository state before editing.

## Non-negotiable behavior

- A scan must never run automatically.
- Every scan requires a deliberate user action and explicit confirmation immediately before collection.
- Collection is read-only and local-first.
- No silent elevation, automatic repair, driver modification, telemetry, or automatic upload.
- The user must be able to review and control the fields included in shareable output.
- Never fabricate hardware values or claim unrun tests passed.

## Code and test placement

- Production code belongs in `src/`.
- Automated tests and synthetic fixtures belong in `tests/`.
- Product/engineering documentation belongs in `docs/`.
- Task definitions belong in `docs/tasks/`; new task brief filenames should be Chinese and retain a stable task ID.
- Architecture decisions belong in `docs/decisions/`.
- Current work and review state are indexed in `docs/任务中心/`.

## Change discipline

- Keep changes focused on the active task.
- Explain new dependencies and permission requirements.
- Do not change public data contracts or architecture without documenting the reason and updating the relevant decision/task documents.
- Do not commit real scan data, secrets, credentials, tokens, private keys, or user-specific logs.
- Report exact build/test commands and results. Mark anything not executed as Not run.

## AI-assisted work

Gemini is the primary implementation producer. ChatGPT provides technical direction, implementation guidance, independent review, and task-index maintenance. The project owner controls repository handoff and final acceptance. Follow `docs/AI_COLLABORATION.md` and the current task linked from the Chinese task center.
