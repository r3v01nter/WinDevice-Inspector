# AI Collaboration and Delivery Workflow

The repository-wide entry point is [AI_AGENT_GUIDE.md](../AI_AGENT_GUIDE.md). The Chinese [任务中心](任务中心/README.md) tracks tasks; [工作流规范](工作流/README.md) defines execution; [交付中心](../DELIVERY/README.md) manages submissions, reviews, and archives.

## 1. Roles and accountability

### Project owner
- Approves task scope and authorizes execution.
- Reviews delivery metadata and explicitly triggers ChatGPT review.
- Makes final acceptance decisions.
- Provides any local inputs or permissions that the tools cannot access themselves.

### Gemini web / Gemini App — planning and task briefs
- Reads the public repository guidance and relevant current task records.
- Clarifies requirements, performs research, compares approaches, and creates self-contained task briefs or rework briefs.
- Does not assume access to Antigravity's local working tree, terminal, or Git credentials.
- Does not concurrently modify the same implementation workspace while Antigravity is implementing a task.

### Antigravity + Gemini 4 Hydrogen Extra High — independent implementation
- Reads AI_AGENT_GUIDE.md, workflow rules, task center, and the authorized task brief.
- Verifies actual model availability, repository/workspace access, terminal, Git permissions, and test environment before work.
- Independently implements only the authorized scope, runs available tests, and creates a complete ZIP, completion receipt, file manifest, and SHA-256.
- Uses a task/round-specific branch and the single delivery inbox when remote Git operations are available.
- Must not push main, force-push, rewrite history, merge a PR, expand scope, or self-approve.
- If Hydrogen Extra High or any required capability is unavailable, reports the limitation and waits for the owner's decision; no silent model substitution.

### ChatGPT GPT-6 — independent reviewer and archive maintainer
- Reviews the exact branch/commit and actual files after the owner explicitly triggers review.
- Checks implementation, task compliance, privacy/security, tests, and evidence independently.
- Produces review reports and precise rework requirements.
- After review processing, preserves original delivery, archives the report, updates indexes, and clears processed inbox contents while retaining README placeholders.
- Does not treat a push or producer self-assessment as acceptance.

## 2. Task brief requirements

Every task brief must include stable task ID and round, baseline SHA, objectives and non-goals, authorized file scope, constraints, ordered steps, acceptance criteria, test commands, delivery format, branch name, evidence requirements, and stop conditions. Use [任务书模板](templates/任务书模板.md).

## 3. Capability and access limits

- A public repository link provides read context only; it does not prove write access, local filesystem access, terminal access, or Windows test capability.
- Antigravity records each capability as Available / Unavailable / Unverified in [能力核验清单](工作流/能力核验清单.md).
- Tests not actually executed must be marked Not run, never Passed.
- If baseline changes, permissions are missing, or requirements conflict, stop and report instead of guessing.

## 4. Standard task cycle

1. Gemini web analyzes the request and repository context, then writes or updates a standalone task brief.
2. The owner reviews and explicitly authorizes the task.
3. Antigravity reads the brief and workflow rules, verifies capabilities, and independently implements the scope.
4. Antigravity performs available checks, packages the complete output as one ZIP, and writes a truthful completion receipt and SHA-256.
5. Antigravity submits to a dedicated delivery branch and DELIVERY/INBOX/待交付/ when possible. If remote write capability is unavailable, it reports that and provides the local package; it must not claim a push occurred.
6. The owner verifies the branch/commit or package and explicitly asks ChatGPT to review.
7. ChatGPT independently reviews the exact submission. If changes are needed, it records findings; Gemini web prepares the next rework brief; the owner authorizes the next round.
8. After review, ChatGPT archives the original delivery and review report, updates task/review/archive indexes, and clears only the processed inbox contents.
9. Final acceptance and task closure require the owner's explicit decision.

## 5. Required completion receipt

Task ID and round; model actually used; baseline SHA; branch and commit SHA if pushed; ZIP SHA-256; file manifest; repository changes; actual commands and exit codes; test results; unrun tests and reasons; deviations, risks, and known limitations; confirmation that main was not pushed and no PR was merged.

## 6. Status separation

Production complete, branch pushed, independent review passed, local verification passed, owner accepted, and archived are distinct states. Never conflate them.
