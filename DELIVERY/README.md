# Delivery Area

This directory is the controlled handoff area for AI-assisted development work.

## Directory layout

- [`INBOX/待交付/`](INBOX/待交付/): the only user-facing drop location for complete delivery files returned by Gemini.
- [`ARCHIVE/`](ARCHIVE/): original delivery batches retained by task and round, including batches that need rework.

## Handoff and review workflow

1. Gemini returns the requested files and a truthful completion note to the project owner.
2. The owner checks the files and manually uploads the complete delivery contents to `INBOX/待交付/`.
3. The owner tells ChatGPT the task ID and that the delivery is ready for review.
4. ChatGPT checks the submitted files against the task brief, acceptance criteria, file integrity, and project constraints.
5. If changes are required, ChatGPT records the findings and gives a concrete rework list. The revised batch returns through the same inbox; previous originals are not overwritten.
6. After the review round is processed, ChatGPT preserves the original files and review record under a task-specific archive path, then clears the inbox while retaining README placeholders.
7. Only approved files may be integrated into canonical project locations such as `src/`, `tests/`, or `docs/`.

## Status definitions

- **Submitted**: the owner has placed files in the inbox. Submission is not acceptance.
- **Under review**: ChatGPT is checking the package. No files are approved for integration yet.
- **Rework required**: the package has unresolved issues and must be corrected.
- **Review passed**: the submitted scope passed its independent review; this is not necessarily final acceptance.
- **Accepted**: applicable review and verification gates are complete and the owner explicitly approves the result.
- **Archived**: original files and review records have been preserved. Archiving does not mean accepted.

## Scope and safety

- Gemini prepares and returns files; it does not directly commit or push to this repository in the standard workflow.
- The project owner controls manual submission and final acceptance.
- Keep review reports outside the incoming original delivery.
- Do not place credentials, access tokens, private keys, browser profiles, real machine scan data, or unrelated personal files here.
- Keep the README placeholders in the inbox and archive directories.
