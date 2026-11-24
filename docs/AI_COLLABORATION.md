# AI Collaboration and Delivery Workflow

The Chinese [任务中心](任务中心/README.md) is the user-facing entry point. The operational file-transfer and Antigravity procedure is defined in [AI 交付操作手册](AI_交付操作手册.md).

## 1. Roles and accountability

### Project owner
- Makes product, scope, and final acceptance decisions.
- Gives Gemini the standalone task brief and downloads its complete output.
- Places downloaded files/ZIPs into the local ignored staging directory `DELIVERY/LOCAL_STAGING/待上传/`.
- Starts Antigravity to validate, package, commit, and push the delivery branch.
- Explicitly tells ChatGPT when to review or continue. The owner no longer needs to manually unzip, copy, commit, or upload files.

### Gemini web / Gemini App — primary code producer
- Uses the strongest model available in the user's Gemini web/App subscription (for example, Neon / Hydrogen when available).
- Produces core implementation, complex modules, tests, refactors, and technical explanations.
- Returns complete files or a ZIP preserving the required relative paths, plus a truthful completion receipt.
- Does not directly commit or push this repository. Its output is downloaded by the owner and passed through local staging.

### Antigravity — local integration and delivery operator
- Uses the local repository clone and reads the current task brief plus [AI 交付操作手册](AI_交付操作手册.md).
- Validates downloaded inputs, checks paths and conflicts, safely extracts packages, applies files to the task-authorized paths, runs available build/tests, and captures logs.
- Creates and pushes a task/round-specific delivery branch, then reports the branch, commit SHA, file manifest, and test evidence.
- Must not push to `main`, force-push, merge a PR, change scope, or invent architecture decisions.
- Does not replace the stronger Gemini model as the primary producer of complex code.

### ChatGPT — project lead and independent reviewer
- Inspects relevant repository state and prepares self-contained task briefs.
- Coordinates architecture and product decisions, reviews code and evidence, requests corrections, and maintains task/review/archive records.
- Only starts the next review/progression step after the project owner explicitly asks in chat.
- Does not treat an Antigravity push as acceptance.

## 2. Task brief as a standalone work package

Every task brief must be independently understandable and include:
- Stable task ID, title, round, status, owner, producer, and baseline commit.
- Concise project background and verified current state.
- Approved constraints, exact objectives, non-goals, and allowed file scope.
- Relevant paths, ordered steps, acceptance criteria, tests, expected evidence, and delivery format.
- Risks, unresolved decisions, and stop conditions.

Links provide traceability; essential execution context belongs in the task brief. Use [任务书模板](templates/任务书模板.md).

## 3. Repository access and execution limits

- Gemini web/App produces complete files; do not assume it can access the local working tree.
- Antigravity is the local file/Git operator. It must verify the repository root and task baseline before acting.
- Public repository read access does not prove that a model can run Windows builds or tests.
- Mark unrun commands/tests as **Not run**, not Passed.
- If the baseline changed or a necessary input is unavailable, stop and report rather than guessing.

## 4. Standard task cycle

1. ChatGPT writes and publishes a bounded, self-contained task brief.
2. The owner downloads/reviews the brief and gives it to Gemini web/App.
3. Gemini produces complete files/ZIP and a truthful completion receipt.
4. The owner downloads the output into local `DELIVERY/LOCAL_STAGING/待上传/`.
5. Antigravity reads the task brief and [AI 交付操作手册](AI_交付操作手册.md), validates the staging inputs, applies only authorized files, and performs available checks.
6. Antigravity creates a branch such as `delivery/TASK-0001-R2`, commits and pushes it, and reports its SHA and URL. It never pushes `main` or merges.
7. The owner explicitly tells ChatGPT that the branch is ready and asks for review/next step.
8. ChatGPT fetches that exact branch and independently reviews every changed file against the task and evidence.
9. If changes are required, ChatGPT records precise findings and a new revision round is produced on a new branch. Prior delivery branches and commits are preserved.
10. After applicable review, local verification, and owner approval gates, ChatGPT may prepare the next task or perform the explicitly requested repository follow-up. No automatic phase transition occurs.

## 5. Required Antigravity delivery receipt

- Task ID, round, baseline SHA, branch name, and commit SHA.
- Gemini input file list and hashes when available.
- Repository changed-file list and destination paths.
- ZIP/path safety and conflict-check results.
- Actual commands, environment, exit codes, and build/test results.
- Remote branch URL and PR URL if created.
- Unprocessed files, risks, deviations, and unverified items.
- Explicit confirmation that `main` was not pushed, no PR was merged, and no historical delivery was overwritten.

## 6. Delivery and history rules

- Local staging is `DELIVERY/LOCAL_STAGING/待上传/` and is Git-ignored.
- The repository delivery inbox remains the single flat location: `DELIVERY/INBOX/待交付/`.
- Each task/round uses a separate delivery branch; do not overwrite a prior round.
- Preserve original files and manifests. Never commit credentials, browser data, private keys, real scan exports, or personal files.
- Code changes stay on the delivery branch until independent review and explicit follow-up.
- “Pushed” means uploaded to a branch, not reviewed, accepted, or merged.

## 7. Manual trigger and acceptance gates

Antigravity pushing a branch does not automatically trigger ChatGPT. The owner must explicitly say, for example, “TASK-0001 R2 已上传，请检查交付分支” or “继续下一步”.

Keep these concepts separate:
- Production completed: producer reports finished.
- Branch pushed: files are present on a remote branch.
- Independent review passed: ChatGPT checked the actual branch contents.
- Local verification passed: actual build/runtime/test evidence exists.
- Final acceptance: the owner explicitly approves.

The current task pointer, task index, and review index must remain consistent. See [任务创建与推进规范](任务中心/任务创建与推进规范.md).
