//
//  SettingScreenView.swift
//  Mureng
//
//  Created by 김수현 on 7/7/24.
//

import SwiftUI

struct SettingScreenView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                SettingItemView(title: "푸시 알림")
                SettingItemView(title: "차단 사용자 관리")
                divider
                SettingItemView(title: "이용 약관")
                SettingItemView(title: "개인정보 처리방침")
                SettingItemView(title: "오픈소스 라이센스")
                divider
                SettingItemView(title: "로그아웃")
                SettingItemView(title: "회원 탈퇴")
            }
            .font(.body)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
        }
        .toolbar(content: {
            ToolbarItem(placement: .topBarLeading) {
                HStack(spacing: 4, content: {
                    backButton
                    
                    Text("설정")
                        .foregroundStyle(
                            Colors
                                .Neutral
                                .Label
                                .tertiary
                                .swiftUIColor
                        )
                        .font(.title18R)
                })
            }
        })
    }
    
    var divider: some View {
        Divider()
            .foregroundStyle(
                Colors 
                    .Greyscale
                    .greyscale200
                    .swiftUIColor
            )
    }
    
    var backButton: some View {
        Button(action: {
            dismiss()
        }, label: {
            Images.leftTouch.swiftUIImage
        })
    }
}

struct SettingItemView: View {
    let title: String
    
    var body: some View {
        Text(title)
            .foregroundStyle(
                Colors
                    .Neutral
                    .Label
                    .quaternary
                    .swiftUIColor
            )
            .font(.label16R)
            .padding(.vertical, 14.0)
    }
}

#Preview {
    NavigationView(content: {
        SettingScreenView()
    })
}
