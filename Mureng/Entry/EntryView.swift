//
//  EntryView.swift
//  Mureng
//
//  Created by nylah.j on 2022/06/13.
//

import UIKit
import KakaoSDKAuth
import KakaoSDKUser
import SwiftUI

struct EntryView: View {
    let authenticationService: AuthenticationService
    
    @State private var navigationToAgreement: Bool = false
    @State private var navigationToHome: Bool = false
    @State private var loginTask: Task<Void, Error>? = nil
    
    @StateObject var authServiceUser: AuthServiceUser = .init()
    
    var body: some View {
        NavigationView {
            ZStack {
                Colors.black.swiftUIColor.ignoresSafeArea()
                
                VStack {
                    Spacer()
                    Images.inkIcon.swiftUIImage
                    Spacer()
                    
                    Button(action: {
                        guard loginTask == nil else { return }
                        
                        loginTask = Task {
                            let result: AutServiceLoginResult = await authenticationService.login()
                            switch result {
                            case .signUp(let userInfo):
                                authServiceUser.fill(with: userInfo)
                                navigationToAgreement = true
                            case .fail:
                                print("$$ fail")
                                // TODO: fail 처리
                            case .authenticated:
                                print("$$ 로그인 성공")
                            }
                            
                            loginTask = nil
                        }
                    }, label: {
                        Images.kakaoLoginButton.swiftUIImage
                            .resizable()
                            .aspectRatio(343 / 48, contentMode: .fit)
                            .padding(.horizontal, 16)
                        
                    })
                    
                    NavigationLink(destination: AgreementView(authServiceUser: authServiceUser),
                                   isActive: $navigationToAgreement,
                                   label: {
                        EmptyView()
                    }).hidden()
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .onDisappear {
                    loginTask?.cancel()
                }
            }
        }
    }
}

struct KakaoLoginButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .overlay(Images.kakaoLoginButton.swiftUIImage)
            .aspectRatio(343 / 48, contentMode: .fit)
            .padding(.horizontal, 16)
    }
}

class EntryViewController: UIViewController {
    private var loginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        loginButton.addTarget(self, action: #selector(navigateToLoginProcess), for: .touchUpInside)
    }
    
    @objc func navigateToLoginProcess() {
        // 카카오톡 실행 가능 여부 확인
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                } else {
                    print("loginWithKakaoTalk() success.")
                    
                    // do something
                    _ = oauthToken
                    print("$$ oauthToken: ", oauthToken)
                    
                    UserApi.shared.me() {(user, error) in
                        if let error = error {
                            print(error)
                        }
                        else {
                            print("me() success.")
                            
                            //do something
                            print("$$ user: ", user)
                            _ = user
                        }
                    }
                }
            }
            return
        }
        
        UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
            if let error = error {
                print(error)
            } else {
                print("loginWithKakaoAccount() success.")
                oauthToken?.accessToken
                
                // do something
                _ = oauthToken
            }
        }
        return
        
        
    }
}

extension EntryViewController {
    private func initViews() {
        let murengIcon: UIImageView = .init(image: Images.inkIcon.image)
        murengIcon.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(murengIcon)
        NSLayoutConstraint.activate([
            murengIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            murengIcon.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        // MARK: LoginButton
        let loginButton: UIButton = .init()
        loginButton.setImage(Images.kakaoLoginButton.image, for: .normal)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginButton)
        loginButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.width.equalTo(loginButton.snp.height).multipliedBy(343 / 48)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
        }
        self.loginButton = loginButton
    }
}

//struct EntryView_Previews: PreviewProvider {
//    static let dummyService: AuthenticationService = DummySuccessAuthService()
//
//    static var previews: some View {
//        EntryView(authenticationService: dummyService)
//
//}
