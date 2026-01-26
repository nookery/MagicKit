# 智能生成 Commit Message

自动分析代码更改并生成符合规范的提交信息（Conventional Commits 格式）。

## 工作流程

1. **检查 Git 状态**
   - 运行 `git status` 查看当前仓库状态
   - 识别已暂存和未暂存的更改

2. **分析代码差异并评估版本更新需求**
   - 运行 `git diff --staged` 查看已暂存的更改
   - 如果没有暂存的更改，运行 `git diff` 查看未暂存的更改
   - 分析以下内容：
     - 修改的文件类型（组件、扩展、工具类等）
     - 代码变更的性质（新增、修改、删除、重构等）
     - 影响范围和重要性
   - **根据 commit 类型评估是否需要更新版本号**：
     - **feat** (新功能): → 需要增加 MINOR 版本 (例如 1.3.4 → 1.4.0)
     - **fix** (bug 修复): → 需要增加 PATCH 版本 (例如 1.3.4 → 1.3.5)
     - **BREAKING CHANGE** (破坏性变更): → 需要增加 MAJOR 版本 (例如 1.3.4 → 2.0.0)
     - **docs, chore, style, refactor, test**: → 通常不需要版本更新
   - 如果需要版本更新，提醒用户先更新 `package.json` 中的版本号
   - 当前版本号通过 `node -p "require('./package.json').version"` 查看

3. **查看提交历史**
   - 运行 `git log -10 --oneline` 查看最近 10 条提交
   - 了解项目的 commit message 风格和约定

4. **生成 Commit Message**
   - 基于 Conventional Commits 规范：

     ```text
     <type>(<scope>): <subject>

     <body>

     <footer>
     ```

   - **Type（类型）**：
     - `feat`: 新功能
     - `fix`: 修复 bug
     - `docs`: 文档变更
     - `style`: 代码格式（不影响代码运行的变动）
     - `refactor`: 重构（既不是新增功能，也不是修复 bug）
     - `perf`: 性能优化
     - `test`: 增加测试
     - `chore`: 构建过程或辅助工具的变动
     - `revert`: 回滚之前的 commit

   - **Scope（范围）**：
     - `avatarview`: AvatarView 组件相关
     - `thumbnail`: 缩略图相关
     - `url`: URL 扩展相关
     - `cache`: 缓存相关
     - `ui`: UI 组件相关
     - `utils`: 工具类相关
     - 或其他合适的模块名称

   - **Subject（主题）**：
     - 简洁描述（不超过 50 字符）
     - 不以句号结尾
     - 使用祈使句（如 "add" 而非 "added" 或 "adds"）

   - **Body（正文）**：
     - 详细描述更改内容
     - 说明 "为什么" 而非 "是什么"
     - 每行限制在 72 字符以内

   - **Footer（脚注）**：
     - 关联的 Issue
     - Breaking Changes 说明
     - 其他参考信息

5. **显示建议**
   - 展示生成的 commit message
   - 展示更改的文件列表
   - 展示代码差异摘要

6. **版本号检查（重要）**
   - **评估是否需要更新版本号**：
     - 如果 commit 类型是 `feat`，建议增加 MINOR 版本
     - 如果 commit 类型是 `fix`，建议增加 PATCH 版本
     - 如果有 BREAKING CHANGE，建议增加 MAJOR 版本
     - 如果是 `docs`, `chore`, `style`, `refactor`, `test`，通常不需要更新
   - **如果需要版本更新**：
     - 显示当前版本号：`node -p "require('./package.json').version"`
     - 提示用户更新 `package.json` 中的 version 字段
     - 等待用户更新版本号后再执行 commit
     - 版本号更新应单独 commit，格式为：`chore: bump version to x.x.x`
   - **如果不需要版本更新**：
     - 直接执行 commit

7. **执行确认**
   - 询问用户是否使用生成的 commit message
   - 如果确认，执行：
     - `git add` （如果需要）
     - `git commit -m "message"`
   - 如果需要修改，允许用户编辑

## Commit Message 模板

### 简单更改

```text
feat(avatarview): add loading state indicator
```

### 中等更改

```text
feat(thumbnail): add PDF file thumbnail support

Generate thumbnails from PDF first page using PDFKit.
Support caching and error handling for encrypted PDFs.

- Add Thumbnail+PDF.swift with pdfThumbnail() method
- Integrate with ThumbnailGenerator
- Add isPDF computed property to URL
- Handle encrypted PDF errors gracefully
```

### 复杂更改

```text
refactor(thumbnail): modularize thumbnail generation system

Split thumbnail generation into separate module for better
maintainability. URL extensions now provide simple entry
points while implementation details live in Thumbnail/.

- Create ThumbnailGenerator struct
- Move implementation to Thumbnail/ directory
- Split by file type (Audio, Video, Image, Folder)
- Update URL extensions to use new generator
- Maintain backward compatibility
```

### Bug 修复

```text
fix(avatarview): resolve memory leak in download monitor

Fix Combine subscriptions not being cancelled properly
when view disappears, causing memory leaks.

- Store cancellable in @State property
- Cancel subscription in onDisappear
- Unsubscribe from AvatarDownloadMonitor
```

