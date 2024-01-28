//
//  Font+.swift
//  Mureng
//
//  Created by 김수현 on 1/28/24.
//

import UIKit
import SwiftUI

extension SwiftUI.Font {
    func toUIFont() -> UIFont {
        let style: UIFont.TextStyle
        switch self {
        case .largeTitle:
            style = .largeTitle
        case .title:
            style = .title1
        case .title2:
            style = .title2
        case .title3:
            style = .title3
        case .headline:
            style = .headline
        case .subheadline:
            style = .subheadline
        case .callout:
            style = .callout
        case .caption:
            style = .caption1
        case .caption2:
            style = .caption2
        case .footnote:
            style = .footnote
        default:
            style = .body
        }
        return  UIFont.preferredFont(forTextStyle: style)
    }
}
