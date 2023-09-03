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

struct QuestionCardView: View {
    let question: Question
    let refreshAction: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            Text(question.content)
                .font(FontFamily.NanumMyeongjo.regular.swiftUIFont(size: 32)
                    .weight(.heavy)
                )
                
            Text(question.koreanContent)
                .font(FontFamily.Pretendard.regular.swiftUIFont(size: 16))
            
            HStack {
                Spacer()
                Button(action: {
                    refreshAction()
                }, label: {
                    Images.iconsRefresh.swiftUIImage
                })
                .frame(width: 32, height: 32)
            }
        }
        .multilineTextAlignment(.center)
        .padding(.horizontal, 20)
        .padding(.vertical, 78)
        .background(Colors.white.swiftUIColor)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    private static let question: Question = .init(id: 0, content: "What do you want?", koreanContent: "어떤 습관을 만들고 싶나요?")
    static var previews: some View {
        QuestionCardView(question: question, refreshAction: {})
    }
}
