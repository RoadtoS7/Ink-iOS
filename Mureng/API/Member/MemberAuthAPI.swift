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
    let timeStamp: Int
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
    let id: Int
    let identifier: String
    let email: String
    let nickname: String
    let image: String
    let inkCount: Int
    let attendanceCount: Int
    let lastAttendanceDate: Date
    let memberSetting: MemberSettingDTO
    
    func asModel() -> Member {
        .init(id: id,
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
            CodingKeys.providerAccessToken.stringValue: providerAccessToken,
            CodingKeys.providerName.stringValue: providerName
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

struct UserExistDTO: Decodable {
    let exist: Bool
    let identifier: String
}

class MemberAuthAPI {
    static let shared = MemberAuthAPI()
    
    private init() {}
    
    private let session: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        configuration.timeoutIntervalForResource = 10
        return Session(configuration: configuration)
    }()
    
    func signIn(providerTokenDTO: ProviderTokenDTO) async throws -> APIResponse<InkTokenDTO> {
        let path: String = "/api/member/signin"
        let url: String = Host.baseURL + path
        let response = try await requestJSON(url, responseData: InkTokenDTO.self, method: .post, parameters: providerTokenDTO.asBody())
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
        let response = try await requestJSON(url, responseData: UserExistDTO.self, method: .post, parameters: dto.asBody())
        return response
    }
    
    func checkNicknameDuplicated(nickName: String) async throws -> APIResponse<NicknameDuplicatedDTO> {
        let path: String = "/api/member/nickname-exists/\(nickName)"
        let url: String = Host.baseURL + path
        let response = try await requestJSON(url, responseData: NicknameDuplicatedDTO.self, method: .get)
        return response
    }
    
    func requestJSON<T: Decodable>(
        _ url: String,
        responseData: T.Type,
        method: HTTPMethod,
        parameters: Parameters? = nil
    ) async throws -> APIResponse<T> {
        return try await session.request(
            url,
            method: method,
            parameters: parameters,
            encoding: URLEncoding.default
        )
        .serializingDecodable(APIResponse<T>.self)
        .value
  }
    
    private static func makePostRequest(urlString: String, bodyObject: Encodable) -> URLRequest? {
        guard let url = URL(string: urlString) else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(bodyObject)
            let json = String(data: jsonData, encoding: String.Encoding.utf8)
            let data = json?.data(using: .utf8)
            
            request.httpBody = data
            return request
        } catch {
            #if DEBUG
                print(error)
            #endif
            return nil
        }
    }
    
    private static func makeGetRequest(urlString: String) -> URLRequest? {
        guard let url = URL(string: urlString) else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
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
