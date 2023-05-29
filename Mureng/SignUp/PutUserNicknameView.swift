//
//  PutUserNicknameView.swift
//  Mureng
//
//  Created by 김수현 on 2023/05/07.
//

import SwiftUI
import ComposableArchitecture

struct NicknameFactory {
    enum Result {
        case success(nickname: Nickname)
        case fail(messages: [String])
    }
    
    let nicknameViolationCases: [NicknameRuleBreakable]
    
    func make(nickname: String) async -> Result {
        var violations: [NicknameRuleBreakable] = []
        
        for violation in nicknameViolationCases {
            let result = await violation.check(nickname: nickname)
            if result == false { violations.append(violation) }
        }
        
        if violations.isEmpty {
            let nickname: Nickname = .init(value: nickname)
            return .success(nickname: nickname)
        }
        let messages = violations.map(\.message)
        return .fail(messages: messages)
    }
}

struct Nickname {
    let value: String
}

protocol NicknameRuleBreakable {
    var message: String { get }
    func check(nickname: String) async -> Bool
}

struct NicknameContainsSpecialSymbols: NicknameRuleBreakable {
    let message: String = "특수문자는 쓸 수 없어요."
    
    func check(nickname: String) async -> Bool {
        let regex = ".*[^A-Za-z0-9].*"
        let testString = NSPredicate(format:"SELF MATCHES %@", regex)
        return testString.evaluate(with: nickname)
    }
}

struct DuplicateNickname: NicknameRuleBreakable {
    let message: String = "이미 사용중인 닉네임이에요."
    
    let signUpRepository: SignUpRepository
    
    func check(nickname: String) async -> Bool {
        return await signUpRepository.requestIfNicknameIsDuplicate(nickname: nickname)
    }
}

protocol SignUpRepository {
    func requestIfNicknameIsDuplicate(nickname: String) async -> Bool
}

struct PutUserNicknameView: View {
    @State var nickname: String = ""
    @State var nextButtonDisabled: Bool = true
    
    typealias NextButtonAction = () -> Void
    private var nextButtonAction: NextButtonAction?
    
    init(nextButtonAction: NextButtonAction? = nil) {
        self.nextButtonAction = nextButtonAction
    }
    
    enum Constant {
        static let title: String = "잉크에서 사용할\n닉네임을 알려주세요."
        
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 48) {
            Text(Constant.title)
                .font(.custom(FontFamily.OmyuPretty.regular.name, size: 30))
                
            VStack(spacing: 7) {
                TextField("닉네임", text: $nickname)
                Divider()
            }
            
            Spacer()
            
            Button("다음") {
                nextButtonAction?()
            }
            .disabled(nextButtonDisabled)
            .buttonStyle(ButtonSoild48Style())
            .frame(minWidth: 0,
                   maxWidth: .infinity,
                   minHeight: 0,
                   maxHeight: 48,
                   alignment: .topLeading
            )
        }
        .edgesIgnoringSafeArea(.all)
        .padding(.init(top: 52, leading: 20, bottom: 22, trailing: 20))
    }
}

struct PutUserNicknameView_Previews: PreviewProvider {
    static var previews: some View {
        PutUserNicknameView()
    }
}
