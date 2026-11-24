# Repository Structure and File Placement

This document defines where project information, implementation source, tests, and AI delivery packages belong. Keep the repository predictable; do not scatter task notes or generated output in the root.

## 1. Target layout

- Root: `README.md`, `.gitignore`, and top-level project metadata.
- `src/`: production solution and application/library projects.
- `tests/`: automated test projects, synthetic fixtures, and test utilities.
- `docs/`: human-maintained product and engineering documentation.
- `docs/decisions/`: numbered architecture decision records (ADRs).
- `docs/tasks/`: task briefs and acceptance criteria.
- `docs/templates/`: reusable task, receipt, review, and issue templates.
- `docs/任务中心/`: Chinese task navigation, current task, task index, review index, and development change record.
- `docs/reviews/`: independent review reports and owner-provided local verification records.
- `docs/issues/`: confirmed defects and retest records.
- `DELIVERY/LOCAL_STAGING/待上传/`: local-only Gemini downloads; ignored by Git and never committed.
- `DELIVERY/INBOX/待交付/`: single flat repository delivery inbox, populated by Antigravity on a task/round branch.
- `DELIVERY/ARCHIVE/`: original delivery packages retained by task and round.

The `src/` and `tests/` directories currently contain placement notes only. TASK-0001 creates the first actual solution and test projects.

## 2. Naming rules

- Solution: `WinDeviceInspector.sln` (or `.slnx` only after an explicit tooling decision).
- Product projects: `WinDeviceInspector.<Area>`.
- Test projects: `WinDeviceInspector.<Area>.Tests`.
- New task briefs: `TASK-0002_中文任务名称.md`, retaining the stable task ID.
- Existing task briefs retain their established paths unless an explicit migration is planned.
- Review reports: `REV-任务编号-R轮次_审查报告.md`.
- Architecture decisions: `ADR-0001-short-description.md`.
- Synthetic fixtures: descriptive names with no real user/device identifiers.
- Avoid duplicate names such as final, final2, or latest-new.

## 3. Documentation ownership

- Product scope and user behavior: `PRODUCT_REQUIREMENTS.md`.
- Technical boundaries and data flow: `TECHNICAL_ARCHITECTURE.md`.
- Why a major choice was made: a new ADR under `decisions/`.
- Work to be implemented: a task brief under `tasks/`.
- Current task and task lifecycle: `任务中心/`.
- Current verified project summary: `PROJECT_STATUS.md`.
- Future sequencing: `ROADMAP.md`.
- AI roles and handoff procedure: `AI_COLLABORATION.md` and `AI_交付操作手册.md`.

If two documents disagree, stop and report the conflict. Do not silently invent a third interpretation. Product requirements and accepted ADRs take precedence over stale task notes; update the task brief before implementation continues.

## 4. Delivery handling

- Gemini web/App produces complete files or ZIPs; the owner downloads them into local `DELIVERY/LOCAL_STAGING/待上传/`.
- Antigravity safely checks/extracts the files and pushes them to a dedicated delivery branch, placing package originals in `DELIVERY/INBOX/待交付/`.
- The local staging directory is Git-ignored. Never add it to a commit.
- Do not create a second inbox or restore the obsolete `DELIVERY/INBOX/TASK-XXXX/` structure.
- Do not place real scan exports, credentials, tokens, private keys, browser profiles, or personal files in the repository.
- Code changes remain isolated on the delivery branch until ChatGPT review and the applicable owner approval gates are complete.
- Preserve original delivery rounds in task-specific archive paths; never overwrite earlier rounds.
- Keep README placeholders in inbox/archive; Git does not track empty directories.

## 5. Generated and local-only data

The following must not be committed:
- Actual scan results from the owner's computer.
- Local application history or database files.
- Build output such as `bin/` and `obj/`.
- IDE/user-specific settings.
- Logs that may contain machine identifiers or personal paths.
- Credentials, tokens, certificates/private keys, browser profiles, or local AI staging contents.

Update the root `.gitignore` when new build tooling is introduced.
