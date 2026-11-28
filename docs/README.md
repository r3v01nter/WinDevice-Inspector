# Documentation Index

This directory contains the maintained product and engineering documentation.

## Start here

- [AI Agent Guide](../AI_AGENT_GUIDE.md): mandatory repository entry point for all agents.
- [工作流执行规范](工作流/README.md): roles, capability checks, implementation, review, and archive lifecycle.

- [任务中心](任务中心/README.md): Chinese project-management entry point and live task navigation.
- [当前任务](任务中心/当前任务.md): the single current work pointer and direct task brief link.
- [TASK-0001 阶段 A R2 修订任务书](tasks/TASK-0001_阶段A_R2_修订任务书.md): current authorized document-only revision task.
- [TASK-0001 正式实现任务书](tasks/TASK-0001_正式实现任务书.md): original implementation contract; Phase B is not authorized.
- [TASK-0001 阶段 A R1 独立审查报告](reviews/TASK-0001_阶段A_R1_独立审查报告.md): R1 review result and required revisions.
- [任务创建与推进规范](任务中心/任务创建与推进规范.md): reusable task lifecycle and standalone task-brief standard.
- [任务索引](任务中心/任务索引.md): all tasks and their current states.
- [审查索引](任务中心/审查索引.md): independent review and verification history.
- [Project Overview](PROJECT_OVERVIEW.md): product purpose, users, principles, and scope.
- [Product Requirements](PRODUCT_REQUIREMENTS.md): confirmed user-facing behavior and acceptance expectations.
- [Technical Architecture](TECHNICAL_ARCHITECTURE.md): layers, data flow, collection boundaries, storage, and testing.
- [Repository Structure](REPOSITORY_STRUCTURE.md): directory responsibilities and naming rules.
- [Roadmap](ROADMAP.md): staged delivery sequence.
- [Project Status](PROJECT_STATUS.md): current verified state and next actions.
- [AI Collaboration](AI_COLLABORATION.md): Gemini code production, Antigravity delivery, and ChatGPT review.
- [AI 交付操作手册](AI_交付操作手册.md): exact local staging, packaging, branch, commit, and manual review-trigger procedure.

## Reference material

- `decisions/`: accepted architecture decision records (ADRs).
- `tasks/`: one standalone task brief per task, with a stable task ID. New task briefs use Chinese filenames.
- `templates/`: reusable task, completion receipt, review, and issue templates.
  - [中文任务书模板](templates/任务书模板.md)
  - [中文完成回执模板](templates/完成回执模板.md)
  - [审查报告模板](templates/审查报告模板.md)
  - [缺陷记录模板](templates/缺陷记录模板.md)
- `reviews/`: independent review reports and owner-provided local verification records.
- `issues/`: confirmed defects and their retest records.
- `任务中心/`: user-facing project management, workflow, and navigation.

## Delivery\n\n- [交付中心总入口](../DELIVERY/README.md): inbox, review states, templates, and archive lifecycle.

- [唯一交付入口](../DELIVERY/INBOX/待交付/): Antigravity pushes each round's complete package to a dedicated delivery branch, in this flat repository inbox.
- [本地暂存区](../DELIVERY/LOCAL_STAGING/待上传/): local-only Gemini downloads, ignored by Git and never committed.
- [原始交付归档](../DELIVERY/ARCHIVE/): immutable historical delivery batches.

## Document precedence

1. Confirmed product decisions in `PRODUCT_REQUIREMENTS.md` and its detailed scope document `完整设备诊断与报告导出需求.md`.
2. Accepted architecture decision records in `decisions/`.
3. Current technical architecture.
4. The active task brief, which must be corrected if it conflicts with a higher-level decision.
5. Roadmap and status summaries.

The task center tracks work status; it does not override product requirements or accepted architecture decisions. If a contradiction is found, stop and report it. Do not silently choose a new product behavior.

## Confirmed product baseline

- [完整设备诊断与报告导出需求](完整设备诊断与报告导出需求.md): detailed confirmed scope for device enumeration, hardware state, diagnostic outcomes, collection completeness, and AI-ready ZIP reports.
