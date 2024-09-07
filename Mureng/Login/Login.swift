//
//  Login.swift
//  Mureng
//
//  Created by 김수현 on 7/7/24.
//

import Foundation

final class Login {
    static var shared = Login()
    
    private init() {}
    
    func hasUserLogined() -> Bool {
        print("$$ GlobalEnv.tokenStorage.accessToken?.isNotEmpty: ", GlobalEnv.tokenStorage.accessTokenIsNotEmpty)
        return GlobalEnv.tokenStorage.accessTokenIsNotEmpty
    }
}
