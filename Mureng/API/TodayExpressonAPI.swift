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

final class TodayExpressionAPI: API {
    static lazy var shared: TodayExpressionAPI {
        return .init()
    }()
    
    private override init() {}
    
    /// 오늘의 표현을 가져옵니다.
    typealias TodayExpressionDTOs = [TodayExpressionDTO]
    func get() async throws -> APIResponse<TodayExpressionDTOs> {
        let path: String = "/api/today-expression"
        let url: String = Host.baseURL + path
        let response: APIResponse<TodayExpressionDTOs> = try await requestJSON(
            url,
            responseData: TodayExpressionDTOs.self,
            method: .get
        )
        return response
    }
}
