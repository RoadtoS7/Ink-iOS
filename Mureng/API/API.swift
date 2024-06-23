//
//  API.swift
//  Mureng
//
//  Created by 김수현 on 3/24/24.
//

import Foundation
import Alamofire

enum APIError: LocalizedError {
    case invalidURL
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "형식이 올바르지 않은 url 입니다."
        }
    }
}

public class API {
    let session: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        configuration.timeoutIntervalForResource = 10
        return Session(configuration: configuration)
    }()
    
    let urlSession: URLSession  = {
        let session: URLSession = URLSession.shared
        session.configuration.timeoutIntervalForRequest = 10
        session.configuration.timeoutIntervalForResource = 10
        return session
    }()
    
    func requestJSON<T: Decodable>(
        _ url: String,
        responseData: T.Type,
        method: HTTPMethod,
        parameters: Parameters? = nil,
        tokenOnHeader: Bool = false
    ) async throws -> APIResponse<T> {
        let accessToken: String = Token.shared.accessToken ?? ""
        let httpHeader: HTTPHeader = .init(name: "X-AUTH-TOKEN", value: accessToken)
        
        return try await session.request(
            url,
            method: method,
            parameters: parameters,
            encoding: URLEncoding.default,
            headers: .init([httpHeader])
        )
        .serializingDecodable(
            APIResponse<T>.self,
            dataPreprocessor: ResponseLogger(url: url)
        )
        .value
  }
    
    func requestJsonWithURLSession<T: Decodable> (
        urlRequest: URLRequest
    ) async throws -> APIResponse<T> {
        log(request: urlRequest)
        let (data, _): (Data, URLResponse) = try await urlSession.data(for: urlRequest)
        print("$$ \(String(describing: urlRequest.url)) - response: \(String(describing: String(data: data, encoding: .utf8)))")
        
        let apiResponse = try JSONDecoder().decode(APIResponse<T>.self, from: data)
        return apiResponse
    }
    
    func makePostRequest(urlString: String, bodyObject: Encodable?) -> URLRequest? {
        guard let url = URL(string: urlString) else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let bodyObject {
            do {
                try appendBody(request: &request, bodyObject: bodyObject)
            } catch {
                #if DEBUG
                    print(error)
                #endif
                return nil
            }
        }
        return request
    }
    
    private func appendBody(request: inout URLRequest, bodyObject: Encodable) throws {
        let jsonData = try JSONEncoder().encode(bodyObject)
        request.httpBody = jsonData
    }
    
    func makeGetRequest(urlString: String) -> URLRequest? {
        guard let url = URL(string: urlString) else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
 
    func log(request: URLRequest) {
        let url: String = request.url?.absoluteString ?? ""
        let httpMethod: String = request.httpMethod ?? ""
        let httpBody: Data = request.httpBody ?? Data()
        let httpBodyText: String = String(data: httpBody, encoding: .utf8) ?? ""
        let headers = request.headers.reduce("") { partialResult, httpHeader in
            partialResult + "\n" + "\(httpHeader.name) - \(httpHeader.value)"
        }
        print("$$ \(url) - \(httpMethod) - request header: \(headers) \n- httpBody: \(httpBodyText)")
    }
    
    func uploadFile<T: Decodable> (urlRequest: URLRequest, data: Data) async throws -> APIResponse<T> {
        log(request: urlRequest)
        let (data, _): (Data, URLResponse) = try await urlSession.upload(for: urlRequest, from: data)
        let jsonObject = try? JSONSerialization.jsonObject(with: data)
        let dict = jsonObject.flatMap { $0 as? [String:Any] }
        print("$$ uploadFile response dict: ", dict)
        
        let apiResponse = try JSONDecoder().decode(APIResponse<T>.self, from: data)
        return apiResponse
    }
}
