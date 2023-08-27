//
//  NicknameWarningTextStyle.swift
//  Mureng
//
//  Created by 김수현 on 2023/08/06.
//

import SwiftUI

struct NicknameWarningTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.custom(FontFamily.AppleSDGothicNeo.regular, size: 12))
            .foregroundColor(Colors.Basic.caution.swiftUIColor)
            
    }
}
