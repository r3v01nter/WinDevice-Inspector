# AI Collaboration and Delivery Workflow

The Chinese [任务中心](任务中心/README.md) is the user-facing entry point for current work, task history, review records, and delivery navigation. The [任务创建与推进规范](任务中心/任务创建与推进规范.md) defines the reusable lifecycle and self-contained task-brief standard.

## 1. Roles and accountability

### Project owner
- Makes final product and scope decisions.
- Opens/downloads the standalone task brief, checks it, and decides whether to start the task.
- Receives Gemini deliverables, checks their contents, and manually uploads them to the single delivery inbox.
- Provides Windows development/test evidence.
- Decides whether to accept the final result.

### ChatGPT — technical lead and independent reviewer
- Inspects the relevant repository state and decomposes approved work into bounded tasks.
- Writes complete, self-contained task briefs with the necessary background, facts, constraints, file scope, steps, acceptance criteria, and delivery instructions.
- Avoids making Gemini search through unrelated repository files or old chat history to understand the task.
- Guides implementation, reviews code and evidence, requests corrections, and maintains task/review/archive records.
- Does not accept work solely on the basis of Gemini's completion claim.

### Gemini — primary implementation producer
- Treats the standalone task brief as the main execution contract.
- Reads only the task brief and the precise repository files it identifies as necessary to inspect. For code tasks, it may inspect directly related dependencies and tests; it should not perform broad, unrelated repository exploration.
- Performs the main code production or assigned document work.
- Returns complete files, tests, documentation, and a truthful completion receipt.
- May propose improvements, but must identify scope changes and wait for approval before applying them.
- Must not claim local build/test success unless it actually ran those commands in a suitable environment and can provide evidence.
- Does not directly commit, push, or reorganize this repository as part of the standard workflow.

## 2. Task brief as a standalone work package

Every formal task brief must be independently understandable and directly usable after download. It must include:

- Stable task ID, title, round, status, priority, owner, and producer.
- Concise project/task background and the current verified state.
- Baseline date, target branch, and full commit SHA when available.
- Relevant approved product/architecture constraints, summarized directly in the brief.
- Exact objective, non-goals, allowed file scope, and prohibited changes.
- Ordered work steps and precise repository paths that actually need checking.
- Acceptance criteria, tests, expected evidence, and delivery format.
- Known risks, assumptions, unresolved decisions, and stop conditions.

Do not replace this content with a long list of links. Links are for traceability; the essential context belongs in the task brief.

### Repository access rule

- Pure document/review tasks should normally use facts and excerpts already included in the brief; no full repository tour is required.
- Code tasks must inspect the exact relevant source, tests, contracts, and decision records identified in the brief, then only directly related dependencies.
- If a relevant file changed after the recorded baseline, inspect that relevant change and disclose it in the completion receipt.
- If a necessary input is unavailable, stop and report the specific missing item rather than guessing.

Use [任务书模板](templates/任务书模板.md) for all new tasks. Existing task files keep their stable paths unless an approved migration is made.

## 3. Public repository access and execution limits

The project repository is public, so Gemini may read its current contents through the supplied GitHub URL. Public read access does **not** prove that Gemini can push commits, run commands on the owner's PC, or build/test a Windows desktop application.

Unless the current tool/session explicitly demonstrates those capabilities:
- Treat Gemini as a producer returning a complete delivery package.
- Do not assume it can run the Windows WPF application.
- Mark unrun builds/tests as **Not run**, not Passed.
- The owner or a verified Windows environment must run required commands; ChatGPT reviews the evidence.

## 4. Standard collaborative task cycle

1. ChatGPT checks the current task center and only the relevant repository context.
2. ChatGPT writes a bounded, self-contained task brief and saves it under `docs/tasks/`.
3. ChatGPT updates `任务中心/当前任务.md` when this becomes the active work item, and updates `任务索引.md`.
4. The owner opens/downloads the standalone task brief, reviews it, and decides whether to start.
5. Gemini executes the brief, checking only the relevant repository files identified in it.
6. Gemini returns the complete delivery files and truthful completion receipt to the owner.
7. The owner inspects the files and manually places all files for this round directly into the single flat inbox: `DELIVERY/INBOX/待交付/`.
8. The owner tells ChatGPT the task ID and that the delivery is ready for review.
9. ChatGPT reviews every delivered file against the task brief, acceptance criteria, project constraints, and test evidence.
10. If changes are required, ChatGPT records precise findings and retest criteria. The revised package returns through the same inbox as a new round; previous originals are not overwritten.
11. ChatGPT updates task/review indexes and archives the original batch and review report.
12. For code tasks, the owner performs required Windows build/runtime checks. Final acceptance requires applicable evidence and the owner's explicit approval.

## 5. Required completion receipt

Gemini must return:
- Task ID, round, and outcome.
- Summary of completed work.
- Complete list of files created/modified/deleted.
- Commands actually executed, environment details, and exit codes.
- Tests run and pass/fail summary.
- Build result, including whether it ran on Windows.
- Known limitations and unverified behavior.
- Deviations from the task brief, with reasons.
- Exact contents of the delivery package.

Use [完成回执模板](templates/完成回执模板.md).

## 6. Single delivery inbox and archive rules

- The only routine drop location is `DELIVERY/INBOX/待交付/`.
- This is a flat incoming directory. The owner places the round's files directly into it; do not require task-specific subfolders, renaming, unpacking, or pre-sorting.
- ChatGPT reviews the submitted files in place. Review reports do not belong inside the incoming original delivery.
- After a review round is fully processed, ChatGPT preserves the original files and review report under a task-specific archive path, then clears the inbox while retaining its README placeholder.
- Each revision round is a distinct record. Never overwrite R1 with R2.
- Keep `DELIVERY/INBOX/README.md`, `DELIVERY/INBOX/待交付/README.md`, and archive README placeholders.
- Do not place credentials, access tokens, browser profiles, private keys, real scan exports, or unrelated personal files in the repository.

## 7. Task states and review gates

The detailed state definitions are maintained in [任务创建与推进规范](任务中心/任务创建与推进规范.md). The core distinctions are:

- Submitted means the owner placed files in the inbox; it does not mean they passed review.
- Review passed does not mean the Windows app passed runtime verification.
- Local verification passed only when actual evidence is recorded.
- Archived means the original batch was preserved; it does not itself mean accepted.
- Final acceptance requires applicable gates and the owner's explicit approval.

The [current task](任务中心/当前任务.md), [task index](任务中心/任务索引.md), and [review index](任务中心/审查索引.md) must be kept consistent.

## 8. Change control and review standard

- Architecture changes require explicit discussion and a decision record.
- Do not add dependencies, change target frameworks, alter public data schemas, or broaden permissions without reporting the reason and receiving approval.
- Review includes correctness, exception handling, privacy/user consent, process lifecycle, data integrity, test quality, and build reproducibility.
- A successful compile alone is not acceptance. All task acceptance criteria must be checked.
- If a claim cannot be verified, label it unverified rather than implying it passed.
