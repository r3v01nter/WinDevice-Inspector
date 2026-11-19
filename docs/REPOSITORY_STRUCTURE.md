# Repository Structure and File Placement

This document defines where project information, implementation source, tests, and AI delivery packages belong. Keep the repository predictable; do not scatter task notes or generated output in the root.

## 1. Target layout

- Root: README.md, .gitignore, and top-level project metadata.
- src/: production solution and application/library projects.
- tests/: automated test projects, synthetic fixtures, and test utilities.
- docs/: human-maintained product and engineering documentation.
- docs/decisions/: numbered architecture decision records (ADRs).
- docs/tasks/: numbered task briefs and acceptance criteria.
- docs/templates/: reusable task and completion-receipt templates.
- DELIVERY/INBOX/: new AI packages waiting for review.
- DELIVERY/ARCHIVE/: original packages retained after review.

The src/ and tests/ directories currently contain placement notes only. TASK-0001 creates the first actual solution and test projects.

## 2. Naming rules

- Solution: WinDeviceInspector.sln (or .slnx only after an explicit tooling decision).
- Product projects: WinDeviceInspector.<Area>.
- Test projects: WinDeviceInspector.<Area>.Tests.
- Task briefs: TASK-0001-short-description.md.
- Architecture decisions: ADR-0001-short-description.md.
- Synthetic fixtures: descriptive names with no real user/device identifiers.
- Avoid duplicate names such as final, final2, or latest-new.

## 3. Documentation ownership

- Product scope and user behavior: PRODUCT_REQUIREMENTS.md.
- Technical boundaries and data flow: TECHNICAL_ARCHITECTURE.md.
- Why a major choice was made: a new ADR under decisions/.
- Work to be implemented: a task brief under tasks/.
- Current facts about progress: PROJECT_STATUS.md.
- Future sequencing: ROADMAP.md.
- AI roles and handoff procedure: AI_COLLABORATION.md.

If two documents disagree, stop and report the conflict. Do not silently invent a third interpretation. Product requirements and accepted ADRs take precedence over stale task notes; update the task brief before implementation continues.

## 4. Delivery handling

- Gemini returns a complete task package; the owner places it in DELIVERY/INBOX/TASK-XXXX/.
- Do not place real scan exports, credentials, tokens, private keys, or personal files in the repository.
- ChatGPT reviews the package against the task brief and checks verification evidence.
- Only accepted source files are integrated into src/, tests/ into tests/, and documentation into docs/.
- Preserve the original delivery package in the archive when useful for traceability.
- Keep README placeholders in INBOX/ARCHIVE; Git does not track empty directories.

## 5. Generated and local-only data

The following must not be committed:
- Actual scan results from the owner's computer.
- Local application history or database files.
- Build output such as bin/ and obj/.
- IDE/user-specific settings.
- Logs that may contain machine identifiers or personal paths.
- Credentials, tokens, certificates/private keys, or browser data.

Update the root .gitignore when new build tooling is introduced.
