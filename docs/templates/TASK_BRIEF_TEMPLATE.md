# TASK-XXXX — [Task title]

- Status: Ready for implementation
- Owner: Project owner
- Technical lead/reviewer: ChatGPT
- Primary implementer: Gemini
- Repository: https://github.com/r3v01nter/WinDevice-Inspector
- Branch/ref: [branch or commit]
- Target milestone: [Phase]

## 1. Read first

Read the current public repository and these exact files before implementation:
- `README.md`
- `docs/PRODUCT_REQUIREMENTS.md`
- `docs/TECHNICAL_ARCHITECTURE.md`
- `docs/ROADMAP.md`
- `docs/AI_COLLABORATION.md`
- [relevant ADRs]
- [relevant existing source files]

Do not assume the task brief is a substitute for inspecting the current implementation.

## 2. Context and current state

[Relevant product requirements, architecture, prior decisions, and existing implementation state.]

## 3. Objective

[One concrete, observable outcome.]

## 4. Out of scope

- [Explicitly excluded work.]

## 5. Allowed changes

- Create:
  - `[paths]`
- Modify:
  - `[paths]`
- Do not modify:
  - `[protected paths or decisions]`

If implementation requires additional files, dependencies, permissions, or schema changes, stop and report the reason before broadening scope.

## 6. Requirements and constraints

1. [Requirement]
2. Follow the current architecture and product requirements.
3. Keep system collection read-only.
4. Every scan must be manually initiated and explicitly confirmed immediately before collection. No background or scheduled scans.
5. Do not request administrator elevation unless the task explicitly requires it and explains why; never elevate silently.
6. Do not upload user data or connect to an AI provider.
7. Do not fabricate unavailable device values.
8. Preserve source details and collection outcome states.
9. Do not include secrets, credentials, tokens, or real private user scan data in the delivery.
10. Do not commit, push, or directly operate the GitHub repository unless the task explicitly authorizes a verified workflow.

## 7. Acceptance criteria

- [ ] [Observable criterion]
- [ ] Build succeeds in the required environment, or is explicitly marked Not run with reason.
- [ ] Relevant tests pass, or are explicitly marked Not run.
- [ ] No unrelated files or scope changes.
- [ ] Documentation is updated where necessary.

## 8. Verification

Run and report exact commands, environment, exit codes, and relevant output:
- `[build command]`
- `[test command]`

Do not claim a test passed unless it was actually executed. Distinguish static review, tests run on another OS, and Windows-specific validation.

## 9. Delivery package

Return:
- All created/modified source files with complete contents.
- Required project/configuration files.
- Tests and fixtures.
- Updated documentation.
- A completed [completion receipt](COMPLETION_RECEIPT_TEMPLATE.md).
- A list of files that should be removed/replaced, if any (do not perform repository operations).

Use the task-specific package layout. Do not return snippets or patches alone.

## 10. Completion response

State what is complete, what remains, known limitations, exact verification evidence, and whether each acceptance criterion passed.
