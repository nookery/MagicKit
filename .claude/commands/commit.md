# 智能生成 Commit Message

自动分析代码更改并生成符合规范的提交信息（Conventional Commits 格式）。

## 工作流程

1. **检查 Git 状态**
   - 运行 `git status` 查看当前仓库状态
   - 识别已暂存和未暂存的更改

2. **分析代码差异**
   - 运行 `git diff --staged` 查看已暂存的更改
   - 如果没有暂存的更改，运行 `git diff` 查看未暂存的更改
   - 分析以下内容：
     - 修改的文件类型（组件、扩展、工具类等）
     - 代码变更的性质（新增、修改、删除、重构等）
     - 影响范围和重要性

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

6. **执行确认**
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

是否使用此 commit message？(y/n/edit)
```

## 注意事项

- ✅ 使用中文或英文的 commit message（根据项目约定）
- ✅ 始终分析实际的代码差异
- ✅ 遵循项目的现有 commit 风格
- ✅ 使用清晰、描述性的语言
- ✅ 保持 subject 简洁（< 50 字符）
- ✅ 在 body 中解释 "为什么" 而非 "是什么"
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

## MagicKit 项目约定

### Commit Message 风格

MagicKit 使用带有 Emoji 前缀的 Conventional Commits：

```text
✨ feat(thumbnail): add PDF thumbnail support

feat(avatarview): add error state handling

🐛 fix(url): resolve iCloud download status detection

♻️ refactor(cache): improve cache key generation

⚡ perf(avatarview): lazy load thumbnails

📝 docs(readme): update installation instructions

✅ test(thumbnail): add PDF thumbnail tests

🎨 chore(format): apply swift-format
```

### 常用 Scope

- `avatarview` - AvatarView 组件及扩展
- `thumbnail` - 缩略图生成系统
- `url` - URL 扩展（下载、复制等）
- `cache` - 缓存系统
- `ui` - 通用 UI 组件
- `utils` - 工具类和扩展

## 相关命令

- 使用 `/plan` 在实现复杂功能前进行规划
- 使用 `/code-review` 在 commit 前审查代码
- 使用 `/swift-check` 检查代码规范
