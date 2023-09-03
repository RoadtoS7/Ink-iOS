//
//  HomeScreenView.swift
//  Mureng
//
//  Created by 김수현 on 2023/09/03.
//

import SwiftUI

struct HomeScreenView: View {
    let question: Question
    @State var todayExpressions: [EnglishExpression]
    
    var body: some View {
        VStack(spacing: 0) {
            HomeHeaderView()
                .padding(.bottom, 28)
            
            QuestionCardView(question: question, refreshAction: {})
                .padding(.bottom, 24)
                .shadow(color: .black.opacity(0.15), radius: 5, x: 0, y: 4)
            
            Button("글쓰기", action: {
                
            })
            .buttonStyle(ButtonSoild48Style())
            .frame(height: 48)
            .padding(.bottom, 28)
            
            VStack(spacing: 20) {
                // TODO: 폰트 색상 수정
                Text("오늘의 표현")
                .font(FontFamily.Pretendard.regular.swiftUIFont(size: 16))
                .frame(maxWidth: .infinity, alignment: .leading)
                
                TodayExpressionListView(todayExpressions: todayExpressions)
            }
            .padding(.vertical, 20)
        }
        .padding(.horizontal, 24)
    }
}

struct HomeScreenView_Previews: PreviewProvider {
    private static var question: Question = .init(
        id: 0,
        content: "What do you want?",
        koreanContent: "어떤 습관을 만들고 싶나요?"
    )
    
    private static var todayExprssions: [EnglishExpression] = [
        .init(
            id: 0,
            content: "can’t wait to ~",
            koConent: "얼른 ~하고 싶다",
            example: "I can’t wait to go on this trip.",
            koExample: "얼른 여행을 떠났으면 좋겠어."
        ),
        .init(
            id: 0,
            content: "can’t wait to ~",
            koConent: "얼른 ~하고 싶다",
            example: "I can’t wait to go on this trip.",
            koExample: "얼른 여행을 떠났으면 좋겠어."
        ),
    ]
    
    static var previews: some View {
        HomeScreenView(question: question,
                       todayExpressions: todayExprssions)
    }
}

struct HomeHeaderView: View {
    var body: some View {
        HStack {
            Text("반가워요, 김잉크님")
            Spacer()
            ProfileImageView()
                .frame(width: 48, height: 48)
        }
    }
}

struct ProfileImageView: View {
    var body: some View {
        Circle()
            .fill(Colors.lightestBg3.swiftUIColor)
    }
}
