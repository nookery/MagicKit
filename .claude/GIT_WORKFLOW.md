# MagicKit Git 工作流程指南

本文档定义了 MagicKit Swift Package 的 Git 分支管理和版本发布策略。

## 📋 目录

- [分支策略](#分支策略)
- [日常开发流程](#日常开发流程)
- [提交规范](#提交规范)
- [版本发布流程](#版本发布流程)
- [常见场景](#常见场景)
- [故障排查](#故障排查)

---

## 分支策略

### 分支结构

```
main (生产) ← dev (开发) ← feature/* (功能分支)
```

### 分支说明

| 分支 | 用途 | 稳定性 | 标签 | 保护规则 |
|------|------|--------|------|----------|
| **main** | 稳定发布版本 | ⭐⭐⭐ 生产级 | ✅ 打版本标签 | 🔒 推送保护 |
| **dev** | 日常开发集成 | ⭐⭐ 基本稳定 | ❌ 不打标签 | ✅ 常规推送 |
| **feature/*** | 功能开发 | ⭐ 实验中 | ❌ 不打标签 | ❌ 无限制 |

### 分支命名规范

```
feature/功能描述        # 新功能开发
fix/问题描述           # Bug 修复
refactor/模块名称      # 重构
docs/文档内容          # 文档更新
```

示例：
- `feature/pdf-thumbnail`
- `fix/memory-leak-avatar`
- `refactor/thumbnail-cache`
- `docs/readme-update`

---

## 日常开发流程

### 场景 1：开发新功能 ✨

```bash
# 1. 确保本地 dev 是最新的
git checkout dev
git pull origin dev

# 2. 创建功能分支
git checkout -b feature/your-feature-name

# 3. 开发和提交（使用 /commit 命令生成规范的提交消息）
git add .
git commit -m "feat: add PDF thumbnail generator"

# 4. 推送到远程（可选，如果需要备份或协作）
git push -u origin feature/your-feature-name

# 5. 完成开发后，合并回 dev
git checkout dev
git merge feature/your-feature-name

# 6. 推送 dev 分支
git push origin dev

# 7. 删除功能分支（可选）
git branch -d feature/your-feature-name
git push origin --delete feature/your-feature-name
```

### 场景 2：修复 Bug 🐛

```bash
# 对于简单的 Bug 修复，可以直接在 dev 分支工作
git checkout dev
git pull origin dev

# 修复并提交
git add .
git commit -m "fix: resolve thumbnail memory leak"

git push origin dev
```

**重要**：如果是影响生产环境的紧急 Bug，需要：
1. 从 main 创建 `hotfix/bug-description` 分支
2. 修复后同时合并到 main 和 dev
3. 在 main 上创建新的版本标签

### 场景 3：代码重构 🔧

```bash
# 1. 创建重构分支
git checkout dev
git pull origin dev
git checkout -b refactor/module-name

# 2. 进行重构
# ...

# 3. 确保测试通过
swift test

# 4. 合并回 dev
git checkout dev
git merge refactor/module-name
git push origin dev
```

---

## 提交规范

### Conventional Commits 格式

MagicKit 使用 [Conventional Commits](https://www.conventionalcommits.org/) 规范：

```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

### 类型（Type）

| 类型 | 说明 | 示例 |
|------|------|------|
| `feat` | 新功能 | `feat: add PDF thumbnail support` |
| `fix` | Bug 修复 | `fix: resolve memory leak in cache` |
| `refactor` | 重构 | `refactor: simplify thumbnail generator` |
| `docs` | 文档更新 | `docs: update README installation guide` |
| `test` | 测试相关 | `test: add unit tests for URL extensions` |
| `chore` | 构建/工具/依赖更新 | `chore: upgrade SwiftFormat to 0.507` |
| `perf` | 性能优化 | `perf: optimize thumbnail caching` |
| `ci` | CI 配置 | `ci: add GitHub Actions workflow` |
| `style` | 代码格式 | `style: fix indentation in AvatarView` |

### 作用域（Scope）

可选，用于指明提交影响的模块：

- `thumbnail` - 缩略图相关
- `url` - URL 扩展
- `avatar` - AvatarView 组件
- `cache` - 缓存系统
- `deps` - 依赖管理
- `docs` - 文档

### 示例

```bash
feat(thumbnail): add PDF thumbnail generation support
fix(url): resolve iCloud URL parsing issue
refactor(cache): simplify cache key generation
docs(readme): update installation instructions
chore(deps): bump ID3TagEditor to 5.5.0
```

### 多行提交

```bash
git commit -m "feat: add PDF thumbnail support

- Implement PDF page rendering using PDFKit
- Add caching for generated thumbnails
- Handle encrypted and corrupted PDF files gracefully
- Update documentation with examples

Closes #123"
```

---

## 版本发布流程

### 语义化版本（Semver）

MagicKit 遵循 [Semantic Versioning 2.0.0](https://semver.org/)：

```
MAJOR.MINOR.PATCH

例：1.4.0
  │  │  └─ PATCH：Bug 修复（向后兼容）
  │  └──── MINOR：新功能（向后兼容）
  └─────── MAJOR：破坏性变更
```

### 发布步骤

```bash
# 1. 确保 dev 稳定且测试通过
git checkout dev
git pull origin dev
swift test

# 2. 更新版本号
# 编辑 Package.swift 中的版本号
# 例：从 1.3.7 -> 1.4.0

# 3. 提交版本更新
git add Package.swift
git commit -m "chore: bump version to 1.4.0"

# 4. 合并到 main
git checkout main
git pull origin main
git merge dev

# 5. 创建版本标签
git tag -a v1.4.0 -m "Release v1.4.0: Add PDF thumbnail support

Features:
- PDF thumbnail generation
- Improved cache performance
- Bug fixes for URL parsing"

# 6. 推送 main 和标签
git push origin main
git push origin v1.4.0

# 7. 在 GitHub 上创建 Release
# - 访问 https://github.com/nookery/MagicKit/releases
# - 点击 "Draft a new release"
# - 选择标签 v1.4.0
# - 填写 Release notes
# - 发布
```

### 版本号决策树

```
是否包含破坏性变更？
├─ 是 → MAJOR +1 (1.3.7 → 2.0.0)
└─ 否 → 是否有新功能？
         ├─ 是 → MINOR +1 (1.3.7 → 1.4.0)
         └─ 否 → PATCH +1 (1.3.7 → 1.3.8)
```

### CHANGELOG 维护

在发布新版本时，更新 `CHANGELOG.md`：

```markdown
## [1.4.0] - 2026-01-26

### Added
- PDF thumbnail generation support
- Configurable thumbnail quality

### Fixed
- Memory leak in thumbnail cache
- iCloud URL parsing issues

### Changed
- Improved cache performance by 40%

### Deprecated
- Old `thumbnail(size:)` method (use `thumbnail(size:scale:)` instead)
```

---

## 常见场景

### 场景 1：发现提交写错了

```bash
# 如果还没有推送到远程
git commit --amend -m "correct: fix typo in function name"

# 如果已经推送，不要使用 amend，而是创建新的提交
git commit -m "fix: correct function name typo"
```

### 场景 2：需要撤销最近的提交

```bash
# 保留更改，撤销提交
git reset HEAD~1

# 完全撤销提交和更改
git reset --hard HEAD~1

# 已推送的情况（需要 force push，谨慎使用）
git reset --hard HEAD~1
git push origin dev --force
```

### 场景 3：dev 领先 main 太多，需要同步

```bash
# 将 main 合并到 dev
git checkout dev
git pull origin dev
git merge main
git push origin dev
```

### 场景 4：处理 Dependabot 的依赖更新

```bash
# Dependabot 会自动创建分支，审查后合并
git checkout dev
git pull origin dev
git merge dependabot/swift/dev/github/user/repo-version
git push origin dev
```

### 场景 5：分支冲突

```bash
# 1. 尝试合并时遇到冲突
git merge dev
# Auto-merging file.swift
# CONFLICT (content): Merge conflict in file.swift

# 2. 手动解决冲突
# 编辑文件，解决冲突标记

# 3. 标记冲突已解决
git add file.swift

# 4. 完成合并
git commit
```

---

## 故障排查

### 问题 1：main 和 dev 分叉

**症状**：`git log --graph --all --oneline` 显示两个分支有不同的历史

**原因**：直接在 main 上提交，或者合并操作不一致

**解决方案**：
```bash
# 1. 检查差异
git log main..dev
git log dev..main

# 2. 确保正确的合并顺序
git checkout main
git merge dev -m "merge: sync dev changes to main"

# 3. 如果不需要 main 的独立提交
git reset --hard dev
git push origin main --force
```

### 问题 2：标签推送失败

**症状**：`git push` 没有包含新标签

**解决方案**：
```bash
# 推送所有标签
git push origin --tags

# 推送特定标签
git push origin v1.4.0
```

### 问题 3：提交后忘记推送到远程

**解决方案**：
```bash
# 推送当前分支
git push origin HEAD

# 或推送所有分支
git push --all origin
```

### 问题 4：不小心删除了分支

**解决方案**：
```bash
# 如果推送到了远程，可以从远程恢复
git fetch origin
git checkout -b dev origin/dev
```

---

## 最佳实践

### ✅ 推荐做法

1. **频繁提交**：小步快跑，每次提交一个完整的逻辑单元
2. **编写清晰的提交消息**：让未来的自己（和他人）理解为什么要做这个更改
3. **保持 dev 稳定**：dev 分支应该随时可以合并到 main
4. **使用功能分支**：即使是单人开发，功能分支也能帮助你保持思路清晰
5. **定期同步**：定期将 main 合并到 dev，避免分叉过大
6. **打标签**：每次发布 main 的新版本时打标签

### ❌ 避免做法

1. **不要直接在 main 上开发**（除了 hotfix）
2. **不要推送未测试的代码到 main**
3. **不要使用 `git push --force`**（除非你完全理解后果）
4. **不要在功能分支上停留太久**：及时合并或删除
5. **不要忽略合并冲突**：及时解决，不要堆积

---

## 工具和命令速查

### 常用命令

```bash
# 查看状态
git status
git log --oneline --graph --all --decorate

# 分支操作
git branch -a                    # 查看所有分支
git checkout -b new-branch       # 创建并切换分支
git branch -d old-branch         # 删除本地分支

# 合并操作
git merge dev                    # 合并 dev 到当前分支
git merge --no-ff dev           # 合并时创建合并提交

# 标签操作
git tag                          # 查看所有标签
git tag -a v1.0.0 -m "message"  # 创建标签
git push origin --tags          # 推送所有标签

# 远程操作
git remote -v                    # 查看远程仓库
git push origin --all           # 推送所有分支
git fetch --all                 # 获取所有远程更新
```

### 有用的别名（可选）

在 `~/.gitconfig` 中添加：

```ini
[alias]
    st = status
    co = checkout
    br = branch
    lg = log --graph --oneline --all --decorate
    unstage = reset HEAD --
    last = log -1 HEAD
```

---

## 附加资源

- [Git 官方文档](https://git-scm.com/doc)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [Semantic Versioning](https://semver.org/)
- [GitHub Flow](https://docs.github.com/en/get-started/quickstart/github-flow)
- [Effective Git](https://github.com/effectigent/git-effective)

---

**最后更新**：2026-01-26
**维护者**：nookery
