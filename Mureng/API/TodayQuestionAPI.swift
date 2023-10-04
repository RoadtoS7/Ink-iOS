//
//  TodayQuestionAPI.swift
//  Mureng
//
//  Created by nylah.j on 2023/10/04.
//

import Foundation

struct QuestionDTO: Decodable {
    let questionId: Int
    let category: String
    let content: String
    let koContent: String
    let wordHints: [WordHintDTO]
    let autor: AuthorDTO
    let repliesCount: Int
    
    func asQuestion() -> Question {
        .init(id: questionId, content: content, koreanContent: koContent)
    }
}

struct WordHintDTO: Decodable {
    let hintId: Int
    let word: String
    let meaning: String
}

struct AuthorDTO: Decodable {
    let memberId: Int
    let identifier: String
    let email: String
    let image: String
    let inkCount: Int
    let attendanceCount: Int
    let lastAttendanceDate: String
    let memberSetting: MemberSettingDTO
}

final class TodayQuestionAPI: API {
    static var shared: TodayQuestionAPI = .init()
    private override init() {}
    
    /// 현재 로그인한 사용자의 오늘의 질문을 가져옵니다.
    func get() async throws -> APIResponse<QuestionDTO> {
        let path: String = "/api/today-question"
        let url: String = Host.baseURL + path
        
        var urlRequest: URLRequest = try .init(url: url, method: .get)
        let accessToken: String = Token.shared.accessToken ?? ""
        urlRequest.addAuthHeader(value: accessToken)

        let response: APIResponse<QuestionDTO> =  try await requestJsonWithURLSession(urlRequest: urlRequest)
        return response
    }
    
    /// 오늘의 질문을 새로고침해서 가져옵니다.
    func refresh() async throws -> APIResponse<QuestionDTO> {
        let path: String = "/api/today-question/refresh"
        let url: String = Host.baseURL + path
        let response: APIResponse<QuestionDTO> = try await requestJSON(
            url,
            responseData: QuestionDTO.self,
            method: .get
        )
        return response
    }
}
