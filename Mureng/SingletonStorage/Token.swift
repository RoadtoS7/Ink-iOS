//
//  Token.swift
//  Mureng
//
//  Created by 김수현 on 2023/08/15.
//

import Foundation

final class GlobalEnv {
    static let tokenStorage = TokenStorage()
}

final class TokenStorage {
    private let userDefault: UserDefaults
    private(set) var token: Token
    
    var accessToken: String {
        token.accessToken
    }
    
    var refreshToken: String {
        token.refreshToken
    }
    
    init(userDefault: UserDefaults = .standard) {
        self.userDefault = userDefault
        
        let accessToken: String = (userDefault.value(forKey: Token.accessTokenKey) as? String) ?? ""
        let refreshToken: String = (userDefault.value(forKey: Token.refreshTokenKey) as? String) ?? ""
        token = Token(accessToken: accessToken, refreshToken: refreshToken)
    }
    
    func save(token: Token) {
        self.token = token
        userDefault.set(token.accessToken, forKey: Token.accessTokenKey)
        userDefault.set(token.refreshToken, forKey: Token.refreshTokenKey)
    }
}

struct Token {
    let accessToken: String
    let refreshToken: String
    
    init(accessToken: String, refreshToken: String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
    
    static let accessTokenKey: String = "accessToken"
    static let refreshTokenKey: String = "refreshToken"
}
