// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif
#if canImport(SwiftUI)
  import SwiftUI
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ColorAsset.Color", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetColorTypeAlias = ColorAsset.Color

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Colors {
  internal enum Basic {
    internal static let _30Dim = ColorAsset(name: "30-dim")
    internal static let caution = ColorAsset(name: "caution")
  }
  internal static let black = ColorAsset(name: "black")
  internal enum DiaryBackground {
    internal static let empty = ColorAsset(name: "empty")
  }
  internal static let diaryContent = ColorAsset(name: "diary-content")
  internal enum Grey {
    internal static let dark1 = ColorAsset(name: "dark-1")
    internal static let dark2 = ColorAsset(name: "dark-2")
    internal static let grey1Disabled1 = ColorAsset(name: "grey-1-disabled1")
    internal static let grey2Default1 = ColorAsset(name: "grey2-default1")
    internal static let greylight0 = ColorAsset(name: "greylight0")
    internal static let light2Placeholder = ColorAsset(name: "light2-placeholder")
    internal static let light3Bg = ColorAsset(name: "light3-bg")
    internal static let lightest1Bg1 = ColorAsset(name: "lightest-1-bg1")
  }
  internal enum Greyscale {
    internal static let greyscale100 = ColorAsset(name: "greyscale-100")
    internal static let greyscale1000 = ColorAsset(name: "greyscale-1000")
    internal static let greyscale200 = ColorAsset(name: "greyscale-200")
    internal static let greyscale300 = ColorAsset(name: "greyscale-300")
    internal static let greyscale400 = ColorAsset(name: "greyscale-400")
    internal static let greyscale50 = ColorAsset(name: "greyscale-50")
    internal static let greyscale500 = ColorAsset(name: "greyscale-500")
    internal static let greyscale600 = ColorAsset(name: "greyscale-600")
    internal static let greyscale700 = ColorAsset(name: "greyscale-700")
    internal static let greyscale800 = ColorAsset(name: "greyscale-800")
  }
  internal static let lightest2Bg2 = ColorAsset(name: "lightest-2-bg2")
  internal static let lightestBg3 = ColorAsset(name: "lightestBg3")
  internal enum Neutral {
    internal enum Container {
      internal static let primary = ColorAsset(name: "primary")
      internal static let secondary = ColorAsset(name: "secondary")
    }
    internal enum Label {
      internal static let quaternary = ColorAsset(name: "quaternary")
      internal static let secondary = ColorAsset(name: "secondary")
      internal static let tertiary = ColorAsset(name: "tertiary")
    }
    internal enum Surface {
      internal static let secondary = ColorAsset(name: "secondary")
      internal static let tertiary = ColorAsset(name: "tertiary")
    }
  }
  internal static let white = ColorAsset(name: "white")
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal final class ColorAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Color = NSColor
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Color = UIColor
  #endif

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  internal private(set) lazy var color: Color = {
    guard let color = Color(asset: self) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }()

  #if os(iOS) || os(tvOS)
  @available(iOS 11.0, tvOS 11.0, *)
  internal func color(compatibleWith traitCollection: UITraitCollection) -> Color {
    let bundle = BundleToken.bundle
    guard let color = Color(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }
  #endif

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  internal private(set) lazy var swiftUIColor: SwiftUI.Color = {
    SwiftUI.Color(asset: self)
  }()
  #endif

  fileprivate init(name: String) {
    self.name = name
  }
}

internal extension ColorAsset.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init?(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
internal extension SwiftUI.Color {
  init(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle)
  }
}
#endif

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
