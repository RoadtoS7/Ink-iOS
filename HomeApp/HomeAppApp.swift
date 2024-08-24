//
//  HomeScreenApp.swift
//  HomeApp
//
//  Created by 김수현 on 8/23/24.
//

import SwiftUI

@main
struct HomeScreenApp: App {
    
    var body: some Scene {
        WindowGroup {
            HomeScreenView(todayExpressionService: FakeTodayExpressionService(), questionService: FakeQuestionService())
        }
    }
}
