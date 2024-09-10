//
//  QuestionService.swift
//  Mureng
//
//  Created by 김수현(RoadtoS7) on 2023/10/04.
//

import Foundation

protocol QuestionService {
    func getTodayQuestion() async -> Question
    func refreshTodayQuestion() async -> Question
}

struct RemoteQuestionService: QuestionService {
    let todayQuestionAPI: TodayQuestionAPI
    
    init() {
        todayQuestionAPI = TodayQuestionAPI(api: ProductionAPI())
    }
    
    init(api: BaseAPI) {
        todayQuestionAPI = TodayQuestionAPI(api: DebugAPI())
    }
    
    func getTodayQuestion() async -> Question {
        do {
            let response: APIResponse<QuestionDTO> = try await todayQuestionAPI.get()
            let questionDTO: QuestionDTO = response.data
            return questionDTO.asEntity()
        } catch {
            return Question.notReady
        }
    }
    
    func refreshTodayQuestion() async -> Question {
        do {
            let response: APIResponse<QuestionDTO> = try await todayQuestionAPI.refresh()
            let questionDTO: QuestionDTO = response.data
            return questionDTO.asEntity()
        } catch {
            return Question.notReady
        }
    }
}


struct FakeQuestionService: QuestionService {
    private let question: Question = .init(
        id: 0,
        content: "What do you want?",
        koreanContent: "어떤 습관을 만들고 싶나요?"
    )
    
    func getTodayQuestion() async -> Question {
        question
    }
    
    func refreshTodayQuestion() async -> Question {
        question
    }
}
