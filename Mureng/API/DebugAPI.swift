//
//  TestAPI.swift
//  Mureng
//
//  Created by 김수현 on 8/23/24.
//

import Foundation
import Alamofire

enum HeaderKey: String {
    case xAuthToken = "X_AUTH_TOKEN"
}

enum NetworkError: Error {
    case invalidURL
    case encodingRequestBody
    case remoteError(error: Error)
}

public class BaseAPI {
    typealias Headers = [String:String]
    
    let urlSession: URLSession  = {
        let session: URLSession = URLSession.shared
        session.configuration.timeoutIntervalForRequest = 10
        session.configuration.timeoutIntervalForResource = 10
        return session
    }()
    
    func request<ResponsesBody: Decodable> (
        urlLiteral: String,
        method: HTTPMethod,
        headers: Headers
    ) async throws -> APIResponse<ResponsesBody> {
        do {
            var request: URLRequest = try makeURLRequest(urlLiteral: urlLiteral, method: method)
            let customRequest: URLRequest = customRequest(request: &request)
            MurengLogger.shared.logDebug("$$ \(urlLiteral) - request - \(customRequest.headers)")
            
            let data: Data =  try await callAPI(urlRequest: customRequest)
            MurengLogger.shared.logDebug("$$ \(urlLiteral) - data - \(String(data: data, encoding: .utf8))")

            let response: APIResponse<ResponsesBody> = try decode(data: data)
            return response
        } catch {
            MurengLogger.shared.logError(prefix: "$$ \(urlLiteral)", error)
            throw error
        }
    }
    
    func request<RequestBody: Encodable, ResponsesBody: Decodable> (
        urlLiteral: String,
        method: HTTPMethod,
        headers: Headers,
        bodyObject: RequestBody? = nil
    ) async throws -> APIResponse<ResponsesBody> {
        var request: URLRequest = try makeURLRequest(urlLiteral: urlLiteral, method: method)
        let requestWithBody = try appendBodyIfNeed(request: request, bodyObject: bodyObject)
        let customRequest: URLRequest = customRequest(request: &request)
        let data: Data =  try await callAPI(urlRequest: request)
        let response: APIResponse<ResponsesBody> = try decode(data: data)
        return response
    }
    
    public func customRequest(request: inout URLRequest) -> URLRequest {
        return request
    }
    
    func makeURLRequest(urlLiteral: String, method: HTTPMethod) throws -> URLRequest {
        guard let url = URL(string: urlLiteral) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    private func appendBodyIfNeed(request: URLRequest, bodyObject: Encodable?) throws -> URLRequest {
        guard let bodyObject else {
            return request
        }
        
        do {
            var request = request
            let jsonData = try JSONEncoder().encode(bodyObject)
            request.httpBody = jsonData
            return request
        } catch {
            throw NetworkError.encodingRequestBody
        }
        
    }
    
    private func callAPI(urlRequest: URLRequest) async throws -> Data {
        do {
            let (data, _): (Data, URLResponse) = try await urlSession.data(for: urlRequest)
            return data
        } catch {
            throw NetworkError.remoteError(error: error)
        }
    }
    
    private func decode<T: Decodable>(data: Data) throws -> T {
        // should override
        let apiResponse: T = try JSONDecoder().decode(T.self, from: data)
        return apiResponse
    }
}

public final class ProductionAPI: BaseAPI {}

public final class DebugAPI: BaseAPI {
    private let xAuthToken: String = "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJ0ZXN0X2lkZW50aWZpZXIiLCJuaWNrbmFtZSI6Iu2FjOyKpO2KuOycoOyggCIsImlhdCI6MTYyMDgzODEwMiwiZXhwIjoxOTAwMDAwMDAwfQ.Nu2Zjazo2wEfPvv28Lisa6PYlNjLeclmRZLEf2HiA9xyFNRhWu4bNSaG_nkhLIdkSK47Y7xGhTO--vuazaRzdw"
    
    public override func customRequest(request: inout URLRequest) -> URLRequest {
        request.setValue(xAuthToken, forHTTPHeaderField: HeaderKey.xAuthToken.rawValue)
        return request
    }
}
