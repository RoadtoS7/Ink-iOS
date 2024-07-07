//
//  SignUpNickNameView.swift
//  Mureng
//
//  Created by 김수현 on 2023/07/15.
//

import SwiftUI
import Combine

private struct Constant {
    static let headline: String = "잉크에서 사용할\n닉네임을 알려주세요."
    static let textLimit = 10
}

struct SignUpNickNameView: View {
    @ObservedObject var authServiceUser: AuthServiceUser
    @State var nickname: String = ""
    var nextButtonDisabled: Bool {
        nickname.isEmpty || specialSymbolExisting
    }
    
    @State var alreayUsedWarning: Bool = false
    @State var specialSymbolExisting: Bool = false
    @State var navigateToNext: Bool = false
    
    let authService: AuthenticationService
    
    
    init(authServiceUser: AuthServiceUser, authService: AuthenticationService) {
        self.authServiceUser = authServiceUser
        self.authService = authService
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 64) {
            OnBoardingHeadline(text: Constant.headline)
            
            VStack(alignment: .leading) {
                TextField("영어 12자/한글 6자까지 쓸 수 있어요.", text: $nickname)
                    .keyboardType(.alphabet)
                    .onReceive(Just(nickname)) { _ in
                        limitText(Constant.textLimit)
                        
                        let nonLiteralCharacterSet = CharacterSet.alphanumerics.inverted
                        specialSymbolExisting = nickname.rangeOfCharacter(from: nonLiteralCharacterSet) != nil
                    }
                
                Divider()
                    .frame(height: 1)
                    .background(Colors.lightestBg3.swiftUIColor)
                
                if alreayUsedWarning {
                    Text("이미 사용 중인 닉네임이에요!")
                        .modifier(NicknameWarningTextStyle())
                }
                
                if specialSymbolExisting {
                    Text("특수문자는 쓸 수 없어요!")
                        .modifier(NicknameWarningTextStyle())
                }
            }
            
            Spacer()
            
            Button("다음") {
                Task {
                    print("Task work")
                    guard let existed = await authService.isNickNameExisted(nickname) else {
                        // TODO: 다시 시도 팝업
                        return
                    }
                    alreayUsedWarning = existed
                    if existed == false {
                        authServiceUser.fill(nickname: nickname)
                        Task {
                            let member: Member? = await authService.signUp(authServiceUser: authServiceUser)
                            guard let member else {
                                // TODO: 다시 시도 팝업
                                return
                            }
                            let loginResult = await authService.login()
                            switch loginResult {
                            case .authenticated, loginResult:
                                navigateToNext = true
                            default:
                                // TODO: 에러 팝업
                                break
                            }
                        }
                    }
                }
            }
            .disabled(nextButtonDisabled)
            .frame(height: 48)
            .buttonStyle(ButtonSoild48Style())
            
            
            NavigationLink(destination: SingUpDoneView(), isActive: $navigateToNext) {
                
            }
            .hidden()
            
//            NavigationLink("다음", isActive: $navigateToNext) {
//                SingUpDoneView()
//            }
//            .disabled(nextButtonDisabled)
//            .frame(height: 48)
//            .buttonStyle(ButtonSoild48Style())
        }
        .padding(.horizontal, 20)
        .navigationBarHidden(true)
        .onAppear {
            print("닉네임 입력 onAppear")
        }
    }
    
    private func limitText(_ upper: Int) {
        if nickname.count > upper {
            nickname = String(nickname.prefix(upper))
        }
    }
}

struct SignUpNickNameView_Previews: PreviewProvider {
    private static let authServiceUser: AuthServiceUser = .init(identifier: "", email: "")
    static var previews: some View {
        SignUpNickNameView(authServiceUser: authServiceUser, authService: DummySuccessAuthService())
    }
}
