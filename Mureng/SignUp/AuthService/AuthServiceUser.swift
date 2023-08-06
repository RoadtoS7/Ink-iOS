//
//  AuthServiceUser.swift
//  Mureng
//
//  Created by nylah.j on 2023/08/02.
//

struct AuthServiceUser {
    let identifier: String
    let email: String
    let image: String
    let nickname: String? = nil
    
    func enoughForSignUp() -> Bool {
        guard let nickname = nickname else {
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
