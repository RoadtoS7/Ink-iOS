//
//  TodayExpressionListView.swift
//  Mureng
//
//  Created by 김수현 on 2023/09/03.
//

import SwiftUI

struct TodayExpressionListView: View {
    let todayExpressions: [EnglishExpression]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            ForEach(todayExpressions) { expression in
                ExpressionRowView(engExpression: expression)
                    .frame(height: 72)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct TodayExpressionListView_Previews: PreviewProvider {
    private static var todayExprssions: [EnglishExpression] = [
        .init(
            id: 0,
            content: "can’t wait to ~",
            koConent: "얼른 ~하고 싶다",
            example: "I can’t wait to go on this trip.",
            koExample: "얼른 여행을 떠났으면 좋겠어."
        ),
        .init(
            id: 1,
            content: "beThrough",
            koConent: "~을 겪다.",
            example: "You've been through alot",
            koExample: "고생 많았어"
        ),
    ]
    
    static var previews: some View {
        TodayExpressionListView(todayExpressions: todayExprssions)
    }
}
