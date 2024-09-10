//
//  HomeScreenApp.swift
//  HomeApp
//
//  Created by 김수현 on 8/23/24.
//

import SwiftUI

@main
struct HomeScreenApp: App {
    let todayExpressionService: TodayExpressionService = RemoteTodayExpressionService(api: DebugAPI())
    let questionSErvice: QuestionService = RemoteQuestionService(api: DebugAPI())
    
    var body: some Scene {
        WindowGroup {
            HomeScreenView(todayExpressionService: todayExpressionService, questionService: questionSErvice)
        }
    }
}
