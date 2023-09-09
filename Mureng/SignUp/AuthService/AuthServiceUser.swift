//
//  AuthServiceUser.swift
//  Mureng
//
//  Created by nylah.j on 2023/08/02.
//

import Combine

class AuthServiceUser: ObservableObject {
    private var identifier: String?
    private var email: String?
    private var image: String?
    private var nickname: String?
    
    init() {
        self.identifier = nil
        self.email = nil
        self.image = nil
        self.nickname = nil
    }
    
    init(identifier: String, email: String, image: String? = nil, nickname: String? = nil) {
        self.identifier = identifier
        self.email = email
        self.image = image
        self.nickname = nickname
    }
    
    func fill(with authServiceUser: AuthServiceUser) {
        identifier = authServiceUser.identifier
        email = authServiceUser.email
        image = authServiceUser.image
        nickname = authServiceUser.nickname
    }
    
    func enoughForSignUp() -> Bool {
        guard let identifier = identifier,
              let email,
              let image,
              let nickname else {
        return false
        }
        
        guard identifier.isNotEmpty,
              email.isNotEmpty,
              nickname.isNotEmpty,
              image.isNotEmpty else {
            return false
        }
        
        return true
    }
}
