---
name: swiftui-standards
description: Swift Package 开发标准规范，包括代码组织、MARK 分组、日志记录、预览代码和异步操作的统一规范。
---

# Swift Package 开发标准规范

本技能确保所有 MagicKit Swift Package 代码遵循项目的统一开发规范。

## 何时使用

- 编写新的 SwiftUI 视图或组件
- 重构现有 Swift 代码
- 添加 URL 扩展或工具类
- 实现异步操作
- 组织代码结构

## 核心规范

### 1. 代码组织原则

**文件组织：**
- 每个 struct/class/extension 应该放在独立的文件中
- 文件名应与类型名称保持一致
- 扩展文件命名：`Type+Feature.swift`（如 `AvatarView+Thumbnail.swift`）
- 相关组件应组织在同一目录下
- 公共 API 放在 `URL/` 扩展中
- 实现细节放在专门模块目录（如 `Thumbnail/`）

**目录结构示例：**
```
Sources/MagicKit/
├── AvatarView/              # AvatarView 组件及其扩展
│   ├── AvatarView.swift
│   ├── AvatarView+State.swift
│   ├── AvatarView+Thumbnail.swift
│   └── AvatarView+ErrorView.swift
├── Thumbnail/               # 缩略图实现细节
│   ├── ThumbnailGenerator.swift
│   ├── ThumbnailResult.swift
│   ├── Thumbnail+Audio.swift
│   └── Thumbnail+Video.swift
└── URL/                     # 公共 URL 扩展入口
    ├── ExtUrl+Thumbnail+Read.swift
    ├── ExtUrl+Download.swift
    └── ExtUrl+CopyView.swift
```

### 2. MARK 分组规范

所有 Swift 文件必须按以下顺序使用 MARK 分组：

```swift
// MARK: - Properties           - 属性声明
// MARK: - Computed Properties  - 计算属性
// MARK: - Initialization       - 初始化方法
// MARK: - Body                - SwiftUI View 主体
// MARK: - Actions             - 用户交互触发的行为
// MARK: - Setters             - 状态/属性的集中更新方法
// MARK: - Event Handler       - 事件处理函数
// MARK: - Preview             - 多尺寸预览（仅 View 文件）
```

**示例模板（View）：**
```swift
import SwiftUI

struct MyView: View {
    // MARK: - Properties

    @State private var isLoading = false
    @State private var items: [String] = []
    let configuration: Configuration

    // MARK: - Computed Properties

    private var filteredItems: [String] {
        items.filter { !$0.isEmpty }
    }

    // MARK: - Initialization

    init(configuration: Configuration) {
        self.configuration = configuration
    }

    // MARK: - Body

    var body: some View {
        List(filteredItems, id: \.self) { Text($0) }
            .task {
                await loadData()
            }
    }
}

// MARK: - Actions

extension MyView {
    func refresh() async {
        isLoading = true
        // 刷新逻辑
        isLoading = false
    }
}

// MARK: - Setters

extension MyView {
    @MainActor
    func setItems(_ newValue: [String]) {
        items = newValue
        isLoading = false
    }
}

// MARK: - Preview

#if DEBUG
#Preview("Default") {
    MyView(configuration: .default)
}

#Preview("With Content") {
    MyView(configuration: .sample)
        .frame(width: 400, height: 300)
}
#endif
```

### 3. SuperLog 日志协议

**所有需要日志的类型必须实现 SuperLog 协议：**

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

**日志级别：**
```swift
// 总是输出（重要操作）
os_log("\(self.t)Operation completed")

// 仅开发时输出（调试信息）
if Self.verbose {
    os_log("\(self.t)Detailed debug information")
}
```

### 4. 异步操作规范

**使用 async/await 处理异步操作：**

```swift
// 在后台线程执行耗时操作
private func processData() async {
    await Task.detached(priority: .utility) {
        // CPU 密集型工作
    }.value
}

// MainActor 更新 UI
@MainActor
func updateUI(_ result: String) {
    self.statusText = result
}
```

**在 SwiftUI View 中：**
```swift
var body: some View {
    VStack {
        if isLoading {
            ProgressView()
        }
    }
    .task {
        await loadData()
    }
}
```

### 5. 错误处理规范

**定义项目特定的错误类型：**

```swift
enum ViewError: Error {
    case fileNotFound
    case invalidURL
    case thumbnailGenerationFailed(Error)
    case downloadFailed(Error?)
}
```

**使用 do-catch 处理错误：**
```swift
do {
    let result = try await operation()
    await setState(result)
} catch URLError.cancelled {
    // 任务被取消，忽略
} catch {
    await setError(ViewError.operationFailed(error))
}
```

### 6. 预览代码规范

**每个 View 文件底部必须添加预览：**

```swift
#if DEBUG
#Preview("Default") {
    MyComponent()
}

#Preview("With Content") {
    MyComponent(content: "Example")
        .frame(width: 300, height: 200)
}

#Preview("Dark Mode") {
    MyComponent()
        .preferredColorScheme(.dark)
}
#endif
```

