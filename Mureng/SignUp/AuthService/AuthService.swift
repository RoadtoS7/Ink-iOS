//
//  AuthService.swift
//  Mureng
//
//  Created by nylah.j on 2023/08/02.
//

import KakaoSDKAuth
import KakaoSDKUser
import KakaoSDKCommon

enum AuthServiceError: Error {
    /// 로그인 필요
    case loginRequired
    /// 알수없는 에러
    case unknown
    ///
}

enum AuthServiceLoginResult: Equatable {
    /// 이미 회원가입한 유저
    case authenticated
    /// 회원가입 성공한 유저
    case needSignUp(AuthServiceUser)
    /// 로그인 실패
    case fail
    
    static func == (lhs: AuthServiceLoginResult, rhs: AuthServiceLoginResult) -> Bool {
        switch (lhs, rhs) {
        case (.authenticated, .authenticated): return true
        case (.needSignUp(let lshUser), .needSignUp(let rhsUser)): return lshUser == rhsUser
        case (.fail, .fail): return true
        default: return false
        }
    }
}

protocol AuthenticationService {
    func tryLogin() async -> AuthServiceLoginResult
    func loginInkServer() async -> AuthServiceLoginResult
    func isNickNameExisted(_ nickname: String) async -> Bool?
    func signUp(authServiceUser: AuthServiceUser) async -> Member?
}

final class DummySuccessAuthService: AuthenticationService {
    func signUp(authServiceUser: AuthServiceUser) async -> Member? {
        let memberSetting: MemberSetting = .init(dailyPushActive: true,
                                                 likePushActive: true)
        return .init(id: 0, identifier: "identifier", nickname: "nickname", image: "imagew", inkCount: 0, attendanceCount: 0, lastAttendanceDate: .init(), memberSetting: memberSetting)
    }
    
    let authServiceUser: AuthServiceUser
    let nicknameExisted: Bool
    let loginResult: AuthServiceLoginResult
    
    init(authServiceUser: AuthServiceUser, loginSuccess: Bool = true, nicknameExisted: Bool = false) {
        self.authServiceUser = authServiceUser
        self.nicknameExisted = nicknameExisted
        self.loginResult = loginSuccess ? .needSignUp(authServiceUser) : .fail
    }
    
    convenience init() {
        let authService = AuthServiceUser(identifier: "dummy_id", email: "dummy_email", image: "dummy_nickname")
        self.init(authServiceUser: authService)
    }
    
    func tryLogin() -> AuthServiceLoginResult {
        .needSignUp(authServiceUser)
    }
    
    func loginInkServer() async -> AuthServiceLoginResult {
        .authenticated
    }
    
    func isNickNameExisted(_ nickname: String) async -> Bool? {
        return nicknameExisted
    }
}

final class DefaultAuthService: AuthenticationService {
    // 토큰 얻어오기 -> 토큰 없음 -> 카카오톡으로 토큰 얻어옴 -> 회원가입 로직
    //              -> 토큰 있음 -> 서비스에 존재하는 사용자인지 체크 -> 서비스 회원가입 시작
    //                              -> 서비스에 존재하지 않는 사용자 -> 회원가입 로직
    // 기존에 존재하는 사용자인지 체크 (provider의 access token 필요)
    // 없으면 -> 회원가입 -> 로그인 시도
    // 있으면 -> 로그인 시도
    
    func tryLogin() async -> AuthServiceLoginResult {
        guard let oauthToken: OAuthToken = await getOauthToken() else {
            return .fail
        }
        guard let exist = await checkUserExist(oauthToken: oauthToken) else {
            return .fail
        }
        
        if exist {
            guard let token: Token = await loginInkServer(oauthToken: oauthToken) else {
                return .fail
            }
            
            GlobalEnv.tokenStorage.save(token: token)
            return .authenticated
        }
        
        guard let user: User = try? await getUserInfo(),
              let userId = user.id else {
            return .fail
        }
            
        let idText = String(userId)
        // TODO: 애플로그인에서는 앞에 apple_가 들어가야 한다.
        let identifier: String = "kakao_\(idText)"
        let authServiceUser: AuthServiceUser = .init(identifier: identifier, email: user.kakaoAccount?.email)
        return .needSignUp(authServiceUser)
    }
    
