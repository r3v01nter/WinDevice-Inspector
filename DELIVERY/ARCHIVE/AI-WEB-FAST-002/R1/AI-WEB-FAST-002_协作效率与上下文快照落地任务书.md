# AI-WEB-FAST-002｜AI 协作效率与一页纸上下文快照落地任务书

## 网页端 30 秒速读头（Quick Start Header）

- **任务编号**：AI-WEB-FAST-002（轮次：R1）
- **任务类型**：仓库治理文档优化（轻量文档落地，不涉及业务代码）
- **推荐执行方**：Antigravity（本地工作区直接实施并推送独立交付分支）
- **独立审核者**：ChatGPT GPT-6（仅在项目负责人明确触发后审查）
- **最终决策者**：项目负责人
- **参考基准**：`main` 分支（核验参考提交：`a396da87bc371e3e06417800eda27e5fa40cdb33`、`15133b7`、`a77b823`、`d06dbe4`；实施前由 Antigravity 以本地最新 `main` HEAD 为准）
- **目标交付分支**：`delivery/AI-WEB-FAST-002-R1`（**严禁直接推送 `main` 或自动合并 PR**）
- **交付形态**：推送独立交付分支 + 生成简短完成回执（由负责人触发 ChatGPT 审查）

---

## 1. 任务目标

落实 `AI-WEB-FAST-001` 审计建议中最具性价比的三项协作效率优化，将 Gemini 网页端接手新任务的冷启动时间从 2–5 分钟（多页远程浏览）压缩到接近 0 秒（附件投喂 / 最多 2 跳核验）：

1. **新增一页纸上下文快照**：在仓库中新增 `docs/AI_CONTEXT_SNAPSHOT.md`（≤ 120 行），供项目负责人派任务时直接作为附件投喂给网页端 AI。
2. **压缩日常必读入口跳数（4 跳 → 2 跳）**：将 `docs/工作流/README.md` 的核心入口信息吸收到 `AI_AGENT_GUIDE.md`，补充“附件/Raw 链接优先、必读文件 ≤ 4 个”的快速阅读规则，并进一步明确 Gemini 网页端与 Antigravity 的分工边界。
3. **升级任务书模板**：在 `docs/templates/任务书模板.md` 顶部插入“网页端 30 秒速读头（Quick Start Header）”与 Raw 链接表规范。

## 2. 本任务包附带的待填入文件清单

本压缩包 `files_to_apply/` 目录下已准备好全部文本内容，Antigravity 实施时只需按以下落位表核对并应用：

| 随包文件 | 仓库目标路径 | 操作方式 | 说明 |
| :--- | :--- | :---: | :--- |
| `files_to_apply/docs/AI_CONTEXT_SNAPSHOT.md` | `docs/AI_CONTEXT_SNAPSHOT.md` | **直接新增** | 实施前请将顶部的 `基准 Commit SHA` 更新为本地 `git rev-parse HEAD` 的最新值 |
| `files_to_apply/AI_AGENT_GUIDE_建议修订版.md` | `AI_AGENT_GUIDE.md` | **对比合并（Diff 后更新）** | 请与当前 `main` 分支的 `AI_AGENT_GUIDE.md` 逐行比对，保留原文件所有安全红线与特化条款，仅合入快速阅读规则与简化导航 |
| `files_to_apply/docs/templates/任务书_速读头模板片段.md` | `docs/templates/任务书模板.md` | **顶部插入** | 插入至现有模板正文最前面，不得删除或破坏原有模板的既有章节 |

*(可选轻量同步：`docs/工作流/README.md` 无需删除，可在顶部加一行提示指向 `AI_AGENT_GUIDE.md` 与 `docs/AI_CONTEXT_SNAPSHOT.md` 即可，避免外部旧链接失效。)*

## 3. 执行步骤（供 Antigravity 按序执行）

1. **同步基线并切出独立分支**：
   - 在本地确保 `main` 为最新状态，切出新分支：`git checkout -b delivery/AI-WEB-FAST-002-R1`。
   - 记录当前 `main` 的完整 40 位 Commit SHA。
2. **落地 3 处文档更新**：
   - 复制 `files_to_apply/docs/AI_CONTEXT_SNAPSHOT.md` 至 `docs/AI_CONTEXT_SNAPSHOT.md`，并将文首的 `基准 Commit SHA` 刷新为当前最新 `main` SHA。
   - 对比 `AI_AGENT_GUIDE.md` 与 `files_to_apply/AI_AGENT_GUIDE_建议修订版.md`，在保留原有安全门禁的前提下合入“2 跳必读入口 + 附件/Raw 优先 + 网页端/Antigravity 清晰分工”。
   - 将 `files_to_apply/docs/templates/任务书_速读头模板片段.md` 插入 `docs/templates/任务书模板.md` 顶部。
3. **本地自检（必须执行）**：
   - 运行 `git status` 与 `git diff`，确认**仅改动上述指定文档**，无无关文件、无临时文件、无敏感数据。
   - 核对 `docs/AI_CONTEXT_SNAPSHOT.md` 总行数 ≤ 120 行，且与 `docs/任务中心/当前任务.md` 中的任务状态、决策口径完全一致。
   - 核对所有新增相对链接与 `raw.githubusercontent.com` 链接拼写无误。
4. **提交并推送交付分支**：
   - 仅推送至 `delivery/AI-WEB-FAST-002-R1`，输出提交 SHA 与修改摘要，等待项目负责人审核并决定是否触发 ChatGPT 审查。

## 4. 严格禁止事项（红线）

- 严禁直接推送 `main`、强制推送、重写历史或自行合并 PR。
- 严禁搬迁或删除 `docs/任务中心/`、`DELIVERY/INBOX/待交付/`、`DELIVERY/ARCHIVE/` 或任何历史归档文件。
- 严禁修改 `docs/PRODUCT_REQUIREMENTS.md`、17 项不可变更技术约束或 `docs/decisions/ADR-0001-desktop-stack.md`。
- 严禁改变 `TASK-0001` 当前阶段/授权状态或启动 `WDI-DIAG-001 R2` 编码。
- 严禁替项目负责人裁决 `C-02`、`D-01`、`D-06`、`D-09` 等未决事项。

## 5. 验收标准

- [ ] `docs/AI_CONTEXT_SNAPSHOT.md` 已新增、≤ 120 行、包含最新准确 Commit SHA，且可直接作为单文件附件投喂给网页端 AI。
- [ ] `AI_AGENT_GUIDE.md` 已整合快速阅读原则（附件/Raw 优先、必读 ≤ 4 个、常规 2 跳），原有安全门禁零丢失。
- [ ] `docs/templates/任务书模板.md` 已增加“网页端 30 秒速读头”，未破坏原有模板结构。
- [ ] 仅在独立分支 `delivery/AI-WEB-FAST-002-R1` 提交，无任何越界文件改动，待项目负责人最终批准后合并。
