# Documentation Index

This directory contains the maintained product and engineering documentation.

## Start here

- [任务中心](任务中心/README.md): Chinese project-management entry point, current task, task index, review index, and development change record.
- [当前任务](任务中心/当前任务.md): the single current work pointer.
- [任务索引](任务中心/任务索引.md): all tasks and their current states.
- [审查索引](任务中心/审查索引.md): independent review and verification history.
- [Project Overview](PROJECT_OVERVIEW.md): what the product is, why it exists, who it serves, and what is in/out of scope.
- [Product Requirements](PRODUCT_REQUIREMENTS.md): confirmed user-facing behavior and acceptance expectations.
- [Technical Architecture](TECHNICAL_ARCHITECTURE.md): layers, data flow, collection boundaries, storage, and testing.
- [Repository Structure](REPOSITORY_STRUCTURE.md): directory responsibilities and naming rules.
- [Roadmap](ROADMAP.md): staged delivery sequence.
- [Project Status](PROJECT_STATUS.md): current verified state and next actions.
- [AI Collaboration](AI_COLLABORATION.md): Gemini implementation workflow and ChatGPT technical review.

## Reference material

- `decisions/`: accepted architecture decision records (ADRs).
- `tasks/`: task briefs and acceptance criteria. New task briefs should use Chinese filenames while retaining stable task IDs.
- `templates/`: reusable task, completion receipt, review, and issue templates.
  - [中文任务书模板](templates/任务书模板.md)
  - [中文完成回执模板](templates/完成回执模板.md)
  - [审查报告模板](templates/审查报告模板.md)
  - [缺陷记录模板](templates/缺陷记录模板.md)
- `reviews/`: independent review reports and owner-provided local verification records.
- `issues/`: confirmed defects and their retest records.
- `任务中心/`: user-facing project management and navigation.

## Delivery

- [唯一交付入口](../DELIVERY/INBOX/待交付/): owner-reviewed complete delivery files from Gemini.
- [原始交付归档](../DELIVERY/ARCHIVE/): immutable historical delivery batches.

## Document precedence

1. Confirmed product decisions in `PRODUCT_REQUIREMENTS.md`.
2. Accepted architecture decisions in `decisions/`.
3. Current technical architecture.
4. The active task brief, which must be updated if it conflicts with a higher-level decision.
5. Roadmap and status summaries.

The task center tracks work status; it does not override product requirements or accepted architecture decisions. If a contradiction is found, stop and report it. Do not silently choose a new product behavior.
