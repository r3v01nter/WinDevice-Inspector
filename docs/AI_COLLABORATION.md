# AI Collaboration and Delivery Workflow

## 1. Roles and accountability

### Project owner
- Makes final product and scope decisions.
- Provides access to the public GitHub repository URL and the Windows development/test environment.
- Transfers Gemini deliverables and test evidence.
- Decides whether to accept the final result.

### ChatGPT — technical lead and acceptance reviewer
- Owns product planning, technical direction, architecture, task decomposition, and acceptance criteria.
- Guides Gemini before and during implementation when design or technical problems arise.
- Reviews code, data contracts, security/privacy behavior, tests, and documentation.
- Independently checks whether claimed test/build evidence is credible and sufficient.
- Requests corrections and provides concrete implementation direction when defects or difficult problems are found.
- Does not accept work solely on the basis of Gemini's completion claim.
- Coordinates integration and repository organization after acceptance.

### Gemini — primary implementation producer
- Reads the public repository and the exact task brief before implementation.
- Performs the main code production and implementation work.
- Returns complete files, tests, documentation, and a truthful completion receipt.
- May propose improvements, but must identify scope changes and wait for approval before applying them.
- Must not claim local build/test success unless it actually ran those commands in a suitable environment and can provide evidence.

## 2. Public repository access and execution limits

The project repository is public, so Gemini may read its current contents through the supplied GitHub URL. Every task brief must provide:
- Repository URL.
- Exact documents and existing source paths to read first.
- Target branch/ref where relevant.

Public read access does **not** prove that Gemini can push commits, edit the repository, run commands on the owner's PC, or build/test a Windows desktop application. Unless the current tool/session explicitly demonstrates those capabilities:
- Treat Gemini as a code producer returning a complete delivery package.
- Do not assume it can run the Windows WPF application.
- Mark unrun builds/tests as **Not run**, not Passed.
- The owner or a verified Windows environment must run required commands; ChatGPT reviews the evidence and, where possible, independently checks the implementation.

## 3. Standard collaborative task cycle

1. ChatGPT inspects the latest repository state and defines a bounded task.
2. ChatGPT publishes a task brief with context, exact paths, constraints, acceptance criteria, and verification commands.
3. Gemini reads the public repository and referenced files before writing code.
4. Gemini implements the task as the primary producer. ChatGPT provides technical direction and clarifies difficult design questions as needed.
5. Avoid concurrent edits to the same files or branch. Gemini returns a delivery package; ChatGPT reviews and then integrates accepted changes. If direct GitHub editing is later verified, use separate branches/PRs and review before merge.
6. Owner places the complete delivery under `DELIVERY/INBOX/TASK-XXXX/`.
7. ChatGPT inspects every delivered file, compares it with the task brief, checks tests/build evidence, and reports findings.
8. If changes are required, ChatGPT gives Gemini a precise revision list and acceptance conditions.
9. Only after all blocking findings are resolved is the delivery accepted and organized into canonical source/docs/tests paths.
10. Update project status and archive the original handoff when useful.

## 4. Required task brief contents

- Task ID and title.
- Repository URL and branch/ref.
- Exact documents and source files Gemini must read.
- Current project state and relevant architecture decisions.
- Objective and non-goals.
- Exact allowed files/directories to create or modify.
- Required implementation behavior.
- User-control, privacy, and security constraints.
- Acceptance criteria.
- Required tests and commands.
- Required delivery package structure.
- Required completion receipt.
- Explicit distinction between tests actually run and tests not run.

See [task brief template](templates/TASK_BRIEF_TEMPLATE.md).

## 5. Required completion receipt

Gemini must return:
- Task ID and outcome.
- Summary of implementation.
- Complete list of files created/modified/deleted.
- Key design decisions and dependencies.
- Commands executed, environment details, and exit codes.
- Tests run and full pass/fail summary.
- Build result, including whether it ran on Windows.
- Known limitations and unverified behavior.
- Deviations from the task brief, with reasons.
- Exact contents of the delivery package.

See [completion receipt template](templates/COMPLETION_RECEIPT_TEMPLATE.md).

## 6. Delivery inbox rules

- The routine drop location is `DELIVERY/INBOX/`.
- Keep `DELIVERY/INBOX/README.md` permanently; Git does not track truly empty directories.
- Put each task in its own subfolder, e.g. `TASK-0001/`.
- Include complete source/project files, tests, docs, and receipt. Do not return snippets or patches alone.
- ChatGPT reviews before files are moved into canonical source/docs/tests paths.
- Accepted packages may be archived under `DELIVERY/ARCHIVE/TASK-XXXX/`.
- Never delete the inbox README or the inbox directory itself.
- Do not place credentials, access tokens, browser profiles, private keys, real scan exports, or unrelated personal files in the repository.

## 7. Change control and review standard

- Architecture changes require explicit discussion and a decision record.
- Do not add dependencies, change target frameworks, alter public data schemas, or broaden permissions without reporting the reason and receiving approval.
- Review includes correctness, exception handling, privacy/user consent, process lifecycle, data integrity, test quality, and build reproducibility.
- A successful compile alone is not acceptance. All task acceptance criteria must be checked.
- If ChatGPT cannot verify a claim, it must label it unverified rather than implying it passed.
