//
//  QuestionCard.swift
//  Mureng
//
//  Created by 김수현 on 2023/08/27.
//

import SwiftUI

struct Question {
    let id: Int
    let content: String
    let koreanContent: String
}

struct QuestionCard: View {
    let question: Question
    var body: some View {
        VStack {
            Text(question.content)
            Text(question.koreanContent)
                .font(FontFamily.Pretendard.regular.swiftUIFont(size: 16))
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 78)
        .background(Colors.white.swiftUIColor)
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    private static let question: Question = .init(id: 0, content: "What do you want?", koreanContent: "어떤 습관을 만들고 싶나요?")
    static var previews: some View {
        QuestionCard(question: question)
    }
}
