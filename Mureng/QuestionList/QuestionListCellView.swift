//
//  QuestionListCellView.swift
//  Mureng
//
//  Created by 김수현 on 12/31/23.
//

import SwiftUI


struct QuestionListCellView: View {
    let question: Question
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 16, content: {
            HStack(alignment: .firstTextBaseline,
                   spacing: 8) {
                Image(.question)
                    .padding(.top, 5)
                textArea
            }
            
            Image(.commentCount)
                .resizable()
                .frame(width: 44, height: 28)
        })
    }
               
    var textArea: some View {
        VStack {
            Text(question.content)
                .font(FontFamily.Pretendard
                    .medium
                    .swiftUIFont(fixedSize: 18)
                )
                .foregroundStyle(Colors.Neutral.Label.secondary.swiftUIColor)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(question.koreanContent)
                .font(FontFamily.Pretendard
                    .light
                    .swiftUIFont(fixedSize: 14)
                )
                .foregroundStyle(Colors.Neutral.Label.quaternary.swiftUIColor)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        
    }
}

#Preview {
    let question: Question = .init(id: 0, content: "What are the habits you want to build? ", koreanContent: "어떤 습관을 만들고 싶나요?")
    return QuestionListCellView(question: question)
}
