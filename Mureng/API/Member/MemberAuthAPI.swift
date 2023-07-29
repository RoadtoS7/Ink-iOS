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
        
        MemberAuthAPI.signUp(signUPDTO: signUpDTO) { memberDTO in
            guard let memberDTO = memberDTO else {
                completion(nil)
                return
            }
            
            completion(memberDTO.asModel())
        }
    }
}


struct APIResponse<Data: Decodable> {
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
    
    func asBody() -> [String : Any] {
        [
            "identifier": identifier,
            "email": email,
            "nickname": nickname,
            "image": image
        ]
    }
}

class MemberAuthAPI {
    static func signUp(signUPDTO: SignUpDTO, completion: @escaping (MemberDTO?) -> Void) {
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
}
