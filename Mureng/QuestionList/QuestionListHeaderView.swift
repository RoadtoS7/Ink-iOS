//
//  QuestionListView.swift
//  Mureng
//
//  Created by 김수현 on 12/30/23.
//

import SwiftUI

protocol QuestionSort {
    
}

struct LatestQuestionSort: QuestionSort {
    
}

struct LikeQuestionSort: QuestionSort {
    
}

struct QuestionSortToggle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        let title: String = configuration.isOn ? "인기순" : "최신순"
        
        HStack(spacing: 8, content: {
            Text(title)
            Image(.chevron24)
        })
        .onTapGesture {
            configuration.isOn.toggle()
        }
    }
}

struct QuestionListHeaderView: View {
    @State var questionCount: Int = 123
    var questionCountText: String {
        String(format: StringRes.questionListCount, questionCount)
    }
    @State var latestSorted: Bool = false
    
    @State var questionSort: QuestionSort = LikeQuestionSort()
    
    var body: some View {
        HStack(content: {
            Text(questionCountText)
            
            Spacer()
            
            Toggle("정렬", isOn: $latestSorted)
                .toggleStyle(QuestionSortToggle())
        })
    }
}

#Preview {
    QuestionListHeaderView()
}
