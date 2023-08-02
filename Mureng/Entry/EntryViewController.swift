//
//  SplashViewController.swift
//  Mureng
//
//  Created by nylah.j on 2022/06/13.
//

import UIKit
import KakaoSDKAuth
import KakaoSDKUser
import SwiftUI

enum AutServiceLoginResult {
    case success(AuthServiceUser)
    case fail
}

protocol AuthenticationService {
    func login() async -> AutServiceLoginResult
}

final class DummySuccessAuthService: AuthenticationService {
    let authServiceUser: AuthServiceUser
    
    init(authServiceUser: AuthServiceUser) {
        self.authServiceUser = authServiceUser
    }
    
    convenience init() {
        let authService = AuthServiceUser(id: "dummy_id", email: "dummy_email", nickname: "dummy_nickname")
        self.init(authServiceUser: authService)
    }
    
    func login() -> AutServiceLoginResult {
        .success(authServiceUser)
    }
     
    func userInfo() -> AuthServiceUser? {
        nil
    }
}


final class DefaultAuthService: AuthenticationService {
    func login() async -> AutServiceLoginResult {
        let oauthToken: OAuthToken? = await getOauthToken()
        guard let oauthToken = oauthToken else {
            return .fail
        }
        
        let user: User? = try? await getUserInfo()
        guard let user = user else {
            return .fail
        }
        
        let accessToken = oauthToken.accessToken
        let id = String(describing: user.id)
        
        guard let nickname = user.kakaoAccount?.profile?.nickname else {
            APILogger.logError(InkError.unknownError("kakaologin didn't return"))
            return .fail
        }
        
        guard let email = user.kakaoAccount?.email else {
            APILogger.logError(InkError.unknownError("kakaologin didn't return email"))
            return .fail
        }
        
        let authServiceUser: AuthServiceUser = .init(id: id, email: email, nickname: nickname)
        return .success(authServiceUser)
    }
    
    private func getOauthToken() async -> OAuthToken? {
        if UserApi.isKakaoTalkLoginAvailable() {
            do {
                let oauthToken: OAuthToken = try await loginAtKakaoApp()
                return oauthToken
            } catch {
                APILogger.logError(error)
                return nil
            }
        }
        
        do {
            let oauthToken: OAuthToken = try await loginAtKakaoWeb()
            return oauthToken
        } catch {
            APILogger.logError(error)
            return nil
        }
    }
    
    private func loginAtKakaoApp() async throws -> OAuthToken {
        try await withCheckedThrowingContinuation({ continuation in
            UserApi.shared.loginWithKakaoTalk { token, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                if let token = token {
                    continuation.resume(returning: token)
                    return
                }
                
                continuation.resume(throwing: InkError.unknownError("kakaologin at app "))
            }
        })
    }
    
    private func getUserInfo() async throws -> User {
        try await withCheckedThrowingContinuation({ continuation in
            UserApi.shared.me { user, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                if let user = user {
                    continuation.resume(returning: user)
                    return
                }
                
                continuation.resume(throwing: InkError.unknownError("kakaologin at web"))
            }
        })
    }
    
    private func loginAtKakaoWeb() async throws -> OAuthToken {
        try await withCheckedThrowingContinuation({ continuation in
            UserApi.shared.loginWithKakaoAccount { token, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                if let token = token {
                    continuation.resume(returning: token)
                    return
                }
                
                continuation.resume(throwing: InkError.unknownError("kakaologin at web "))
            }
        })
    }
    
    
    func userInfo() async -> UserInfoForAuth? {
        return nil
    }
}


struct EntryView: View {
    let authenticationService: AuthenticationService
    @State private var navigationToAgreement: Int?
    
    var body: some View {
        NavigationView {
            ZStack {
                Colors.black.swiftUIColor.ignoresSafeArea()
                
                VStack {
                    Spacer()
                    Images.inkIcon.swiftUIImage
                    Spacer()
                    
                    ZStack {
                        NavigationLink(destination: AgreementView(), tag: 1, selection: $navigationToAgreement) {
                            EmptyView()
                        }
                        
                        Button(action: {
                            Task {
                                let result: AutServiceLoginResult = await authenticationService.login()
                                switch result {
                                case .success:
                                    navigationToAgreement = 1
                                case .fail:
                                    return
                                    // TODO: fail 처리
                                }
                            }
                            
                        }, label: {
                            Images.kakaoLoginButton.swiftUIImage
                                .resizable()
                                .aspectRatio(343 / 48, contentMode: .fit)
                                .padding(.horizontal, 16)
                            
                        })
                    }
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            }
        }
    }
}

struct EntryNavigationView: View {
    let authenticationService: AuthenticationService
    
    var body: some View {
        NavigationView {
            EntryView(authenticationService: authenticationService)
        }
    }
}


struct KakaoLoginButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(
                Images.kakaoLoginButton.swiftUIImage
                    .resizable()
                    .aspectRatio(343 / 48, contentMode: .fit)
                    .padding(.horizontal, 16)
            )
        
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
        
        
        let agreementViewController = FullScreenHostingViewController(swiftUIView: AgreementView())
        self.navigationController?.pushViewController(agreementViewController, animated: true)
        self.dismiss(animated: false)
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

struct EntryView_Previews: PreviewProvider {
    private static let dummyService: AuthenticationService = DummySuccessAuthService()
    static var previews: some View {
        EntryView(authenticationService: dummyService)
    }
}

