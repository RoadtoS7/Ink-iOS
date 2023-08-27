//
//  AppState.swift
//  Mureng
//
//  Created by 김수현 on 2023/05/29.
//

import Foundation
import SwiftUI

struct AppState: Equatable {
    var userData = UserData()
    var routing = ViewRouting()
    var system = System()
    var permissinos = Permissions()
}

// MARK: - UserData
extension AppState {
    struct UserData: Equatable {
        
    }
}

// MARK: - ViewRouting
extension AppState {
    struct ViewRouting: Equatable {
        
    }
}

// MARK: - System
extension AppState {
    struct System: Equatable {
        
    }
}

// MARK: - Permissions
extension AppState {
    struct Permissions: Equatable {
        
    }
}
