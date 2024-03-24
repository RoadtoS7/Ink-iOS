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
}

struct UploadImageResult: Decodable {
    let imagePath: String
}
