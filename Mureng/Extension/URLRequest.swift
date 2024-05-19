//
//  URLRequest.swift
//  Mureng
//
//  Created by 김수현 on 3/24/24.
//

import Foundation

extension URLRequest {
    mutating func addAuthHeader(value: String = "") {
        let key: String = "X-AUTH-TOKEN"
        let value: String = value
        addValue(value, forHTTPHeaderField: key)
    }
}
