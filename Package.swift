// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LittleSDK",
    defaultLocalization: "en",
    platforms: [
        // Only add support for iOS 11 and up.
        .iOS(.v11)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "LittleSDK",
            targets: ["LittleSDK"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(name: "NVActivityIndicatorView", url: "https://github.com/ninjaprox/NVActivityIndicatorView.git", from: "5.0.0"),
        .package(name: "UIView-Shimmer", url: "https://github.com/omerfarukozturk/UIView-Shimmer.git", from: "1.0.0"),
        .package(name: "EasyNotificationBadge", url: "https://github.com/Minitour/EasyNotificationBadge.git", from: "1.0.0"),
        .package(name: "GoogleMaps", url: "https://github.com/YAtechnologies/GoogleMaps-SP.git", .upToNextMinor(from: "6.0.0")),
        .package(name: "Alamofire", url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.6.1")),
        .package(name: "SDWebImage", url: "https://github.com/SDWebImage/SDWebImage.git", from: "5.14.1"),
        .package(name: "IQKeyboardManagerSwift", url: "https://github.com/hackiftekhar/IQKeyboardManager", from: "6.0.5"),
        .package(name: "ESPullToRefresh", url: "https://github.com/eggswift/pull-to-refresh", from: "2.9.3"),
        .package(name: "PanModal", url: "https://github.com/slackhq/PanModal.git", from: "1.2.6"),
        .package(name: "SwiftJWT", url: "https://github.com/Kitura/Swift-JWT.git", from: "4.0.0"),
        .package(name: "RxSwift", url: "https://github.com/ReactiveX/RxSwift.git", from: "6.2.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "LittleSDK",
            dependencies: ["NVActivityIndicatorView","UIView-Shimmer","EasyNotificationBadge",.product(name: "GoogleMaps", package: "GoogleMaps"),.product(name: "GooglePlaces", package: "GoogleMaps"),"Alamofire","SDWebImage","IQKeyboardManagerSwift", "ESPullToRefresh", "PanModal", "SwiftJWT", "RxSwift", .product(name: "RxCocoa", package: "RxSwift")],
            path: "Sources/LittleSDK",
            resources: [
                .process("Resources/sparkle.wav"),
                .process("Resources/style.json"),
                .process("Resources/darkmode.json"),
                .copy("Resources/fleet.pem")
            ]),
        .testTarget(
            name: "LittleSDKTests",
            dependencies: ["LittleSDK"],
            path: "Tests/LittleSDKTests"),
    ]
)
