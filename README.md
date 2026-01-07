# MagicKit

MagicKit 是一个综合性的 SwiftUI 工具包，为 macOS 和 iOS 应用开发提供完整的解决方案。

## 功能特性

- **🎵 MagicPlayMan**: 强大的媒体播放管理器，支持音频和视频播放
- **📱 MagicDevice**: 设备特定的组件和响应式设计工具
- **🔄 MagicSync**: 云同步和数据持久化解决方案
- **🎨 MagicUI**: 丰富的 UI 组件和视觉效果
- **🌐 MagicHttp**: HTTP 客户端和网络工具
- **📊 MagicCore**: 核心工具和扩展
- **⚠️ MagicError**: 错误处理和用户友好的错误显示
- **🎭 MagicBackground**: 动态背景和视觉效果
- **📦 MagicAsset**: 资源管理和媒体处理
- **📱 MagicContainer**: 容器组件和布局工具
- **💾 MagicData**: 数据管理和持久化
- **🖥️ MagicDesktop**: 桌面特定功能和组件

## 安装

### Swift Package Manager

将以下依赖添加到您的 `Package.swift` 文件中：

```swift
dependencies: [
    .package(url: "https://github.com/nookery/MagicKit.git", branch: "main")
]
```

然后在目标中添加：

```swift
.target(
    name: "YourTarget",
    dependencies: [
        .product(name: "MagicKit", package: "MagicKit")
    ]
)
```

或者在 Xcode 中：
1. 打开您的项目
2. 选择 File > Swift Packages > Add Package Dependency
3. 输入仓库 URL：`https://github.com/nookery/MagicKit.git`

## 使用方法

```swift
import SwiftUI
import MagicKit

struct ContentView: View {
    var body: some View {
        // 现在您可以使用所有 MagicKit 组件！
        MagicPlayMan() // 媒体播放
        MagicDevice.currentDeviceType() // 设备信息
        // ... 等等
    }
}
```

## 系统要求

- iOS 17.0+ 或 macOS 14.0+
- Swift 5.9+

## 测试

要运行 MagicKit 的单元测试，请在终端中导航到项目根目录，然后运行以下命令：

```bash
swift test
```

## 构建

```bash
swift build
```

## Maintainers

Work for Joy & Live for Love ➡️ <https://github.com/nookery>
