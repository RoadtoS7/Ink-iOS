//
//  MurengToggleStyle.swift
//  Mureng
//
//  Created by 김수현 on 2023/07/09.
//

import SwiftUI

struct MurengToggle: View {
    @Binding var isOn: Bool
    let text: String
    
    var body: some View {
        Toggle(isOn: $isOn, label: {
            Text(text)
        })
        .toggleStyle(MurengToggleStyle())
    }
}

struct MurengArrowToggle: View {
    @Binding var isOn: Bool
    let text: String
    var body: some View {
        HStack {
            Toggle(isOn: $isOn, label: {
                Text(text)
            })
            .toggleStyle(MurengToggleStyle())
        }
        
    }
}

struct MurengToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {
            configuration.isOn.toggle()
        }, label: {
            HStack {
                if configuration.isOn {
                    Images.checkboxOn24.swiftUIImage
                } else {
                    Images.checkboxOff24.swiftUIImage
                }
                configuration.label
                    .foregroundColor(Colors.black.swiftUIColor)
            }
        })
    }
}

struct OnBoardingHeadline: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(FontFamily.Pretendard.regular.swiftUIFont(fixedSize: 32))
    }
}
