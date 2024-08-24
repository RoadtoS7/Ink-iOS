//
//  TodayExpressionService.swift
//  Mureng
//
//  Created by 김수현 on 2023/09/09.
//

import Foundation

protocol TodayExpressionService {
    func get() async -> [EnglishExpression]
}

final class RemoteTodayExpressionService: TodayExpressionService {
    let todayExpressionAPI: TodayExpressionAPI
    
    init() {
        todayExpressionAPI = TodayExpressionAPI(api: ProductionAPI())
    }
    
    init(api: BaseAPI) {
        todayExpressionAPI = TodayExpressionAPI(api: DebugAPI())
    }
    
    func get() async -> [EnglishExpression] {
        do {
            let response: APIResponse<[TodayExpressionDTO]> = try await todayExpressionAPI.get()
            let dtos = response.data
            return dtos.map { $0.englishExpression }
        } catch {
            MurengLogger.shared.logError(error)
            return []
        }
    }
}

//final class RemoteTodayExpressionService: TodayExpressionService {
//    func get() async -> [EnglishExpression] {
//        do {
//            let response: APIResponse<[TodayExpressionDTO]> = try await TodayExpressionAPI.shared.get()
//            let dtos = response.data
//            return dtos.map { $0.englishExpression }
//        } catch {
//            MurengLogger.shared.logError(error)
//            return []
//        }
//    }
//}

final class FakeTodayExpressionService: TodayExpressionService {
    func get() async -> [EnglishExpression] {
        [
            .init(
                id: 0,
                content: "can’t wait to ~",
                koConent: "얼른 ~하고 싶다",
                example: "I can’t wait to go on this trip.",
                koExample: "얼른 여행을 떠났으면 좋겠어."
            ),
            .init(
                id: 0,
                content: "can’t wait to ~",
                koConent: "얼른 ~하고 싶다",
                example: "I can’t wait to go on this trip.",
                koExample: "얼른 여행을 떠났으면 좋겠어."
            ),
        ]
    }
}
