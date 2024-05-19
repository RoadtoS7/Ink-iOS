//
//  TodayExpressionService.swift
//  Mureng
//
//  Created by 김수현 on 2023/09/09.
//

import Foundation

protocol TodayExprssionService {
    func get() async -> [EnglishExpression]
}

final class RemoteTodayExpressionService: TodayExprssionService {
    func get() async -> [EnglishExpression] {
        do {
            let response: APIResponse<[TodayExpressionDTO]> = try await TodayExpressionAPI.shared.get()
            let dtos = response.data
            return dtos.map { $0.englishExpression }
        } catch {
            MurengLogger.shared.logError(error)
            return []
        }
    }
}
