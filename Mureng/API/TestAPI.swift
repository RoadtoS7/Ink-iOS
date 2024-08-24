//
//  TestAPI.swift
//  Mureng
//
//  Created by 김수현 on 8/23/24.
//

import Foundation
import Alamofire

enum HeaderKey: String {
    case xAuthToken = "X_AUTH_TOKEN"
}

class APIBaseClass {
    
    let urlSession: URLSession  = {
        let session: URLSession = URLSession.shared
        session.configuration.timeoutIntervalForRequest = 10
        session.configuration.timeoutIntervalForResource = 10
        return session
    }()
    
    
    func request<T: Decodable> (urlRequest: URLRequest) async throws -> T {
        let (data, _): (Data, URLResponse) = try await urlSession.data(for: urlRequest)
        let response: APIResponse<T> = try decode(data: data)
        return response.data
    }
    
    func decode<T: Decodable>(data: Data) throws -> T {
        // should override
        let apiResponse: T = try JSONDecoder().decode(T.self, from: data)
        return apiResponse
    }
}


final class TestAPI {
    static let xAuthToken: String = "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJ0ZXN0X2lkZW50aWZpZXIiLCJuaWNrbmFtZSI6Iu2FjOyKpO2KuOycoOyggCIsImlhdCI6MTYyMDgzODEwMiwiZXhwIjoxOTAwMDAwMDAwfQ.Nu2Zjazo2wEfPvv28Lisa6PYlNjLeclmRZLEf2HiA9xyFNRhWu4bNSaG_nkhLIdkSK47Y7xGhTO--vuazaRzdw"

    
    static func request(urlRequest: URLRequest) {
        
        var headers = urlRequest.headers
        headers[HeaderKey.xAuthToken.rawValue] = xAuthToken
        
    }
}
