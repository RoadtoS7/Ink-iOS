//
//  HomeScreenView.swift
//  Mureng
//
//  Created by 김수현 on 2023/09/03.
//

import SwiftUI

struct HomeScreenView: View {
    let todayExpressionService: TodayExpressionService
    let questionService: QuestionService
    
    @State var question: Question = Question.notReady
    @State var todayExpressions: [EnglishExpression] = []
    @State var writableTodayDiary: Bool = true
    
    var body: some View {
        VStack(spacing: 0) {
            HomeHeaderView()
                
            Spacer().frame(height: 28)
            
            QuestionCardView(question: question, refreshAction: {
                question = await questionService.refreshTodayQuestion()
            })
            
            Spacer().frame(height: 24)
            
            Button(writableTodayDiary ? "답변하기" : "밤 12시에 다시 쓸 수 있어요.", action: {
                
            })
            .buttonStyle(ButtonSoild48Style())
            .disabled(!writableTodayDiary)
            .frame(height: 48)
            
            Spacer().frame(height: 28)
            
            VStack(spacing: 20) {
                // TODO: 폰트 색상 수정
                Text("오늘의 표현")
                    .foregroundStyle(Colors.Greyscale.greyscale700.swiftUIColor)
                .font(FontFamily.Pretendard.regular.swiftUIFont(size: 16))
                .frame(maxWidth: .infinity, alignment: .leading)
                
                TodayExpressionListView(todayExpressions: todayExpressions)
            }
            .padding(.vertical, 20)
        }
        .navigationBarBackButtonHidden()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 24)
        .task {
            let todayExpressions: [EnglishExpression] = await todayExpressionService.get()
            self.todayExpressions = todayExpressions
            
            let todayQuestion: Question = await questionService.getTodayQuestion()
            self.question = todayQuestion
        }
    }
}

extension HomeScreenView {
    init(question: Question,
         todayExpressions: [EnglishExpression],
         writableTodayDiary: Bool) {
        self.questionService = FakeQuestionService()
        self.todayExpressionService = FakeTodayExpressionService()
        
        self.question = question
        self.todayExpressions = todayExpressions
        self.writableTodayDiary = writableTodayDiary
    }
    
    init() {
        self.questionService = RemoteQuestionService()
        self.todayExpressionService = RemoteTodayExpressionService()
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
        Group {
            HomeScreenView(question: question,
                           todayExpressions: todayExprssions, writableTodayDiary: true)
            HomeScreenView(question: question,
                           todayExpressions: [], writableTodayDiary: false)
        }
    }
}

struct HomeHeaderView: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6, content: {
                Text("김잉크님,")
                Text("오늘의 질문에 답해볼까요?")
            })
            
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
