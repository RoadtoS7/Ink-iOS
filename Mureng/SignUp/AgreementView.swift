//
//  AgreementView.swift
//  Mureng
//
//  Created by 김수현 on 2023/07/09.
//

import SwiftUI

extension EdgeInsets {
    init(horizontal: CGFloat) {
        self.init(top: 0, leading: horizontal, bottom: 0, trailing: horizontal)
    }
}

private enum Constant {
    static let next = "다음"
    static let headline = "먼저 이용약관을 읽고\n동의해주세요."
    static let allAgreeText = "모든 약관을 읽었으며, 이에 동의해요."
    static let serviceUsageAgreedText = "[필수] 서비스 이용약관 동의"
    static let privacyPolicyAgreed = "[필수] 개인정보 수집/이용 동의"
}

struct AgreementView: View {
    @ObservedObject var authServiceUser: AuthServiceUser

    @State private var serviceUsageAgreed: Bool = false
    @State private var privacyPolicyAgreed: Bool = false
    
    var all: Binding<Bool> {
        Binding(
            get: {
                self.serviceUsageAgreed && self.privacyPolicyAgreed
            },
            set: { value in
                self.serviceUsageAgreed = value
                self.privacyPolicyAgreed = value
            })
    }
    
    @State private var nextButtonTapped: Int? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 64) {
            OnBoardingHeadline(text: Constant.headline)
            
            VStack {
                VStack(alignment: .leading, spacing: 30) {
                    MurengToggle(isOn: all.projectedValue, text: Constant.allAgreeText)
                        .padding(.horizontal, 16)
                    
                    Rectangle()
                        .fill(Colors.lightestBg3.swiftUIColor)
                        .frame(maxWidth: .infinity, maxHeight: 1)
                    
                    MurengArrowToggle(isOn: $serviceUsageAgreed, text: Constant.serviceUsageAgreedText)
                        .padding(.horizontal, 16)
                    
                    MurengArrowToggle(isOn: $privacyPolicyAgreed, text: Constant.privacyPolicyAgreed)
                        .padding(.horizontal, 16)
                    
                }
                
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 24)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Colors.lightestBg3.swiftUIColor, lineWidth: 1)
            )
            
            Spacer()
            
            NavigationLink(
                destination: SignUpNickNameView(authService: DefaultAuthService()),
                tag: 1,
                selection: $nextButtonTapped) {
                Button("다음") {
                    nextButtonTapped = 1
                }
                .disabled(!all.wrappedValue)
                .frame(height: 48)
                .buttonStyle(ButtonSoild48Style())
            }
        }
        .padding(.horizontal, 20)
        .frame(
            minWidth: 0,
            maxWidth: .infinity,
            minHeight: 0,
            maxHeight: .infinity,
            alignment: .topLeading
        )
        .hideNavigationBar()
    }
}

struct AgreementView_Previews: PreviewProvider {
    private static let authServiceUser: AuthServiceUser = .init(identifier: "identifier", email: "email", image: "image")
    
    static var previews: some View {
        AgreementView(authServiceUser: authServiceUser)
    }
}
