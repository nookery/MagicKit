# MagicKit 开发指南

本文档整合了 MagicKit Swift Package 的所有开发规范和最佳实践。

## 项目概述

MagicKit 是一个 Swift Package Library，提供可重用的 SwiftUI 组件、工具类和扩展。

### 核心功能模块

- **AvatarView** - 文件缩略图展示组件，支持图片、视频、音频等多种文件类型
- **Thumbnail** - 缩略图生成系统，带缓存机制
- **URL Extensions** - 文件 URL 操作扩展（iCloud、下载、复制等）
- **UI Components** - 可重用的 SwiftUI 组件
- **Utility** - 日志、缓存等工具类

### 技术栈

- **Swift** - 5.9+
- **SwiftUI** - UI 框架
- **Combine** - 响应式编程
- **Async/Await** - 异步操作
- **OSLog** - 日志记录
- **Actor** - 并发安全

### 平台支持

- macOS 14.0+
- iOS 17.0+

## 开发原则

### 第一步：理解项目架构

在开发任何功能前：

1. 查看项目根目录的 README.md
2. 理解模块化目录结构：
   - `Sources/MagicKit/` - 源代码
   - `Sources/MagicKit/URL/` - URL 扩展（公共入口）
   - `Sources/MagicKit/Thumbnail/` - 缩略图实现细节
   - `Sources/MagicKit/AvatarView/` - AvatarView 组件及其扩展
3. 理解 SuperLog 日志协议
4. 查看现有代码的组织模式

### 第二步：代码编写规范

**文件组织：**
- 每个 struct/class/extension 放在独立文件中
- 使用 MARK 分组组织代码
- 相关文件放在同一目录
- 公共 API 在 `URL/` 扩展中提供
- 实现细节放在专门的模块目录（如 `Thumbnail/`）

**代码质量：**
- 添加详细的中文代码注释
- 使用 `public` 标记公共 API
- 使用 `internal` 或 `private` 隐藏实现细节
- 实现 SuperLog 协议进行日志记录
- 添加适当的错误处理
- 避免 SwiftUI 视图中的内存泄漏

**命名规范：**
- 使用清晰、描述性的名称
- 扩展文件命名：`Type+Feature.swift`（如 `AvatarView+Thumbnail.swift`）
- 方法名使用动词开头（`loadThumbnail`、`setThumbnail`）
- 布尔值使用 `is`、`has` 前缀（`isLoading`、`hasImage`）

### 第三步：遵循规范

必须遵循以下规范（详见 swiftui-standards skill）：

1. **代码组织** - 独立文件、相关目录、MARK 分组
2. **MARK 分组顺序** - View → Action → Setter → Event Handler → Preview
3. **SuperLog 协议** - emoji + verbose + self.t
4. **事件监听** - onXxx 扩展 + perform: 语法
5. **预览代码** - 多尺寸预览

## 核心模式

### 1. SuperLog 日志协议

所有需要日志的类型必须实现 SuperLog 协议：

```swift
struct MyView: View, SuperLog {
    nonisolated static let emoji = "🌿"
    nonisolated static let verbose = false

    func someFunction() {
        if Self.verbose {
            os_log("\(self.t)Detailed debug information")
        }
        os_log("\(self.t)Important operation completed")
    }
}
```

**协议要求：**
- `nonisolated static let emoji` - 独特的 emoji 标识
- `nonisolated static let verbose` - 详细日志控制开关
- 使用 `self.t` 作为日志前缀（自动包含 emoji 和类型名）

### 2. 模块化设计

**URL 扩展模式** - 公共入口：
```swift
// URL/ExtUrl+Thumbnail.swift
extension URL {
    /// 公共 API - 简洁的入口点
    public func thumbnail(
        size: CGSize = CGSize(width: 120, height: 120),
        verbose: Bool,
        reason: String
    ) async throws -> Image? {
        // 检查缓存
        // 调用实现细节
    }
}
```

**实现细节分离** - 复杂逻辑放入专门模块：
```swift
// Thumbnail/ThumbnailGenerator.swift
public struct ThumbnailGenerator {
    // 详细的实现逻辑
    // 支持多种文件类型
    // 缓存管理
}
```

### 3. MARK 分组规范

```swift
// MARK: - Properties
// MARK: - Computed Properties
// MARK: - Initialization
// MARK: - Body
// MARK: - Actions
// MARK: - Setters
// MARK: - Event Handler
// MARK: - Preview
```

### 4. 异步操作模式

```swift
// 使用 async/await
private func loadThumbnail() async {
    await Task.detached(priority: .utility) {
        // 后台工作
    }.value
}

// MainActor 更新 UI
@MainActor
func setThumbnail(_ image: Image?) {
    self.thumbnail = image
}
```

### 5. 错误处理模式

```swift
enum ViewError: Error {
    case fileNotFound
    case invalidURL
    case thumbnailGenerationFailed(Error)
}

// 使用
do {
    try await operation()
} catch {
    await capturedState.setError(ViewError.thumbnailGenerationFailed(error))
}
```

## 开发工作流

1. **规划阶段** - 使用 `/plan` 命令规划复杂功能
2. **开发阶段** - 遵循本指南的规范
3. **构建验证** - ⚠️ **必须运行 macOS 和 iOS 两个平台的构建**（参见下方测试部分）
4. **检查阶段** - 使用 `/swift-check` 命令检查代码规范
5. **提交阶段** - 使用 `/commit` 命令生成 commit message
6. **Git 管理** - 遵循 `.claude/GIT_WORKFLOW.md` 中定义的分支策略