**非 View 组件使用静态工厂方法：**
```swift
extension Configuration {
    static var default: Configuration {
        Configuration()
    }

    static var sample: Configuration {
        Configuration(items: ["Item 1", "Item 2"])
    }
}
```

## Emoji 选择指南

### UI 相关
- `🌿` - View 组件
- `🖼️` - 图片/缩略图
- `📁` - 文件管理
- `🔗` - URL/链接
- `📋` - 表单组件

### 数据相关
- `💾` - 数据存储/缓存
- `🔄` - 数据同步
- `⬇️` - 下载

### 系统相关
- `⚙️` - 系统配置
- `🔔` - 通知
- `🚉` - AvatarView 专用
- `📥` - 下载监控

## 公共 API 设计

**URL 扩展模式：**

```swift
// URL/ExtUrl+Feature.swift
extension URL {
    /// 简洁的公共 API 入口
    /// - Parameters:
    ///   - size: 目标尺寸
    ///   - verbose: 是否输出详细日志
    /// - Returns: 结果或错误
    public func feature(
        size: CGSize = CGSize(width: 120, height: 120),
        verbose: Bool = false
    ) async throws -> Result? {
        // 1. 参数验证
        // 2. 检查缓存
        // 3. 调用实现细节
        // 4. 返回结果
    }
}
```

**实现细节分离：**

```swift
// Thumbnail/ThumbnailGenerator.swift
public struct ThumbnailGenerator {
    public let url: URL
    public let size: CGSize

    public func generate() async throws -> ThumbnailResult? {
        // 详细的实现逻辑
    }
}
```

## 内存管理最佳实践

**避免循环引用：**
```swift
// ❌ 错误：强引用导致循环引用
class MyClass {
    var closure: (() -> Void)?

    func setup() {
        closure = {
            self.doSomething()
        }
    }
}

// ✅ 正确：使用捕获列表
class MyClass {
    var closure: (() -> Void)?

    func setup() {
        closure = { [weak self] in
            self?.doSomething()
        }
    }
}
```

**取消 Combine 订阅：**
```swift
private var cancellables = Set<AnyCancellable>()

func setupSubscriptions() {
    publisher
        .sink { [weak self] value in
            self?.update(value)
        }
        .store(in: &cancellables)
}

func cleanup() {
    cancellables.removeAll()
}
```

**在 View 中使用 onDisappear：**
```swift
var body: some View {
    content
        .onDisappear {
            cleanup()
        }
}
```

## Swift Package 特定注意事项

### 访问控制

- ✅ 公共 API 使用 `public`
- ✅ 内部实现使用 `internal` 或 `private`
- ✅ 使用 `fileprivate` 仅在同一文件内共享

```swift
public struct MyComponent {
    // 公共属性
    public let configuration: Configuration

    // 内部属性
    private var state: InternalState

    // 公共方法
    public func update() async {
        // 实现细节
    }
}
```

### 条件编译

```swift
#if DEBUG
// 调试代码
let verbose = true
#endif

#if os(macOS)
// macOS 特定代码
#endif

#if os(iOS)
// iOS 特定代码
#endif
```

### 没有应用级功能

Swift Package 没有：
- ❌ AppDelegate
- ❌ SceneDelegate
- ❌ Info.plist
- ❌ 应用生命周期

## 最佳实践

### 代码组织
- ✅ 使用 extension 隔离不同 MARK 分组
- ✅ 保持 MARK 分组顺序统一
- ✅ 语义化命名：`loadXxx`、`setXxx`、`handleXxx`
- ✅ 状态更新集中在 Setters 分组

### 异步操作
- ✅ 使用 `async/await` 而非闭包回调
- ✅ 使用 `Task.detached` 进行后台工作
- ✅ 使用 `@MainActor` 更新 UI
- ✅ 检查 `Task.isCancelled` 避免不必要工作

### 日志记录
- ✅ 通过 emoji 快速过滤日志：`log stream | grep "🌿"`
- ✅ 使用 `verbose` 控制调试级别
- ✅ 避免记录敏感信息
- ✅ 使用 `nonisolated static` 优化性能

### 预览代码
- ✅ 提供多种场景预览
- ✅ 使用静态工厂方法创建测试数据
- ✅ 设置合适的 frame 尺寸
- ✅ 使用 `#if DEBUG` 条件编译

## 注意事项

1. **线程安全**：UI 更新操作使用 `@MainActor`
2. **内存管理**：避免循环引用，及时释放资源
3. **错误处理**：定义清晰的错误类型，妥善处理失败
4. **性能优化**：使用缓存，延迟加载，取消不需要的任务
5. **日志过滤**：利用 emoji 快速定位问题类型

遵循此规范可以显著提升代码的可读性、可维护性和开发体验。
