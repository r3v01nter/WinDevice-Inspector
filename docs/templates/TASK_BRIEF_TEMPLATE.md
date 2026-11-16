# TASK-XXXX — [Task title]

- Status: Ready for implementation
- Owner: Project owner
- Coordinator/reviewer: ChatGPT
- Implementer: Gemini
- Target milestone: [Phase]

## 1. Context

[Relevant product requirements, current architecture, prior decisions, and existing implementation state.]

## 2. Objective

[One concrete outcome.]

## 3. Out of scope

- [Explicitly excluded work.]

## 4. Allowed changes

- Create:
  - `[paths]`
- Modify:
  - `[paths]`
- Do not modify:
  - `[paths or protected decisions]`

If the implementation discovers that additional files or dependencies are necessary, stop and report the reason before broadening scope.

## 5. Requirements

1. [Requirement]
2. [Requirement]
3. [Requirement]

## 6. Constraints

- Follow the current architecture and product requirements.
- Keep collection read-only.
- Do not request administrator elevation unless this task explicitly requires it and explains why.
- Do not upload user data or connect to an AI provider.
- Do not fabricate unavailable device values.
- Preserve source details and collection outcome states.
- Do not commit, push, or directly operate the GitHub repository.
- Do not include secrets, credentials, tokens, or private user data in the delivery.

## 7. Acceptance criteria

- [ ] [Observable criterion]
- [ ] Build succeeds.
- [ ] Relevant tests pass.
- [ ] No unrelated files or scope changes.
- [ ] Documentation is updated where necessary.

## 8. Verification

Run and report the exact commands, exit codes, and relevant output:
- `[build command]`
- `[test command]`

Do not claim a test passed unless it was actually executed.

## 9. Delivery package

Return:
- All created/modified source files with complete contents.
- Any required project/configuration files.
- Tests and test data.
- Updated documentation.
- A completed [completion receipt](COMPLETION_RECEIPT_TEMPLATE.md).
- A list of files that should be removed or replaced, if any (do not perform repository operations).

## 10. Completion response

State what is complete, what remains, known limitations, and whether every acceptance criterion passed.
