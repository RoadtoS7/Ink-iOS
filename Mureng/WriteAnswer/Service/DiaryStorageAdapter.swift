//
//  DiaryStorageAdapter.swift
//  Mureng
//
//  Created by 김수현 on 3/24/24.
//

import Foundation
import UIKit

protocol DiaryStorageAdapter {
    func writeDiary(questionId: String, content: String, imageData: Data) async -> Answer?
}

final class RemoveDiaryStorageAdapter: DiaryStorageAdapter {
    func writeDiary(questionId: String, content: String, imageData: Data) async -> Answer? {
        do {
            let imageResponse: APIResponse<UploadImageResult> = try await WriteDiaryAPI.shared.uploadImage(data: imageData)
            let imagePath: String = imageResponse.data.imagePath

            let diaryResponse: APIResponse<AnswerDTO> = try await uploadDiary(questionId: questionId, content: content, imagePath: imagePath)
            let answer = diaryResponse.data.asEntity()
            return answer
        } catch {
            MurengLogger.shared.logError(error)
            return nil
        }
    }
    
    func uploadDiary(questionId: String, content: String, imagePath: String) async throws -> APIResponse<AnswerDTO> {
        let body: UploadAnswerBody = .init(questionId: questionId, content: content, image: imagePath)
        let response: APIResponse<AnswerDTO> = try await WriteDiaryAPI.shared.uploadAnswer(body: body)
        return response
    }
}
