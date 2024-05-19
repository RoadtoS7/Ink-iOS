//
//  WriteDiaryAPI.swift
//  Mureng
//
//  Created by 김수현 on 3/24/24.
//

import Foundation
import Alamofire

public final class WriteDiaryAPI: API {
    public static let shared: WriteDiaryAPI = .init()
    
    func uploadImage(data: Data) async throws -> APIResponse<UploadImageResult> {
        let path: String = "/api/replay/image"
        let url: String = Host.fileServerBaseURL + path
        let response = try await postImage(url, data: data)
        return response
    }
    
    private func postImage(_ url: String, data: Data) async throws -> APIResponse<UploadImageResult> {
        guard let request = makePostRequest(urlString: url, bodyObject: nil) else {
            throw APIError.invalidURL
        }
        
        let response: APIResponse<UploadImageResult> = try await uploadFile(urlRequest: request, data: data)
        return response
    }
    
    func loadDefaultImages() async throws -> APIResponse<DefaultImageDTO> {
        let path: String = "/api/reply/default-images"
        let url: String = Host.baseURL + path
        let response = try await getDefaultImages(url)
        return response
    }
    
    func getDefaultImages(_ url: String) async throws -> APIResponse<DefaultImageDTO> {
        guard var request = makeGetRequest(urlString: url) else {
            throw APIError.invalidURL
        }

        let accessToken: String = Token.shared.accessToken ?? ""
        request.addAuthHeader(value: accessToken)
        
        let respone: APIResponse<DefaultImageDTO> = try await requestJsonWithURLSession(urlRequest: request)
        return respone
    }
    
    func uploadAnswer(body: UploadAnswerBody) async throws -> APIResponse<AnswerDTO> {
        let path: String = "/api/reply"
        let url: String = Host.baseURL + path
        let response: APIResponse<AnswerDTO> = try await postAnswer(url: url, body: body)
        return response
    }
    
    private func postAnswer(url: String, body: UploadAnswerBody) async throws -> APIResponse<AnswerDTO>
    {
        guard var request = makePostRequest(urlString: url, bodyObject: body) else {
            throw APIError.invalidURL
        }
        
        let accessToken: String = Token.shared.accessToken ?? ""
        request.addAuthHeader(value: accessToken)
        
        let response: APIResponse<AnswerDTO> = try await requestJsonWithURLSession(urlRequest: request)
        return response
    }
}

struct UploadImageResult: Decodable {
    let imagePath: String
}

struct DefaultImageDTO: Decodable {
    let imagePath: String
}

struct UploadAnswerBody: Encodable {
    let questionId: String
    let content: String
    let image: String?
}

/**
 답변 읽기 모델{
description:
질문에 대한 답변을 나타내는 읽기 전용 모델

replyId    integer($int64)
답변 기본키

questionId*    integer($int64)
답변하려는 질문의 기본키

content*    string
답변 내용

image*    string
이미지 경로

regDate    string($date)
작성 날짜

replyLikeCount    integer($int32)
좋아요 갯수

question    질문 읽기 모델{...}
author    회원 읽기 모델{...}
requestedByAuthor    boolean
이 답변이 요청자 본인의 것인지 여부, null 인 경우 확인 불가

likedByRequester    boolean
해당 답변에 대해 요청자가 좋아요를 눌렀는 지
 */

struct AnswerDTO: DTO {
    typealias DomainModel = Answer
    
    let replyId: Int
    let questionId: Int
    let content: String
    let image: String
    let regDate: Date?
    let replyLikeCount: Int?
    let question: QuestionDTO?
    let author: MemberDTO?
    let requestedByAuthor: Bool?
    let likedByRequester: Bool?
    
    func asEntity() -> Answer {
        return Answer(
            replyId: replyId,
            questionId: questionId,
            content: content, 
            image: image,
            regDate: regDate,
            replyLikeCount: replyLikeCount ?? .zero, // 서버에 해당 값이 없을 경우 .zero 로 취급
            question: question?.asEntity(),
            author: author?.asEntity(),
            requestedByAuthor: requestedByAuthor ?? false, // 서버에 해당 값이 없을 경우 false로 취급
            likedByRequester: likedByRequester ?? false) // 서버에 해당 값이 없을 경우 false로 취급
    }
}

protocol DTO<EntityModel>: Decodable {
    associatedtype EntityModel
    func asEntity() -> EntityModel
}
