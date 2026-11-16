# AI Collaboration and Delivery Workflow

## 1. Roles

### Project owner
- Makes final product and scope decisions.
- Uses Gemini Pro desktop task mode (model selection may change) to implement scoped tasks.
- Manually places Gemini's complete delivery package in `DELIVERY/INBOX/`.
- Reviews task briefs and decides whether to accept proposed scope changes.

### ChatGPT — project coordinator
- Owns product planning, technical direction, architecture decisions, task decomposition, and acceptance criteria.
- Writes one self-contained task brief for each implementation assignment.
- Reviews the returned code, tests, documentation, and completion receipt.
- Identifies defects and requests revisions.
- Organizes accepted deliverables into the repository and updates project status.
- Does not assume a task is complete merely because the implementation assistant says so.

### Gemini — implementation assistant
- Receives the task brief from the owner.
- Works only within the stated scope and returns a complete delivery package plus a completion receipt.
- Must not independently push to, commit to, or otherwise operate the GitHub repository.
- Must report files changed, commands/tests run, results, limitations, and known issues.
- Must not silently broaden scope or replace architectural decisions.

## 2. Standard task cycle

1. Owner and ChatGPT discuss the next milestone and agree on scope.
2. ChatGPT writes a task brief with context, exact deliverables, constraints, and acceptance criteria.
3. Owner copies the brief into Gemini's task mode.
4. Gemini implements and returns all changed/new files plus a completion receipt.
5. Owner places the unmodified delivery package in `DELIVERY/INBOX/`.
6. ChatGPT inspects every delivered file, checks consistency and tests, and reports findings.
7. If changes are required, ChatGPT issues a revision task brief; the package remains pending until resolved.
8. If accepted, ChatGPT plans or performs repository organization and updates the task ledger.
9. ChatGPT removes processed delivery artifacts from the inbox while preserving the inbox directory and its README placeholder.

## 3. Required task brief contents

- Task ID and title.
- Current project state and relevant architecture decisions.
- Objective and non-goals.
- Exact allowed files/directories to create or modify.
- Required implementation behavior.
- Constraints (read-only collection, no silent elevation, no online upload, etc.).
- Acceptance criteria.
- Required tests and commands.
- Required delivery package structure.
- Required completion receipt.

See [task brief template](templates/TASK_BRIEF_TEMPLATE.md).

## 4. Required completion receipt

Gemini must return:
- Task ID and outcome.
- Summary of implementation.
- Complete list of files created/modified/deleted.
- Key design decisions.
- Commands executed and their exit codes.
- Tests run and full pass/fail summary.
- Build result.
- Known limitations and unverified behavior.
- Any deviations from the task brief, with reasons.
- Exact contents of the delivery package.

See [completion receipt template](templates/COMPLETION_RECEIPT_TEMPLATE.md).

## 5. Delivery inbox rules

- The only routine drop location is `DELIVERY/INBOX/`.
- Keep `DELIVERY/INBOX/README.md` permanently; Git does not track truly empty directories.
- Put each task in its own subfolder, e.g. `TASK-0001/`, or use a ZIP plus receipt when binary files are needed.
- Do not mix unrelated tasks in one delivery package.
- ChatGPT reviews before files are moved into source/docs/tests.
- Accepted packages are archived under `DELIVERY/ARCHIVE/TASK-XXXX/` when retaining the original handoff is useful; otherwise the canonical accepted files are organized into their proper locations and the inbox is cleared.
- Never delete the inbox README or the inbox directory itself.
- Do not place credentials, access tokens, browser profiles, private keys, or unrelated personal files in the repository.

## 6. Change control

- Architecture changes require explicit discussion and a decision record.
- Gemini must not add dependencies, change target frameworks, alter public data schemas, or broaden permissions without calling it out in the receipt.
- No code is considered accepted until reviewed against the task's acceptance criteria.
