//
//  AuthService.swift
//  Mureng
//
//  Created by nylah.j on 2023/08/02.
//

import KakaoSDKAuth
import KakaoSDKUser

enum AutServiceLoginResult {
    case success(AuthServiceUser)
    case fail
}

protocol AuthenticationService {
    func login() async -> AutServiceLoginResult
    func isNickNameExisted(_ nickname: String) async -> Bool?
}

final class DummySuccessAuthService: AuthenticationService {
    let authServiceUser: AuthServiceUser
    let nicknameExisted: Bool
    let loginResult: AutServiceLoginResult
    
    init(authServiceUser: AuthServiceUser, loginSuccess: Bool = true, nicknameExisted: Bool = false) {
        self.authServiceUser = authServiceUser
        self.nicknameExisted = nicknameExisted
        self.loginResult = loginSuccess ? .success(authServiceUser) : .fail
    }
    
    convenience init() {
        let authService = AuthServiceUser(id: "dummy_id", email: "dummy_email", nickname: "dummy_nickname")
        self.init(authServiceUser: authService)
    }
    
    func login() -> AutServiceLoginResult {
        .success(authServiceUser)
    }
    
    func isNickNameExisted(_ nickname: String) async -> Bool? {
        return nicknameExisted
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
            APILogger.shared.logError(InkError.unknownError("kakaologin didn't return"))
            return .fail
        }
        
        guard let email = user.kakaoAccount?.email else {
            APILogger.shared.logError(InkError.unknownError("kakaologin didn't return email"))
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
                APILogger.shared.logError(error)
                return nil
            }
        }
        
        do {
            let oauthToken: OAuthToken = try await loginAtKakaoWeb()
            return oauthToken
        } catch {
            APILogger.shared.logError(error)
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
    
    func isNickNameExisted(_ nickname: String) async -> Bool? {
        do {
            let response = try await MemberAuthAPI.shared.checkNicknameDuplicated(nickName: nickname)
            return response.data.duplicated
        } catch {
            APILogger.shared.logError(error)
            return nil
        }
    }
}
