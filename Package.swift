// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MagicKit",  // 包名称
    platforms: [
        .macOS(.v14),  // 最低支持 macOS 14
        .iOS(.v17)     // 最低支持 iOS 17
    ],
    // 定义对外提供的库（可被其他项目导入）
    products: [
        .library(name: "MagicKit", targets: ["MagicKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-async-algorithms", from: "0.1.0"),  // Apple 的异步算法库
        .package(url: "https://github.com/chicio/ID3TagEditor", from: "4.5.0"),  // ID3 标签编辑器
        .package(url: "https://github.com/weichsel/ZIPFoundation.git", from: "0.9.19"),  // ZIP 文件处理库
        .package(url: "https://github.com/nookery/MagicAlert.git", from: "0.0.1"),  // MagicAlert 通知库
        .package(url: "https://github.com/nookery/MagicDevice.git", from: "0.0.1"),  // MagicDevice 设备模块
        .package(url: "https://github.com/nookery/MagicUI.git", from: "1.0.0"),  // MagicUI 组件库
    ],
    // 编译目标（模块）
    targets: [
       .target(
           name: "MagicKit",
           dependencies: [
               .product(name: "AsyncAlgorithms", package: "swift-async-algorithms"),
               .product(name: "MagicAlert", package: "MagicAlert"),
               .product(name: "MagicUI", package: "MagicUI"),
               "ID3TagEditor",
               "ZIPFoundation",
           ]
       ),
       .testTarget(
           name: "Tests",
           dependencies: ["MagicKit"]
       )    ]
)
