// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "PagoContacts",
  platforms: [.iOS("17")],
  products: [
    .library(
      name: "Presentation",
      targets: ["Presentation"]
    ),
    .library(
      name: "Domain",
      targets: ["Domain"]
    ),
    .library(
      name: "Data",
      targets: ["Data"]
    )
  ],
  targets: [
    .target(
      name: "Presentation",
      dependencies: ["Domain"]
    ),
    .target(
      name: "Domain"
    ),
    .target(
      name: "Data",
      dependencies: ["Domain"]
    ),
    .testTarget(
      name: "DataTests",
      dependencies: ["Data"]),
    .testTarget(
      name: "PresentationTests",
      dependencies: ["Presentation"])
  ]
)
