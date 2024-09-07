//
//  TodayExpressonAPI.swift
//  Mureng
//
//  Created by 김수현 on 2023/09/03.
//

import Foundation
import Alamofire

struct TodayExpressionDTO: Decodable {
    let id: Int
    let expression: String
    let meaning: String
    let example: String
    let exampleMeaning: String
    let scrappedByRequester: Bool
    
    var englishExpression: EnglishExpression {
        .init(id: id, content: expression, koConent: meaning, example: example, koExample: exampleMeaning)
    }
}

final class TodayExpressionAPI {
    let api: BaseAPI
    
    init(api: BaseAPI) {
        self.api = api
    }
    
    /// 오늘의 표현을 가져옵니다.
    typealias TodayExpressionDTOs = [TodayExpressionDTO]
    func get() async throws -> APIResponse<TodayExpressionDTOs> {
        let path: String = "/api/today-expression"
        let urlLiteral: String = Host.baseURL + path
        
        let response: APIResponse<TodayExpressionDTOs> = try await api.request(
            urlLiteral: urlLiteral,
            method: .get,
            headers: [HeaderKey.xAuthToken.rawValue : GlobalEnv.tokenStorage.accessToken]
        )
        return response
    }
}

final class DeprecatedTodayExpressionAPI: API {
    static var shared: DeprecatedTodayExpressionAPI = .init()
    
    private override init() {}
    
    /// 오늘의 표현을 가져옵니다.
    typealias TodayExpressionDTOs = [TodayExpressionDTO]
    func get() async throws -> APIResponse<TodayExpressionDTOs> {
        let path: String = "/api/today-expression"
        let absoluteURL: String = Host.baseURL + path
        
        
        guard let url: URL = .init(string: absoluteURL) else {
            throw APIError.invalidURL
        }
        
        var urlRequest: URLRequest = .init(url: url)
        urlRequest.addAuthHeader()
        urlRequest.httpMethod = "GET"
        
        let response: APIResponse<TodayExpressionDTOs> = try await requestJsonWithURLSession(urlRequest: urlRequest)
        return response
    }
}
