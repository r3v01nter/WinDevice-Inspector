# Delivery Area

This directory is the controlled handoff area for AI-assisted development work.

## Directory layout

- `INBOX/待交付/`: the only user-facing drop location for complete delivery packages returned by Gemini.
- `ARCHIVE/`: reviewed original packages retained for traceability when useful.

## Handoff and review workflow

1. The project owner receives the complete delivery package from Gemini and manually places it in `INBOX/待交付/`.
2. The project owner tells ChatGPT that the package is ready for review.
3. ChatGPT checks the package against its task brief, acceptance criteria, file integrity, and project constraints.
4. If changes are required, the package remains unaccepted and the owner is given a concrete rework list. A reworked package is reviewed again through the same inbox.
5. Only after explicit review and acceptance may approved files be integrated into the appropriate project directories, such as `src/`, `tests/`, or `docs/`.
6. When useful, retain the original reviewed package under a task-specific directory in `ARCHIVE/`.

## Status definitions

- **Submitted**: the owner has placed a package in the inbox. Submission is not acceptance.
- **Under review**: ChatGPT is checking the package. No files are approved for integration yet.
- **Rework required**: the package has unresolved issues and must be corrected.
- **Accepted**: the package has passed review against the task's acceptance criteria.
- **Archived**: the original package has been retained in `ARCHIVE/` after review. Archiving does not replace the canonical project files.

A task must never be described as accepted or archived unless the corresponding action has actually been completed and verified.

## Scope and safety

- Gemini prepares and returns files; it does not need to push directly to this repository.
- The project owner controls manual submission of Gemini's package.
- Do not place credentials, access tokens, private keys, browser profiles, real machine scan data, or unrelated personal files here.
- Keep the README placeholders in the inbox and archive directories.
