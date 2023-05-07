// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit.NSFont
#elseif os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIFont
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "FontConvertible.Font", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias Font = FontConvertible.Font

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

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
  internal enum LeeSeoyun {
    internal static let regular = FontConvertible(name: "LeeSeoyun", family: "LeeSeoyun", path: "LeeSeoyun.otf")
    internal static let all: [FontConvertible] = [regular]
  }
  internal enum OmyuPretty {
    internal static let regular = FontConvertible(name: "omyu_pretty", family: "omyu pretty", path: "oyun.ttf")
    internal static let all: [FontConvertible] = [regular]
  }
  internal static let allCustomFonts: [FontConvertible] = [AppleSDGothicNeoI.all, AppleSDGothicNeo.all, LeeSeoyun.all, OmyuPretty.all].flatMap { $0 }
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

  internal func register() {
    // swiftlint:disable:next conditional_returns_on_newline
    guard let url = url else { return }
    CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
  }

  fileprivate var url: URL? {
    // swiftlint:disable:next implicit_return
    return BundleToken.bundle.url(forResource: path, withExtension: nil)
  }
}

internal extension FontConvertible.Font {
  convenience init?(font: FontConvertible, size: CGFloat) {
    #if os(iOS) || os(tvOS) || os(watchOS)
    if !UIFont.fontNames(forFamilyName: font.family).contains(font.name) {
      font.register()
    }
    #elseif os(macOS)
    if let url = font.url, CTFontManagerGetScopeForURL(url as CFURL) == .none {
      font.register()
    }
    #endif

    self.init(name: font.name, size: size)
  }
}

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
