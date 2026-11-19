# AI Collaboration and Delivery Workflow

The Chinese [任务中心](任务中心/README.md) is the user-facing entry point for current work, task history, review records, and delivery navigation.

## 1. Roles and accountability

### Project owner
- Makes final product and scope decisions.
- Reads task briefs and may inspect/download the files before authorizing work.
- Receives Gemini deliverables, checks their contents, and manually uploads them to the single delivery inbox.
- Provides Windows development/test evidence.
- Decides whether to accept the final result.

### ChatGPT — technical lead and independent reviewer
- Owns task decomposition, technical guidance, acceptance criteria, and review planning within the owner's approved product direction.
- Guides Gemini before and during implementation when design or technical problems arise.
- Reviews code, data contracts, security/privacy behavior, tests, documentation, and completion evidence.
- Requests corrections with concrete findings and retest criteria.
- Maintains the current-task pointer, task/review indexes, review reports, and delivery archive records.
- Does not accept work solely on the basis of Gemini's completion claim.

### Gemini — primary implementation producer
- Reads the public repository and the exact task brief before implementation.
- Performs the main code production or assigned document work.
- Returns complete files, tests, documentation, and a truthful completion receipt.
- May propose improvements, but must identify scope changes and wait for approval before applying them.
- Must not claim local build/test success unless it actually ran those commands in a suitable environment and can provide evidence.
- Does not directly commit, push, or reorganize this repository as part of the standard workflow.

## 2. Public repository access and execution limits

The project repository is public, so Gemini may read its current contents through the supplied GitHub URL. Every task brief must provide:
- Repository URL and target branch/ref.
- Exact documents and existing source paths to read first.
- Objective, scope, constraints, and acceptance criteria.

Public read access does **not** prove that Gemini can push commits, run commands on the owner's PC, or build/test a Windows desktop application. Unless the current tool/session explicitly demonstrates those capabilities:
- Treat Gemini as a producer returning a complete delivery package.
- Do not assume it can run the Windows WPF application.
- Mark unrun builds/tests as **Not run**, not Passed.
- The owner or a verified Windows environment must run required commands; ChatGPT reviews the evidence and, where possible, independently checks the implementation.

## 3. Standard collaborative task cycle

1. ChatGPT inspects the latest repository state and drafts a bounded task brief.
2. The task brief is saved in the repository and linked from the [任务中心](任务中心/README.md), so the owner can open or download it before sending it to Gemini.
3. The owner reviews the task brief and decides whether to start the task.
4. Gemini reads the public repository and referenced files, then performs the assigned work.
5. Gemini returns a complete delivery package and truthful completion receipt to the owner.
6. The owner inspects the files and manually places the delivery in the single path `DELIVERY/INBOX/待交付/`.
7. The owner tells ChatGPT the task ID and that the delivery is ready for review.
8. ChatGPT inspects every delivered file against the task brief, acceptance criteria, project constraints, and test evidence. A submitted package is not yet accepted.
9. If changes are required, ChatGPT records the review and gives Gemini a precise revision list. The revised package returns through the same inbox as a new round; previous originals are not overwritten.
10. After review, ChatGPT updates the review/task indexes and, where appropriate, archives the original batch. Only approved files may be integrated into canonical `src/`, `tests/`, or `docs/` paths.
11. For code tasks, the owner performs required Windows build/runtime checks. Final acceptance requires the applicable evidence and the owner's explicit approval.

## 4. Required task brief contents

- Task ID and Chinese title.
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

Existing English task briefs remain at their stable paths. New task briefs should use a Chinese filename with the stable task ID, for example `TASK-0002_设备扫描流程实现任务书.md`.

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

## 6. Single delivery inbox and archive rules

- The only routine drop location is `DELIVERY/INBOX/待交付/`. Do not create parallel inboxes or per-task top-level inbox paths.
- The owner uploads the complete delivery contents to this directory after personally checking the files. The current workflow does not require the owner to rename or reorganize every file before submission.
- ChatGPT reviews the submitted files in place. Review reports do not belong inside the incoming original delivery.
- After a review round is fully processed, ChatGPT preserves the original files and review report under a task-specific archive path, then clears the inbox while retaining its README placeholder.
- Each revision round is a distinct record. Never overwrite R1 with R2.
- Keep `DELIVERY/INBOX/README.md`, `DELIVERY/INBOX/待交付/README.md`, and archive README placeholders.
- Do not place credentials, access tokens, browser profiles, private keys, real scan exports, or unrelated personal files in the repository.

## 7. Task states and review gates

Standard task states:

`待规划 → 待生产 → 生产中 → 待交付 → 审查中 → 返工中（如需） → 待本机验证（适用时） → 验收通过 → 已归档`

Special states: `已暂停`、`已取消`、`被其他任务替代`。

Important distinctions:
- Submitted means the owner placed files in the inbox; it does not mean they passed review.
- Review passed means the submitted scope met the review criteria; it does not mean the Windows app passed runtime verification.
- Local verification passed only when actual evidence is recorded.
- Archived means the original batch was preserved; it does not itself mean accepted.
- Final acceptance requires the relevant gates and the owner's explicit approval.

The [current task](任务中心/当前任务.md), [task index](任务中心/任务索引.md), and [review index](任务中心/审查索引.md) must be kept consistent.

## 8. Change control and review standard

- Architecture changes require explicit discussion and a decision record.
- Do not add dependencies, change target frameworks, alter public data schemas, or broaden permissions without reporting the reason and receiving approval.
- Review includes correctness, exception handling, privacy/user consent, process lifecycle, data integrity, test quality, and build reproducibility.
- A successful compile alone is not acceptance. All task acceptance criteria must be checked.
- If ChatGPT cannot verify a claim, it must label it unverified rather than implying it passed.
