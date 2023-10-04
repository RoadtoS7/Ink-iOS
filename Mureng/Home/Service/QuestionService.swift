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
    func getTodayQuestion() async -> Question {
        do {
            let response: APIResponse<QuestionDTO> = try await TodayQuestionAPI.shared.get()
            let questionDTO: QuestionDTO = response.data
            return questionDTO.asQuestion()
        } catch {
            return Question.notReady
        }
    }
    
    func refreshTodayQuestion() async -> Question {
        do {
            let response: APIResponse<QuestionDTO> = try await TodayQuestionAPI.shared.refresh()
            let questionDTO: QuestionDTO = response.data
            return questionDTO.asQuestion()
        } catch {
            return Question.notReady
        }
    }
}