## 示例输出

### 示例 1: 需要版本更新的提交

```text
📝 建议的 Commit Message:

feat(thumbnail): add video thumbnail generation

Implement video thumbnail generation using AVFoundation.
Supports various video formats and provides cached results.

- Create Thumbnail+Video.swift
- Use AVAssetImageGenerator for frame extraction
- Apply preferred track transform
- Integrate with caching system

Modified files:
  + Sources/MagicKit/Thumbnail/Thumbnail+Video.swift (new)
  + Sources/MagicKit/Thumbnail/ThumbnailGenerator.swift (modified)
  ~ Sources/MagicKit/URL/ExtUrl+Thumbnail+Read.swift (modified)

⚠️  版本号检查：
   当前版本: 1.3.4
   Commit 类型: feat (新功能)
   建议操作: 更新 MINOR 版本到 1.4.0

   请先执行以下命令更新版本号：
   1. 编辑 package.json，将 "version": "1.3.4" 改为 "version": "1.4.0"
   2. git add package.json
   3. git commit -m "chore: bump version to 1.4.0"

   然后再提交此代码更改。

是否使用此 commit message？(y/n/edit)
```

### 示例 2: 不需要版本更新的提交

```text
📝 建议的 Commit Message:

refactor(url): simplify open button implementation

Replace complex HStack structure with single Image view using
system icons. Improve visual styling with card effect.

Changes:
- Use appType.icon(for:) instead of magicButtonIcon
- Add inCard(.regularMaterial) for background
- Add hoverScale(105) for interactivity
- Add shadowSm() and roundedFull() for styling

Modified files:
  ~ Sources/MagicKit/URL/Open/Open+Button.swift

✅ 版本号检查：
   当前版本: 1.3.4
   Commit 类型: refactor (代码重构)
   建议: 不需要更新版本号
   可以直接提交。

是否使用此 commit message？(y/n/edit)
```

## 注意事项

- ✅ 使用中文或英文的 commit message（根据项目约定）
- ✅ 始终分析实际的代码差异
- ✅ 遵循项目的现有 commit 风格
- ✅ 使用清晰、描述性的语言
- ✅ 保持 subject 简洁（< 50 字符）
- ✅ 在 body 中解释 "为什么" 而非 "是什么"
- ✅ **在提交前评估是否需要更新版本号**（见工作流程步骤 6）
- ✅ **版本号更新应单独 commit**，使用格式：`chore: bump version to x.x.x`
- ✅ 使用 Emoji 前缀标识类型（可选）
  - ✨ feat
  - 🐛 fix
  - ♻️ refactor
  - 📝 docs
  - ⚡ perf
  - ✅ test
  - 🎨 chore
- ❌ 不要在没有用户确认的情况下执行 commit
- ❌ 不要忽略 staging area 的状态
- ❌ 不要生成过于通用的 commit message
- ❌ **不要在同一个 commit 中既修改代码又更新版本号**

## MagicKit 项目约定

### 常用 Scope

- `url` - URL 扩展（下载、复制等）
- `cache` - 缓存系统
- `ui` - 通用 UI 组件
- `utils` - 工具类和扩展

### 版本管理约定

MagicKit 使用 **Semantic Versioning**（语义化版本）：

- **版本号格式**：`MAJOR.MINOR.PATCH`（例如 1.3.4）
- **版本号存储**：`package.json` 中的 `version` 字段
- **自动发布**：推送到 `main` 分支时，GitHub Actions 自动增加 PATCH 版本并创建 Release

**版本更新规则**：

| Commit 类型 | 版本更新 | 示例 | 说明 |
|------------|---------|------|------|
| `feat` | MINOR +1 | 1.3.4 → 1.4.0 | 新功能（向后兼容） |
| `fix` | PATCH +1 | 1.3.4 → 1.3.5 | Bug 修复 |
| BREAKING CHANGE | MAJOR +1 | 1.3.4 → 2.0.0 | 破坏性变更 |
| `refactor` | 不更新 | - | 代码重构 |
| `docs` | 不更新 | - | 文档更新 |
| `chore` | 不更新 | - | 构建/配置更新 |
| `style` | 不更新 | - | 代码格式 |
| `test` | 不更新 | - | 测试相关 |

**版本更新流程**：

1. 在提交代码前，评估是否需要更新版本号
2. 如果需要更新，先单独提交版本号变更：

   ```bash
   # 编辑 package.json，手动更新版本号
   # 然后提交
   git add package.json
   git commit -m "chore: bump version to 1.4.0"
   ```

3. 再提交代码更改：

   ```bash
   git commit -m "feat(feature): add new feature"
   ```

**注意事项**：

- ⚠️ **不要**在同一个 commit 中既修改代码又更新版本号
- ⚠️ **不要**在 `dev` 分支上手动创建 tag
- ⚠️ **只**在确定需要发布时才更新版本号
- ✅ 推送到 `main` 分支前，确保版本号已正确更新

## 相关命令

- 使用 `/plan` 在实现复杂功能前进行规划
- 使用 `/code-review` 在 commit 前审查代码
- 使用 `/swift-check` 检查代码规范
