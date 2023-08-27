//
//  Token.swift
//  Mureng
//
//  Created by 김수현 on 2023/08/15.
//

import Foundation

struct Token {
    static var shared = Token()
    
    private(set) var accessToken: String? = nil
    private(set) var refreshToken: String? = nil
    
    mutating func set(token: Token) {
        self.accessToken = token.accessToken
        self.refreshToken = token.refreshToken
    }
}
