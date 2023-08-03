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
    static let textLimit = 10
}

struct SignUpNickNameView: View {
    private let textLimit = 10
    
    @State var nickname: String = ""
<<<<<<< HEAD
    var nextButtonDisabled: Bool {
        nickname.isEmpty || specialSymbolExisting
    }
    
    @State var alreayUsedWarning: Bool = false
    @State var specialSymbolExisting: Bool = false
    @State var navigateToNext: Bool = false
    
    let authService: AuthenticationService
    
    init(authService: AuthenticationService) {
        self.authService = authService
    }
=======
    @State var nextButtonTapped: Int?
    @State var navigationToNext: Bool = false
    
    var alreayUsedWarning: Bool = false
    var specialSymbolExisting: Bool = false
>>>>>>> bd735c1 (refactor: SignUpNicknameView - 다음 버튼을 NavigationLink가 담당하도록 수정)
    
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
            
<<<<<<< HEAD
            NavigationLink(destination: SingUpDoneView(), isActive: $navigateToNext) {
                Button("다음") {
                    Task {
                        guard let existed = await authService.isNickNameExisted(nickname) else {
                            // TODO: 다시 시도 팝업
                            return
                        }
                        alreayUsedWarning = existed
                        if existed == false {
                            navigateToNext = true
                        }
                    }
                }
                
            }
            .disabled(nextButtonDisabled)
            .frame(height: 48)
            .buttonStyle(ButtonSoild48Style())
//            NavigationLink("다음", isActive: $navigateToNext) {
//                SingUpDoneView()
//            }
//            .disabled(nextButtonDisabled)
//            .frame(height: 48)
//            .buttonStyle(ButtonSoild48Style())
=======
            NavigationLink("다음",
                           destination: {
                SingUpDoneView()
            })
            .disabled(nickname.isEmpty)
            .frame(height: 48)
            .buttonStyle(ButtonSoild48Style())
>>>>>>> bd735c1 (refactor: SignUpNicknameView - 다음 버튼을 NavigationLink가 담당하도록 수정)
        }
        .padding(.horizontal, 20)
        .navigationBarHidden(true)
    }
    
    private func limitText(_ upper: Int) {
        if nickname.count > upper {
            nickname = String(nickname.prefix(upper))
        }
    }
}

struct SignUpNickNameView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpNickNameView(authService: DummySuccessAuthService())
    }
}
