// swift-tools-version:5.10
import PackageDescription

let package = Package(
	name: "pingcrm",
	platforms: [
		.macOS(.v13),
	],
	products: [
		.library(name: "Inertia", targets: ["Inertia"]),
	],
	dependencies: [
		.package(url: "https://github.com/vapor/leaf.git", from: "4.3.0"),
		.package(url: "https://github.com/vapor/vapor.git", from: "4.99.3"),
		.package(url: "https://github.com/apple/swift-nio.git", from: "2.65.0"),
		.package(url: "https://github.com/m1guelpf/ziggy-vapor.git", from: "1.0.0"),
		.package(url: "https://github.com/apple/swift-crypto.git", "1.0.0"..<"3.0.0"),
	],
	targets: [
		.target(
			name: "Inertia",
			dependencies: [
				.product(name: "Leaf", package: "leaf"),
				.product(name: "Vapor", package: "vapor"),
				.product(name: "Ziggy", package: "ziggy-vapor"),
				.product(name: "Crypto", package: "swift-crypto"),
			],
			path: "./lib",
			swiftSettings: swiftSettings
		),
		.executableTarget(
			name: "App",
			dependencies: [
				"Inertia",
				.product(name: "Leaf", package: "leaf"),
				.product(name: "Vapor", package: "vapor"),
				.product(name: "NIOCore", package: "swift-nio"),
				.product(name: "NIOPosix", package: "swift-nio"),
			],
			path: "./app",
			swiftSettings: swiftSettings
		),
	]
)

var swiftSettings: [SwiftSetting] { [
	.enableUpcomingFeature("DisableOutwardActorInference"),
	.enableExperimentalFeature("StrictConcurrency"),
] }
