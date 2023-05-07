//
//  ButtonSoild48_swiftui.swift
//  Mureng
//
//  Created by 김수현 on 2023/05/07.
//

import SwiftUI

struct ButtonSoild48Style: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        return configuration.label
            .foregroundColor(.white)
            .frame(maxWidth: .infinity,
                   maxHeight: .infinity,
                   alignment: .center)
            .background(RoundedRectangle(cornerRadius: 24).fill(Color.black))
    }
}
