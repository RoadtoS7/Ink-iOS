// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit.NSFont
#elseif os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIFont
#endif
#if canImport(SwiftUI)
  import SwiftUI
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "FontConvertible.Font", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias Font = FontConvertible.Font

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Fonts

// swiftlint:disable identifier_name line_length type_body_length
internal enum FontFamily {
  internal enum AppleSDGothicNeoI {
    internal static let bold = FontConvertible(name: ".AppleSDGothicNeoI-Bold", family: ".Apple SD Gothic NeoI", path: "AppleSDGothicNeo.ttc")
    internal static let extraBold = FontConvertible(name: ".AppleSDGothicNeoI-ExtraBold", family: ".Apple SD Gothic NeoI", path: "AppleSDGothicNeo.ttc")
    internal static let heavy = FontConvertible(name: ".AppleSDGothicNeoI-Heavy", family: ".Apple SD Gothic NeoI", path: "AppleSDGothicNeo.ttc")
    internal static let light = FontConvertible(name: ".AppleSDGothicNeoI-Light", family: ".Apple SD Gothic NeoI", path: "AppleSDGothicNeo.ttc")
    internal static let medium = FontConvertible(name: ".AppleSDGothicNeoI-Medium", family: ".Apple SD Gothic NeoI", path: "AppleSDGothicNeo.ttc")
    internal static let regular = FontConvertible(name: ".AppleSDGothicNeoI-Regular", family: ".Apple SD Gothic NeoI", path: "AppleSDGothicNeo.ttc")
    internal static let semiBold = FontConvertible(name: ".AppleSDGothicNeoI-SemiBold", family: ".Apple SD Gothic NeoI", path: "AppleSDGothicNeo.ttc")
    internal static let thin = FontConvertible(name: ".AppleSDGothicNeoI-Thin", family: ".Apple SD Gothic NeoI", path: "AppleSDGothicNeo.ttc")
    internal static let ultraLight = FontConvertible(name: ".AppleSDGothicNeoI-UltraLight", family: ".Apple SD Gothic NeoI", path: "AppleSDGothicNeo.ttc")
    internal static let all: [FontConvertible] = [bold, extraBold, heavy, light, medium, regular, semiBold, thin, ultraLight]
  }
  internal enum AppleSDGothicNeo {
    internal static let bold = FontConvertible(name: "AppleSDGothicNeo-Bold", family: "Apple SD Gothic Neo", path: "AppleSDGothicNeo.ttc")
    internal static let extraBold = FontConvertible(name: "AppleSDGothicNeo-ExtraBold", family: "Apple SD Gothic Neo", path: "AppleSDGothicNeo.ttc")
    internal static let heavy = FontConvertible(name: "AppleSDGothicNeo-Heavy", family: "Apple SD Gothic Neo", path: "AppleSDGothicNeo.ttc")
    internal static let light = FontConvertible(name: "AppleSDGothicNeo-Light", family: "Apple SD Gothic Neo", path: "AppleSDGothicNeo.ttc")
    internal static let medium = FontConvertible(name: "AppleSDGothicNeo-Medium", family: "Apple SD Gothic Neo", path: "AppleSDGothicNeo.ttc")
    internal static let regular = FontConvertible(name: "AppleSDGothicNeo-Regular", family: "Apple SD Gothic Neo", path: "AppleSDGothicNeo.ttc")
    internal static let semiBold = FontConvertible(name: "AppleSDGothicNeo-SemiBold", family: "Apple SD Gothic Neo", path: "AppleSDGothicNeo.ttc")
    internal static let thin = FontConvertible(name: "AppleSDGothicNeo-Thin", family: "Apple SD Gothic Neo", path: "AppleSDGothicNeo.ttc")
    internal static let ultraLight = FontConvertible(name: "AppleSDGothicNeo-UltraLight", family: "Apple SD Gothic Neo", path: "AppleSDGothicNeo.ttc")
    internal static let all: [FontConvertible] = [bold, extraBold, heavy, light, medium, regular, semiBold, thin, ultraLight]
  }
  internal enum NanumMyeongjo {
    internal static let regular = FontConvertible(name: "NanumMyeongjo", family: "NanumMyeongjo", path: "NanumMyeongjo-Regular.ttf")
    internal static let bold = FontConvertible(name: "NanumMyeongjoBold", family: "NanumMyeongjo", path: "NanumMyeongjo-Bold.ttf")
    internal static let extraBold = FontConvertible(name: "NanumMyeongjoExtraBold", family: "NanumMyeongjo", path: "NanumMyeongjo-ExtraBold.ttf")
    internal static let all: [FontConvertible] = [regular, bold, extraBold]
  }
  internal enum Pretendard {
    internal static let black = FontConvertible(name: "Pretendard-Black", family: "Pretendard", path: "Pretendard-Black.otf")
    internal static let bold = FontConvertible(name: "Pretendard-Bold", family: "Pretendard", path: "Pretendard-Bold.otf")
    internal static let extraBold = FontConvertible(name: "Pretendard-ExtraBold", family: "Pretendard", path: "Pretendard-ExtraBold.otf")
    internal static let extraLight = FontConvertible(name: "Pretendard-ExtraLight", family: "Pretendard", path: "Pretendard-ExtraLight.otf")
    internal static let light = FontConvertible(name: "Pretendard-Light", family: "Pretendard", path: "Pretendard-Light.otf")
    internal static let medium = FontConvertible(name: "Pretendard-Medium", family: "Pretendard", path: "Pretendard-Medium.otf")
    internal static let regular = FontConvertible(name: "Pretendard-Regular", family: "Pretendard", path: "Pretendard-Regular.otf")
    internal static let semiBold = FontConvertible(name: "Pretendard-SemiBold", family: "Pretendard", path: "Pretendard-SemiBold.otf")
    internal static let thin = FontConvertible(name: "Pretendard-Thin", family: "Pretendard", path: "Pretendard-Thin.otf")
    internal static let all: [FontConvertible] = [black, bold, extraBold, extraLight, light, medium, regular, semiBold, thin]
  }
  internal static let allCustomFonts: [FontConvertible] = [AppleSDGothicNeoI.all, AppleSDGothicNeo.all, NanumMyeongjo.all, Pretendard.all].flatMap { $0 }
  internal static func registerAllCustomFonts() {
    allCustomFonts.forEach { $0.register() }
  }
}
// swiftlint:enable identifier_name line_length type_body_length

