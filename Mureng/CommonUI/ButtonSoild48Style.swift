//
//  ButtonSoild48_swiftui.swift
//  Mureng
//
//  Created by 김수현 on 2023/05/07.
//

import SwiftUI

struct ButtonSoild48Style: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        return configuration.label
            .foregroundColor(isEnabled
                             ? Colors.white.swiftUIColor
                             : Colors.Grey.grey1Disabled1.swiftUIColor)
            .frame(maxWidth: .infinity,
                   maxHeight: .infinity,
                   alignment: .center
            )
            .background(isEnabled
                        ? RoundedRectangle(cornerRadius: 24).fill(Colors.black.swiftUIColor)
                        : RoundedRectangle(cornerRadius: 24).fill(Colors.Grey.greylight0.swiftUIColor)
            )
    }
}
