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
                             ? Colors.lightestBg3.swiftUIColor
                             : Colors.black.swiftUIColor)
            .frame(maxWidth: .infinity,
                   maxHeight: .infinity,
                   alignment: .center)
            .background(
                isEnabled ? RoundedRectangle(cornerRadius: 24).fill(Color.black)
                : RoundedRectangle(cornerRadius: 24).fill(Color.white)
            )
    }
}