// MARK: - Implementation Details

internal struct FontConvertible {
  internal let name: String
  internal let family: String
  internal let path: String

  #if os(macOS)
  internal typealias Font = NSFont
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Font = UIFont
  #endif

  internal func font(size: CGFloat) -> Font {
    guard let font = Font(font: self, size: size) else {
      fatalError("Unable to initialize font '\(name)' (\(family))")
    }
    return font
  }

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  internal func swiftUIFont(size: CGFloat) -> SwiftUI.Font {
    return SwiftUI.Font.custom(self, size: size)
  }

  @available(iOS 14.0, tvOS 14.0, watchOS 7.0, macOS 11.0, *)
  internal func swiftUIFont(fixedSize: CGFloat) -> SwiftUI.Font {
    return SwiftUI.Font.custom(self, fixedSize: fixedSize)
  }

  @available(iOS 14.0, tvOS 14.0, watchOS 7.0, macOS 11.0, *)
  internal func swiftUIFont(size: CGFloat, relativeTo textStyle: SwiftUI.Font.TextStyle) -> SwiftUI.Font {
    return SwiftUI.Font.custom(self, size: size, relativeTo: textStyle)
  }
  #endif

  internal func register() {
    // swiftlint:disable:next conditional_returns_on_newline
    guard let url = url else { return }
    CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
  }

  fileprivate func registerIfNeeded() {
    #if os(iOS) || os(tvOS) || os(watchOS)
    if !UIFont.fontNames(forFamilyName: family).contains(name) {
      register()
    }
    #elseif os(macOS)
    if let url = url, CTFontManagerGetScopeForURL(url as CFURL) == .none {
      register()
    }
    #endif
  }

  fileprivate var url: URL? {
    // swiftlint:disable:next implicit_return
    return BundleToken.bundle.url(forResource: path, withExtension: nil)
  }
}

internal extension FontConvertible.Font {
  convenience init?(font: FontConvertible, size: CGFloat) {
    font.registerIfNeeded()
    self.init(name: font.name, size: size)
  }
}

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
internal extension SwiftUI.Font {
  static func custom(_ font: FontConvertible, size: CGFloat) -> SwiftUI.Font {
    font.registerIfNeeded()
    return custom(font.name, size: size)
  }
}

@available(iOS 14.0, tvOS 14.0, watchOS 7.0, macOS 11.0, *)
internal extension SwiftUI.Font {
  static func custom(_ font: FontConvertible, fixedSize: CGFloat) -> SwiftUI.Font {
    font.registerIfNeeded()
    return custom(font.name, fixedSize: fixedSize)
  }

  static func custom(
    _ font: FontConvertible,
    size: CGFloat,
    relativeTo textStyle: SwiftUI.Font.TextStyle
  ) -> SwiftUI.Font {
    font.registerIfNeeded()
    return custom(font.name, size: size, relativeTo: textStyle)
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
