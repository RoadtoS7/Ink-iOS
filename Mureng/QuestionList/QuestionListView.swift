//
//  QuestionListView.swift
//  Mureng
//
//  Created by 김수현 on 12/31/23.
//

import SwiftUI

struct QuestionListView: View {
    let questionGroup: [Question]
    
    var body: some View {
        LazyVStack(spacing: 28, content: {
            ForEach(questionGroup) { question in
                QuestionListCellView(question: question)
            }
        })
        .background(Colors.Neutral
            .Container
            .primary
            .swiftUIColor)
    }
}

#Preview {
    QuestionListView(questionGroup: previewQuestionGroup)
}