**⚠️ 重要：构建验证是强制步骤，不能跳过！**

### Git 分支管理

MagicKit 使用 **GitHub Flow** 工作流：

- **main** - 生产就绪，始终可部署（自动打版本标签）
- **feature/*** - 功能开发分支（从 main 创建，通过 PR 合并回 main）

详细的 Git 工作流程、提交规范、版本发布流程，请参阅：
📘 **[Git 工作流程指南](.claude/GIT_WORKFLOW.md)**

## 关键注意事项

### Swift Package 特定

- ✅ 没有 AppDelegate 或 SceneDelegate
- ✅ 使用 `#if DEBUG` 条件编译预览代码
- ✅ 公共 API 必须标记为 `public`
- ✅ 内部实现使用 `internal` 或 `private`
- ✅ 注意 `@MainActor` 和线程安全

### SwiftUI 组件开发

- ✅ 使用 `@StateObject` 管理 ViewModel
- ✅ 使用 `@Published` 标记可观察属性
- ✅ 避免 View 中的复杂计算（使用 computed properties）
- ✅ 使用 `async/await` 处理异步操作
- ✅ 在 `.task { }` 中处理视图出现时的加载

### 性能优化

- ✅ 使用缓存减少重复计算（ThumbnailCache）
- ✅ 延迟加载缩略图（loadDelay）
- ✅ 使用 `Task.detached` 进行后台工作
- ✅ 取消不需要的任务（检查 `Task.isCancelled`）
- ✅ 避免在 View 中创建新对象

### 内存管理

- ✅ 在 `onDisappear` 中取消 Combine 订阅
- ✅ 使用 `[weak self]` 避免循环引用
- ✅ 及时释放不需要的资源
- ✅ 注意 `@Published` 属性的内存占用

## 依赖管理

MagicKit 使用的依赖：

```swift
// Package.swift
dependencies: [
    .package(url: "https://github.com/apple/swift-async-algorithms", from: "0.1.0"),
    .package(url: "https://github.com/chicio/ID3TagEditor", from: "4.5.0"),
    .package(url: "https://github.com/weichsel/ZIPFoundation.git", from: "0.9.19"),
    .package(url: "https://github.com/nookery/MagicAlert.git", from: "0.0.1"),
    .package(url: "https://github.com/nookery/MagicUI.git", from: "1.0.0"),
]
```

添加新依赖时：
1. 确保与项目平台兼容（macOS 14+, iOS 17+）
2. 在 Package.swift 中添加
3. 在相应 target 中引入 product
4. 运行 `swift build` 验证

## 测试

### ⚠️ 多平台构建验证（重要）

**MagicKit 支持 macOS 和 iOS 两个平台，每次构建前必须验证两个平台的编译！**

```bash
# 1. macOS 构建（默认）
swift build

# 2. iOS 模拟器构建（必须验证）
swift build \
  --destination "generic/platform=iOS Simulator" \
  -Xswiftc "-target" \
  -Xswiftc "arm64-apple-ios17.0-simulator" \
  -Xswiftc "-sdk" \
  -Xswiftc "$(xcrun --sdk iphonesimulator --show-sdk-path)"

# 3. 运行测试
swift test
```

**为什么需要多平台验证？**

- MagicKit 在 `Package.swift` 中声明了支持 `macOS(.v14)` 和 `iOS(.v17)`
- 某些 API 是平台特定的（如 `AppKit` 仅在 macOS 可用）
- 需要使用条件编译 `#if canImport(AppKit)` 来处理平台差异
- 用户可能在 iOS 或 macOS 项目中使用 MagicKit

**常见平台特定代码处理：**

```swift
// ✅ 正确：使用条件编译
#if canImport(AppKit)
import AppKit

// macOS 专用代码
public extension NSImage {
    func someMethod() { }
}
#endif

// ❌ 错误：直接导入平台特定框架
import AppKit  // 在 iOS 上会导致编译错误
```

**构建验证时机：**

- ✅ 修改代码后，提交前必须运行 macOS 和 iOS 构建
- ✅ 特别是修改了导入语句或添加新文件时
- ✅ 如果使用了平台特定的 API（如 AppKit、UIKit），必须验证两个平台

**构建失败处理：**

如果 iOS 构建失败：
1. 检查是否使用了平台特定的框架
2. 添加 `#if canImport(XXX)` 条件编译
3. 确保依赖库也支持目标平台
4. 某些依赖可能仅支持 macOS（如 MagicDevice），这是正常的

### 其他测试命令

```bash
# 在 Xcode 中打开
open Package.swift

# 清理构建
swift package clean
```

## 常见命令

```bash
# 检查代码格式
swift format .

# 构建验证
swift build

# 清理构建
swift package clean
```

## Emoji 选择指南

### UI 相关
- `🌿` - View 组件
- `🖼️` - 图片/缩略图
- `📁` - 文件管理
- `🔗` - URL/链接

### 数据相关
- `💾` - 数据存储/缓存
- `🔄` - 数据同步
- `⬇️` - 下载

### 系统相关
- `⚙️` - 系统配置
- `🔔` - 通知
- `🚉` - AvatarView 专用
- `📥` - 下载监控

## 参考资料

- [Swift Package Manager](https://www.swift.org/package-manager/)
- [SwiftUI](https://developer.apple.com/documentation/swiftui/)
- [Combine](https://developer.apple.com/documentation/combine/)
- [Swift Concurrency](https://docs.swift.org/swift-book/LanguageGuide/Concurrency.html)
