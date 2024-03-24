//
//  MemberAuthAPI.swift
//  Mureng
//
//  Created by 김수현 on 2023/07/15.
//

import Foundation
import Alamofire

protocol MemberAuthable {
    static func signUp(_ signUp: SignUp, completion: @escaping (Member?) -> Void)
}

struct MemberAuthService: MemberAuthable {
    static func signUp(_ signUp: SignUp, completion: @escaping (Member?) -> Void) {
        let signUpDTO: SignUpDTO = .init(signUp)
        
        MemberAuthAPI.shared.signUp(signUPDTO: signUpDTO) { memberDTO in
            guard let memberDTO = memberDTO else {
                completion(nil)
                return
            }
            
            completion(memberDTO.asModel())
        }
    }
}

struct APIResponse<Data: Decodable>: Decodable {
    let message: String
    let data: Data
    let timestamp: Int
    
    static func empty(message: String, data: Data) -> APIResponse {
        .init(message: message, data: data, timestamp: Date().hashValue)
    }
}

struct MemberSetting {
    let dailyPushActive: Bool
    let likePushActive: Bool
}

struct Member {
    let id: Int
    let identifier: String
    let email: String
    let nickname: String
    let image: String
    let inkCount: Int
    let attendanceCount: Int
    let lastAttendanceDate: Date
    let memberSetting: MemberSetting
}

struct MemberSettingDTO: Decodable {
    let dailyPushActive: Bool
    let likePushActive: Bool
    
    func asModel() -> MemberSetting {
        .init(dailyPushActive: dailyPushActive, likePushActive: likePushActive)
    }
}

struct MemberDTO: Decodable {
    let memberId: Int
    let identifier: String
    let email: String
    let nickname: String
    let image: String
    let inkCount: Int
    let attendanceCount: Int
    let lastAttendanceDate: String // "2023-10-07"
    let memberSetting: MemberSettingDTO
    
    func asModel() -> Member {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let lastAttendanceDate = dateFormatter.date(from: lastAttendanceDate) ?? Date()
        
        return .init(id: memberId,
              identifier: identifier,
              email: email,
              nickname: nickname,
              image: image,
              inkCount: inkCount,
              attendanceCount: attendanceCount,
              lastAttendanceDate: lastAttendanceDate,
              memberSetting: memberSetting.asModel()
        )
    }
}

struct SignUp {
    let identifier: String
    let email: String
    let nickname: String
    let image: String
}

struct SignUpDTO: Encodable {
    let identifier: String
    let email: String
    let nickname: String
    let image: String
    
    init(_ signUp: SignUp) {
        identifier = signUp.identifier
        email = signUp.email
        nickname = signUp.nickname
        image = signUp.image
    }
    
    init(_ authServiceUser: AuthServiceUser) {
        self.identifier = authServiceUser.identifier ?? ""
        self.email = authServiceUser.email ?? ""
        self.nickname = authServiceUser.nickname ?? ""
        self.image = authServiceUser.image ?? ""
    }
    
    func asBody() -> [String: Any] {
        [
            "identifier": identifier,
            "email": email,
            "nickname": nickname,
            "image": image
        ]
    }
}

struct ProviderTokenDTO: Encodable {
    let providerAccessToken: String
    let providerName: String
    
    func asBody() -> [String: Any] {
        return [
            "providerAccessToken": providerAccessToken,
            "providerName": providerName
        ]
    }
}

struct InkTokenDTO: Decodable {
    let inkAccessToken: String
    let inkRefreshToken: String
    
    func asInkToken() -> Token {
        .init(accessToken: inkAccessToken, refreshToken: inkRefreshToken)
    }
}

struct UserExistDTO: Codable {
    let exist: Bool
    let identifier: String
}

final class ResponseLogger: DataPreprocessor {
    private let url: String
    
    init(url: String) {
        self.url = url
    }
    
    func preprocess(_ data: Data) throws -> Data {
        let json: String = String(decoding: data, as: UTF8.self)
        print("$$ \(url) - response: \(json)")
        return data
    }
}

final class MemberAuthAPI: API {
    static let shared: MemberAuthAPI = .init()
    
    private override init() {}
    
    func signIn(providerTokenDTO: ProviderTokenDTO) async throws -> APIResponse<InkTokenDTO> {
        let path: String = "/api/member/signin"
        let url: String = Host.baseURL + path
        let response = try await requestJSON(url, responseData: InkTokenDTO.self, method: .post, parameters: providerTokenDTO.asBody())
        return response
    }
    
    func signUp(signUpDTO: SignUpDTO) async throws -> APIResponse<MemberDTO> {
        let path: String = "/api/member/signup"
        let url: String = Host.baseURL + path
      
        guard let urlRequest: URLRequest = makePostRequest(urlString: url, bodyObject: signUpDTO) else {
            throw APIError.invalidURL
        }
        let response: APIResponse<MemberDTO> = try await requestJsonWithURLSession(urlRequest: urlRequest)
        return response
    }
    
    func signUp(signUPDTO: SignUpDTO, completion: @escaping (MemberDTO?) -> Void) {
        let path: String = "/api/member/signup"
        let url: String = Host.baseURL + path
       
        AF.request(url, method: .post, parameters: signUPDTO.asBody())
            .response { response in
                guard let data = response.data else {
                    completion(nil)
                    return
                }
                
                do {
                    let memberDTO = try JSONDecoder().decode(MemberDTO.self, from: data)
                    completion(memberDTO)
                } catch {
                #if DEBUG
                    print(error)
                #endif
                    completion(nil)
                }
            }
    }
    
    func checkUserExist(dto: ProviderTokenDTO) async throws -> APIResponse<UserExistDTO> {
        let path: String = "/api/member/user-exists"
        let url: String = Host.baseURL + path
        
        guard let request = makePostRequest(urlString: url, bodyObject: dto) else {
            return APIResponse.empty(
                message: "$$ make post request fail",
                data: UserExistDTO(exist: false, identifier: "")
            )
        }
        
        let response: APIResponse<UserExistDTO> = try await requestJsonWithURLSession(urlRequest: request)
        return response
        
//        let response = try await requestJSON(
//            url,
//            responseData: UserExistDTO.self,
//            method: .post,
//            parameters: dto.asBody()
//        )
//        return response
    }
    
    func checkNicknameDuplicated(nickName: String) async throws -> APIResponse<NicknameDuplicatedDTO> {
        let path: String = "/api/member/nickname-exists/\(nickName)"
        let url: String = Host.baseURL + path
        let response = try await requestJSON(url, responseData: NicknameDuplicatedDTO.self, method: .get)
        return response
    }
}

struct NicknameDuplicatedDTO: Decodable {
    let duplicated: Bool
}

struct SignUpUser {
    let identifier: String
    let email: String
    let image: String
    let nickname: String? = nil
    
    func enoughForSignUp() -> Bool {
        guard let nickname = nickname else {
            return false
        }
        
        guard identifier.isNotEmpty,
              email.isNotEmpty,
              nickname.isNotEmpty,
              image.isNotEmpty else {
            return false
        }
        
        return true
    }
}
