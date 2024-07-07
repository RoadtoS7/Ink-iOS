//
//  AuthService.swift
//  Mureng
//
//  Created by nylah.j on 2023/08/02.
//

import KakaoSDKAuth
import KakaoSDKUser
import KakaoSDKCommon

enum AutServiceLoginResult: Equatable {
    /// 이미 회원가입한 유저
    case authenticated
    /// 회원가입 성공한 유저
    case signUp(AuthServiceUser)
    /// 로그인 실패
    case fail
    
    static func == (lhs: AutServiceLoginResult, rhs: AutServiceLoginResult) -> Bool {
        switch (lhs, rhs) {
        case (.authenticated, .authenticated): return true
        case (.signUp(let lshUser), .signUp(let rhsUser)): return lshUser == rhsUser
        case (.fail, .fail): return true
        default: return false
        }
    }
}

protocol AuthenticationService {
    func login() async -> AutServiceLoginResult
    func isNickNameExisted(_ nickname: String) async -> Bool?
    func signUp(authServiceUser: AuthServiceUser) async -> Member?
}

final class DummySuccessAuthService: AuthenticationService {
    func signUp(authServiceUser: AuthServiceUser) async -> Member? {
        let memberSetting: MemberSetting = .init(dailyPushActive: true,
                                                 likePushActive: true)
        return .init(id: 0, identifier: "identifier", email: "email", nickname: "nickname", image: "imagew", inkCount: 0, attendanceCount: 0, lastAttendanceDate: .init(), memberSetting: memberSetting)
    }
    
    let authServiceUser: AuthServiceUser
    let nicknameExisted: Bool
    let loginResult: AutServiceLoginResult
    
    init(authServiceUser: AuthServiceUser, loginSuccess: Bool = true, nicknameExisted: Bool = false) {
        self.authServiceUser = authServiceUser
        self.nicknameExisted = nicknameExisted
        self.loginResult = loginSuccess ? .signUp(authServiceUser) : .fail
    }
    
    convenience init() {
        let authService = AuthServiceUser(identifier: "dummy_id", email: "dummy_email", image: "dummy_nickname")
        self.init(authServiceUser: authService)
    }
    
    func login() -> AutServiceLoginResult {
        .signUp(authServiceUser)
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
    func login() async -> AutServiceLoginResult {
        let oauthToken: OAuthToken? = await getOauthToken()
        guard let oauthToken = oauthToken else {
            return .fail
        }
        
        let accessToken = oauthToken.accessToken
        let providerName: String = "kakao"
        guard let exist = await checkUserExist(providerAccessToken: accessToken, providerName: providerName) else {
            return .fail
        }
        
        if exist {
            let token: Token? = await loginInkServer(providerAccessToken: accessToken, providerName: providerName)
            
            if let token = token {
                Token.shared.set(token: token)
                return .authenticated
            }
            
            return .fail
        }
        
        let user: User? = try? await getUserInfo()
        guard let user = user,
              let userId = user.id else {
            return .fail
        }
        
        let idText = String(userId)
        // TODO: 애플로그인에서는 앞에 apple_가 들어가야 한다.
        let kakaoUserId: String = "kakao_\(idText)"
        let authServiceUser: AuthServiceUser = .init(identifier: idText, email: user.kakaoAccount?.email)
        return .signUp(authServiceUser)
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
