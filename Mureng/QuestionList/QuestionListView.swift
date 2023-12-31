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
        LazyVStack(content: {
            ForEach(questionGroup) { question in
                QuestionListCellView(question: question)
            }
        })
        .padding(.horizontal, 20)
    }
}

#Preview {
    QuestionListView(questionGroup: previewQuestionGroup)
}
