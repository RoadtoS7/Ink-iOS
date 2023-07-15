//
//  SignUpNickNameView.swift
//  Mureng
//
//  Created by 김수현 on 2023/07/15.
//

import SwiftUI
import Combine

fileprivate struct Constant {
    static let headline: String = "잉크에서 사용할\n닉네임을 알려주세요."
}
struct SignUpNickNameView: View {
    @State var nickname: String = ""
    @State var nextButtonTapped: Int?
    
    var alreayUsedWarning: Bool = false
    var specialSymbolExisting: Bool = false
    
    var nextButtonDisabled: Bool {
        nickname.isEmpty
    }
    let textLimit = 10
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 64) {
                OnBoardingHeadline(text: Constant.headline)
                
                VStack(alignment: .leading) {
                    TextField("영어 12자/한글 6자까지 쓸 수 있어요.", text: $nickname)
                        .keyboardType(.alphabet)
                        .onReceive(Just(nickname)) { _ in
                            limitText(textLimit)
                        }
                    
                    Divider()
                     .frame(height: 1)
                     .background(Colors.lightestBg3.swiftUIColor)
                    
                    if alreayUsedWarning {
                        Text("이미 사용 중인 닉네임이에요!")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.custom(FontFamily.AppleSDGothicNeo.regular, size: 12))
                            .foregroundColor(Colors.Basic.caution.swiftUIColor)
                    }
                    
                    if specialSymbolExisting {
                        Text("특수문자는 쓸 수 없어요!")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.custom(FontFamily.AppleSDGothicNeo.regular, size: 12))
                            .foregroundColor(Colors.Basic.caution.swiftUIColor)
                    }
                }
                
                
                Spacer()
                
                NavigationLink(destination:  SingUpDoneView(), tag: 2, selection: $nextButtonTapped) {
                    Button("다음 버튼") {
                        nextButtonTapped = 1
                    }
                    .disabled(nextButtonDisabled)
                    .frame(height: 48)
                    .buttonStyle(ButtonSoild48Style())
                }
            }
            .navigationBarHidden(true)
            .padding(.horizontal, 20)
        }
    }
    
    private func limitText(_ upper: Int) {
        if nickname.count > upper {
            nickname = String(nickname.prefix(upper))
        }
    }
}

struct SignUpNickNameView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpNickNameView()
    }
}
