// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "opentelemetry-swift",
    platforms: [
        .macOS(.v10_13),
        .iOS(.v11),
        .tvOS(.v11)
    ],
    products: [
        .library(name: "OpenTelemetrySdk", type: .static, targets: ["OpenTelemetrySdk"]),
        .library(name: "ResourceExtension", type: .static, targets: ["ResourceExtension"]),
        .library(name: "URLSessionInstrumentation", type: .static, targets: ["URLSessionInstrumentation"]),
        .library(name: "SignPostIntegration", type: .static, targets: ["SignPostIntegration"]),
        .library(name: "OpenTracingShim-experimental", type: .static, targets: ["OpenTracingShim"]),
        .library(name: "SwiftMetricsShim", type: .static, targets: ["SwiftMetricsShim"]),
        .library(name: "JaegerExporter", type: .static, targets: ["JaegerExporter"]),
        .library(name: "ZipkinExporter", type: .static, targets: ["ZipkinExporter"]),
        .library(name: "StdoutExporter", type: .static, targets: ["StdoutExporter"]),
        .library(name: "PrometheusExporter", type: .static, targets: ["PrometheusExporter"]),
        .library(name: "OpenTelemetryProtocolExporter", type: .static, targets: ["OpenTelemetryProtocolExporterGrpc"]),
        .library(name: "OpenTelemetryProtocolExporterHTTP", type: .static, targets: ["OpenTelemetryProtocolExporterHttp"]),
        .library(name: "PersistenceExporter", type: .static, targets: ["PersistenceExporter"]),
        .library(name: "InMemoryExporter", type: .static, targets: ["InMemoryExporter"]),
        .library(name: "DatadogExporter", type: .static, targets: ["DatadogExporter"]),
        .library(name: "NetworkStatus", type: .static, targets: ["NetworkStatus"]),
        .executable(name: "simpleExporter", targets: ["SimpleExporter"]),
        .executable(name: "OTLPExporter", targets: ["OTLPExporter"]),
        .executable(name: "OTLPHTTPExporter", targets: ["OTLPHTTPExporter"]),
        .executable(name: "loggingTracer", targets: ["LoggingTracer"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ganeshnj/opentelemetry-swift-api.git", branch: "main"),
        .package(name: "Opentracing", url: "https://github.com/undefinedlabs/opentracing-objc", exact: "0.5.2"),
        .package(name: "Thrift", url: "https://github.com/undefinedlabs/Thrift-Swift", exact: "1.1.1"),
        .package(name: "swift-nio", url: "https://github.com/apple/swift-nio.git", exact: "2.0.0"),
        .package(name: "grpc-swift", url: "https://github.com/grpc/grpc-swift.git", exact: "1.0.0"),
        .package(name: "swift-protobuf", url: "https://github.com/apple/swift-protobuf.git", exact: "1.20.2"),
        .package(name: "swift-log", url: "https://github.com/apple/swift-log.git", exact: "1.4.4"),
        .package(name: "swift-metrics", url: "https://github.com/apple/swift-metrics.git", exact: "2.1.1"),
        .package(name: "Reachability.swift", url: "https://github.com/ashleymills/Reachability.swift", exact: "5.1.0")
    ],
    targets: [
        .target(name: "OpenTelemetrySdk",
                dependencies: ["OpenTelemetryApi"]),
        .target(name: "ResourceExtension",
                dependencies: ["OpenTelemetrySdk"],
                path: "Sources/Instrumentation/SDKResourceExtension",
                exclude: ["README.md"]),
        .target(name: "URLSessionInstrumentation",
                dependencies: ["OpenTelemetrySdk", "NetworkStatus"],
                path: "Sources/Instrumentation/URLSession",
                exclude: ["README.md"]),
        .target(name: "NetworkStatus",
                dependencies: [
                    .product(name: "OpenTelemetryApi", package: "opentelemetry-swift-api"),
                    .product(name: "Reachability", package: "Reachability.swift")
                ],
                path: "Sources/Instrumentation/NetworkStatus",
                linkerSettings: [.linkedFramework("CoreTelephony", .when(platforms: [.iOS], configuration: nil))]),
        .target(name: "SignPostIntegration",
                dependencies: ["OpenTelemetrySdk"],
                path: "Sources/Instrumentation/SignPostIntegration",
                exclude: ["README.md"]),
        .target(name: "OpenTracingShim",
                dependencies: ["OpenTelemetrySdk",
                               "Opentracing"],
                path: "Sources/Importers/OpenTracingShim",
                exclude: ["README.md"]),
        .target(name: "SwiftMetricsShim",
                dependencies: ["OpenTelemetrySdk",
                               .product(name: "CoreMetrics", package: "swift-metrics")],
                path: "Sources/Importers/SwiftMetricsShim",
                exclude: ["README.md"]),
        .target(name: "JaegerExporter",
                dependencies: ["OpenTelemetrySdk",
                               .product(name: "Thrift", package: "Thrift")],
                path: "Sources/Exporters/Jaeger"),
        .target(name: "ZipkinExporter",
                dependencies: ["OpenTelemetrySdk"],
                path: "Sources/Exporters/Zipkin"),
        .target(name: "PrometheusExporter",
                dependencies: ["OpenTelemetrySdk",
                               .product(name: "NIO", package: "swift-nio"),
                               .product(name: "NIOHTTP1", package: "swift-nio")],
                path: "Sources/Exporters/Prometheus"),
        .target(name: "OpenTelemetryProtocolExporterCommon",
                dependencies: ["OpenTelemetrySdk",
                               .product(name: "Logging", package: "swift-log"),
                               .product(name: "SwiftProtobuf", package: "swift-protobuf")],
                path: "Sources/Exporters/OpenTelemetryProtocolCommon"),
        .target(name: "OpenTelemetryProtocolExporterHttp",
                dependencies: ["OpenTelemetrySdk",
                               "OpenTelemetryProtocolExporterCommon"],
                path: "Sources/Exporters/OpenTelemetryProtocolHttp"),
        .target(name: "OpenTelemetryProtocolExporterGrpc",
                dependencies: ["OpenTelemetrySdk",
                               "OpenTelemetryProtocolExporterCommon",
                               .product(name: "GRPC", package: "grpc-swift")],
                path: "Sources/Exporters/OpenTelemetryProtocolGrpc"),
        .target(name: "StdoutExporter",
                dependencies: ["OpenTelemetrySdk"],
                path: "Sources/Exporters/Stdout"),
        .target(name: "InMemoryExporter",
                dependencies: ["OpenTelemetrySdk"],
                path: "Sources/Exporters/InMemory"),
        .target(name: "DatadogExporter",
                dependencies: ["OpenTelemetrySdk"],
                path: "Sources/Exporters/DatadogExporter",
                exclude: ["NOTICE", "README.md"]),
        .target(name: "PersistenceExporter",
                dependencies: ["OpenTelemetrySdk"],
                path: "Sources/Exporters/Persistence"),
        .testTarget(name: "NetworkStatusTests",
                    dependencies: ["NetworkStatus", .product(name: "Reachability", package: "Reachability.swift")],
                    path: "Tests/InstrumentationTests/NetworkStatusTests"),
        .testTarget(name: "OpenTelemetrySdkTests",
                    dependencies: [
                        .product(name: "OpenTelemetryApi", package: "opentelemetry-swift-api"),
                        "OpenTelemetrySdk"
                    ],
                    path: "Tests/OpenTelemetrySdkTests"),
        .testTarget(name: "ResourceExtensionTests",
                    dependencies: ["ResourceExtension", "OpenTelemetrySdk"],
                    path: "Tests/InstrumentationTests/SDKResourceExtensionTests"),
        .testTarget(name: "URLSessionInstrumentationTests",
                    dependencies: ["URLSessionInstrumentation",
                                   .product(name: "NIO", package: "swift-nio"),
                                   .product(name: "NIOHTTP1", package: "swift-nio")],
                    path: "Tests/InstrumentationTests/URLSessionTests"),
        .testTarget(name: "OpenTracingShimTests",
                    dependencies: ["OpenTracingShim",
                                   "OpenTelemetrySdk"],
                    path: "Tests/ImportersTests/OpenTracingShim"),
        .testTarget(name: "SwiftMetricsShimTests",
                    dependencies: ["SwiftMetricsShim",
                                   "OpenTelemetrySdk"],
                    path: "Tests/ImportersTests/SwiftMetricsShim"),
        .testTarget(name: "JaegerExporterTests",
                    dependencies: ["JaegerExporter"],
                    path: "Tests/ExportersTests/Jaeger"),
        .testTarget(name: "ZipkinExporterTests",
                    dependencies: ["ZipkinExporter"],
                    path: "Tests/ExportersTests/Zipkin"),
        .testTarget(name: "PrometheusExporterTests",
                    dependencies: ["PrometheusExporter"],
                    path: "Tests/ExportersTests/Prometheus"),
        .testTarget(name: "OpenTelemetryProtocolExporterTests",
                    dependencies: ["OpenTelemetryProtocolExporterGrpc",
                                   "OpenTelemetryProtocolExporterHttp",
                                   .product(name: "NIO", package: "swift-nio"),
                                   .product(name: "NIOHTTP1", package: "swift-nio"),
                                   .product(name: "NIOTestUtils", package: "swift-nio")],
                    path: "Tests/ExportersTests/OpenTelemetryProtocol"),
        .testTarget(name: "InMemoryExporterTests",
                    dependencies: ["InMemoryExporter"],
                    path: "Tests/ExportersTests/InMemory"),
        .testTarget(name: "DatadogExporterTests",
                    dependencies: ["DatadogExporter",
                                   .product(name: "NIO", package: "swift-nio"),
                                   .product(name: "NIOHTTP1", package: "swift-nio")],
                    path: "Tests/ExportersTests/DatadogExporter"),
        .testTarget(name: "PersistenceExporterTests",
                    dependencies: ["PersistenceExporter"],
                    path: "Tests/ExportersTests/PersistenceExporter"),
        .target(name: "LoggingTracer",
                dependencies: [
                    .product(name: "OpenTelemetryApi", package: "opentelemetry-swift-api"),
                ],
                path: "Examples/Logging Tracer"),
        .target(name: "SimpleExporter",
                dependencies: ["OpenTelemetrySdk", "JaegerExporter", "StdoutExporter", "ZipkinExporter", "ResourceExtension", "SignPostIntegration"],
                path: "Examples/Simple Exporter",
                exclude: ["README.md"]),
        .target(name: "OTLPExporter",
                dependencies: ["OpenTelemetrySdk", "OpenTelemetryProtocolExporterGrpc", "StdoutExporter", "ZipkinExporter", "ResourceExtension", "SignPostIntegration"],
                path: "Examples/OTLP Exporter",
                exclude: ["README.md"]),
        .target(name: "OTLPHTTPExporter",
                dependencies: ["OpenTelemetrySdk", "OpenTelemetryProtocolExporterHttp", "StdoutExporter", "ZipkinExporter", "ResourceExtension", "SignPostIntegration"],
                path: "Examples/OTLP HTTP Exporter",
                exclude: ["README.md"]),
        .target(name: "PrometheusSample",
                dependencies: ["OpenTelemetrySdk", "PrometheusExporter"],
                path: "Examples/Prometheus Sample",
                exclude: ["README.md"]),
        .target(name: "DatadogSample",
                dependencies: ["DatadogExporter"],
                path: "Examples/Datadog Sample",
                exclude: ["README.md"]),
        .target(name: "StableMetricSample",
                dependencies: [
                    "OpenTelemetrySdk",
                    .product(name: "OpenTelemetryApi", package: "opentelemetry-swift-api"),
                    "OpenTelemetryProtocolExporter", .product(name: "GRPC", package:  "grpc-swift")
                ],
                path: "Examples/Stable Metric Sample",
                exclude: ["README.md"]),
        .target(name: "NetworkSample",
                dependencies: ["URLSessionInstrumentation", "StdoutExporter"],
                path: "Examples/Network Sample",
                exclude: ["README.md"]),
    ]
)
