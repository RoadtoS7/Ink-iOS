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
}
