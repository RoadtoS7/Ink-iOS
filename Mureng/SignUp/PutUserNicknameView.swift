//
//  PutUserNicknameView.swift
//  Mureng
//
//  Created by 김수현 on 2023/05/07.
//

import SwiftUI
import ComposableArchitecture

struct NicknameChecker: ReducerProtocol {
    struct State: Equatable {
        @BindingState var nickname: String = ""
    }
    
    enum Field: String, Hashable {
      case nickname
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case nextButtonTapped
    }
    
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .nextButtonTapped:
                return .none
//                return .task {
//                    // TODO: 닉네임 중복체크 서버 통신
//                }
            }
            
        }
    }
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
