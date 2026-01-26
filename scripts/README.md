# Swift Package 自动版本管理

本目录包含 MagicKit Swift Package 的版本管理脚本，完全遵循 Swift Package Manager 规范。

## 📋 脚本说明

### `bump-version.sh`

根据 Conventional Commits 规范分析提交历史，决定版本增量类型。

**输出：** `major` | `minor` | `patch`

**规则：**

- **major**: 包含 `BREAKING CHANGE` 或 `feat!` / `fix!` / `refactor!`
- **minor**: 包含 `feat:` 提交
- **patch**: 其他所有情况（bug fix、文档更新等）

### `calculate-version.sh`

基于最新标签和增量类型，计算下一个版本号。

**输出：** 语义化版本号（如 `1.4.1`）

**特性：**

- 自动兼容带 `v` 前缀的旧标签
- 新标签不带前缀（符合 Swift Package 规范）
- 完全基于 Git 标签，无需任何配置文件

## 🚀 使用方法

### 手动使用

```bash
# 查看增量类型
./scripts/bump-version.sh

# 计算新版本号
./scripts/calculate-version.sh

# 创建新标签（示例）
VERSION=$(./scripts/calculate-version.sh)
git tag -a "$VERSION" -m "Release $VERSION"
git push origin "$VERSION"
```

### 自动使用（推荐）

推送代码到 `main` 分支，GitHub Actions 会自动：

1. 分析提交历史
2. 计算新版本号
3. 创建 Git 标签
4. 生成 GitHub Release
5. 同步更新 `dev` 分支

## 📖 版本号示例

假设当前版本是 `1.4.0`：

| 提交类型 | 示例 Commit Message | 新版本 |
|---------|---------------------|--------|
| PATCH | `fix: resolve memory leak` | `1.4.1` |
| MINOR | `feat: add PDF thumbnail support` | `1.5.0` |
| MAJOR | `feat!: redesign public API` | `2.0.0` |
| MAJOR | `fix: remove deprecated methods` + `BREAKING CHANGE: ...` | `2.0.0` |

## ⚠️ 重要说明

### Swift Package 版本规范

**标签格式：**

- ✅ 正确：`1.4.1`
- ❌ 错误：`v1.4.1`

**版本来源：**

- Swift Package Manager 从 Git 标签读取版本号
- `Package.swift` 中不声明版本号
- 不需要 `package.json` 或其他版本文件

### 旧标签兼容性

项目之前使用带 `v` 前缀的标签（如 `v1.4.0`），脚本会：

- 自动识别并兼容旧标签
- 新生成的标签不带前缀（符合规范）
- 从 `v1.4.0` 递增到 `1.4.1`（而非 `v1.4.1`）

## 🧪 测试

```bash
# 测试版本增量分析
./scripts/bump-version.sh

# 测试版本计算
./scripts/calculate-version.sh

# 查看当前标签
git describe --tags --abbrev=0

# 查看提交历史
git log v1.4.0..HEAD --oneline
```

## 📚 相关资源

- [Swift Package Manager - Publishing](https://github.com/swiftlang/swift-package-manager/blob/main/Sources/PackageManagerDocs/Documentation.docc/ReleasingPublishingAPackage.md)
- [Semantic Versioning 2.0.0](https://semver.org/)
- [Conventional Commits](https://www.conventionalcommits.org/)

---

**最后更新：** 2026-01-26
**维护者：** nookery