    func loginInkServer() async -> AuthServiceLoginResult {
        let oauthToken: OAuthToken? = await getOauthToken()
        guard let oauthToken = oauthToken else {
            return .fail
        }
        
        let accessToken = oauthToken.accessToken
        let providerName: String = "kakao"
        let token: Token? = await loginInkServer(providerAccessToken: accessToken, providerName: providerName)
        print("$$ 호출이 2번 일어나나요?")
        guard let token else {
            return .fail
        }
        
        GlobalEnv.tokenStorage.save(token: token)
        return .authenticated
    }
    
    private func loginInkServer(oauthToken: OAuthToken) async -> Token? {
        let accessToken: String = oauthToken.accessToken
        let providerName: String = "kakao"
        let result: Token? = await loginInkServer(providerAccessToken: accessToken, providerName: providerName)
        return result
    }
    
    private func loginInkServer(providerAccessToken: String, providerName: String) async -> Token? {
        let providerTokenDTO: ProviderTokenDTO = .init(providerAccessToken: providerAccessToken, providerName: providerName)
        
        do {
            let response = try await MemberAuthAPI.shared.signIn(providerTokenDTO: providerTokenDTO)
            return response.data.asInkToken()
        } catch {
            MurengLogger.shared.logError(error)
            return nil
        }
    }
    
    private func checkUserExist(oauthToken: OAuthToken) async -> Bool? {
        let accessToken = oauthToken.accessToken
        let providerName: String = "kakao"
        let result = await checkUserExist(providerAccessToken: accessToken, providerName: providerName)
        return result
    }
    
    private func checkUserExist(providerAccessToken: String, providerName: String) async -> Bool? {
        let providerTokenDTO: ProviderTokenDTO = .init(providerAccessToken: providerAccessToken, providerName: providerName)
        
        do {
            let response = try await MemberAuthAPI.shared.checkUserExist(dto: providerTokenDTO)
            return response.data.exist
        } catch {
            MurengLogger.shared.logError(error)
            MurengLogger.shared.logDebug(
                "providerAccessToken: \(providerAccessToken)" +
                " providerName: \(providerName)"
            )
            return nil
        }
    }
    
    private func getOauthToken() async -> OAuthToken? {
        if AuthApi.hasToken() {
            let valid = await isAcessTokenValid()
            if valid {
                let oauthToken = await refreshAccessToken()
                return oauthToken
            }
        }
        
        let oauthToken: OAuthToken? = await loginAtKakao()
        return oauthToken
    }
    
    private func refreshAccessToken() async -> OAuthToken? {
        let checkedBody: (CheckedContinuation<OAuthToken?, Never>) -> Void = { continuation in
            AuthApi.shared.refreshToken { oauthToken, error in
                if let error = error {
                    MurengLogger.shared.logError(error)
                    continuation.resume(returning: nil)
                    return
                }
                
                if oauthToken == nil {
                    MurengLogger.shared.logError(InkError.unknownError("refreshAccessToken() - OAuthToken is nil"))
                }
                
                continuation.resume(returning: oauthToken)
            }
        }
        
        return await withCheckedContinuation(checkedBody)
    }
    
    private func isAcessTokenValid() async -> Bool {
        await withCheckedContinuation { continuation in
            UserApi.shared.accessTokenInfo { _, error in
                if let error = error {
                    MurengLogger.shared.logError(error)
                    continuation.resume(returning: false)
                    return
                }
                
                continuation.resume(returning: true)
            }
        }
    }
    
    private func loginAtKakao() async -> OAuthToken? {
        if UserApi.isKakaoTalkLoginAvailable() {
            do {
                let oauthToken: OAuthToken = try await loginAtKakaoApp()
                return oauthToken
            } catch {
                MurengLogger.shared.logError(error)
                return nil
            }
        }
        
        do {
            let oauthToken: OAuthToken = try await loginAtKakaoWeb()
            return oauthToken
        } catch {
            MurengLogger.shared.logError(error)
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
    
    @MainActor
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
            MurengLogger.shared.logError(error)
            return nil
        }
    }
    
    func signUp(authServiceUser: AuthServiceUser) async -> Member? {
        let signUpDTO: SignUpDTO = .init(authServiceUser)
        do {
            let response = try await MemberAuthAPI.shared.signUp(signUpDTO: signUpDTO)
            let memberDTO = response.data
            return memberDTO.asEntity()
        } catch {
            MurengLogger.shared.logError(error)
            return nil
        }
    }
}
