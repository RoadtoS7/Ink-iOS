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
        let url: String = Host.baseURL + path
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
    
    func uploadAnswer(body: UploadAnswerBody) async throws -> APIResponse<PostAnswerDTO> {
        let path: String = "/api/reply"
        let url: String = Host.baseURL + path
        let response: APIResponse<PostAnswerDTO> = try await postAnswer(url: url, body: body)
        return response
    }
    
    private func postAnswer(url: String, body: UploadAnswerBody) async throws -> APIResponse<PostAnswerDTO>
    {
        guard var request = makePostRequest(urlString: url, bodyObject: body) else {
            throw APIError.invalidURL
        }
        
        let accessToken: String = Token.shared.accessToken ?? ""
        request.addAuthHeader(value: accessToken)
        
        let response: APIResponse<PostAnswerDTO> = try await requestJsonWithURLSession(urlRequest: request)
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
    let questionId: Int
    let content: String
    let image: String
}

struct PostAnswerDTO: Decodable {
    let replyId: Int
    let questionId: Int
    let content: String
    let image: String
    let regDate: String
    let replyLikeCount: Int
    let question: QuestionDTO
    let author: AuthorDTO
    let requestedByAuthor: Bool
    let likedByRequester: Bool
}
