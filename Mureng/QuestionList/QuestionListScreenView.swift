//
//  QuestionListScreenView.swift
//  Mureng
//
//  Created by 김수현 on 12/31/23.
//

import SwiftUI

struct QuestionListScreenView: View {
    @StateObject var scrollObservable: ScrollObservableViewModel = .init()
    
    let questionGroupTopMargin: CGFloat = 292
    
    var questionGroupReachedStatusBar: Bool {
        scrollObservable.offsetY <= -questionGroupTopMargin
    }
    
    var questionGroup: [Question]
    
    var body: some View {
        ZStack(alignment: .top, content: {
            gradientBackground
                .ignoresSafeArea()
            titleArea
            questionGroupScrollView
            if questionGroupReachedStatusBar {
                questionNavigationTitle
            }
        })
        .frame(width: .infinity, height: .infinity)
    }
    
    var titleArea: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(.inkAppIcon)
            Text("Questions")
              .font( .question)
            Text("모든 질문을 모았어요.")
                .font(.questionSubtitle)
        }
        .padding(.horizontal, 20)
        .padding(.top, 88)
        .padding(.bottom, 0)
        .frame(
             maxWidth: .infinity,
             maxHeight: .infinity,
             alignment: .topLeading
       )
        .foregroundStyle(.white)
    }
    
    var gradientBackground: some View {
        LinearGradient(
            stops: [
                Gradient.Stop(color: Color(red: 0.17, green: 0.17, blue: 0.17), location: 0.00),
                Gradient.Stop(color: .black, location: 1.00),
            ],
            startPoint: UnitPoint(x: 0.5, y: 0),
            endPoint: UnitPoint(x: 0.5, y: 1)
        )
    }
    
    var questionGroupScrollView: some View {
        ScrollView {
            ScrollObservableView(viewModel: scrollObservable)
            
            VStack {
                QuestionListHeaderView()
                    .frame(height: 44)
                
                QuestionListView(questionGroup: questionGroup)
                    .offset(y: 28.0)
            }
            .padding(.top, 12.0)
            .padding(.bottom, 28.0)
            .padding(.horizontal, 20.0)
            .background(Colors.Neutral
                .Container
                .primary
                .swiftUIColor)
            .clipShape(RoundedRectangle(cornerRadius: 12.0))
            .padding(.top, 292.0)
        }
        .onPreferenceChange(ScrollOffsetKey.self, perform: { value in
            scrollObservable.setOffset(value)
        })
        .onAppear {
            UIScrollView.appearance().bounces = false
        }
        .onDisappear {
            UIScrollView.appearance().bounces = true
        }
    }
    
    var questionNavigationTitle: some View {
        HStack(content: {
            Text("questions")
                .font(.questionAsNavigationTitle)
                .foregroundStyle(
                    Colors.Neutral
                    .Label
                    .tertiary
                    .swiftUIColor
                )
        })
        .frame(height: 28)
        .padding(.vertical, 8)
        .padding(.horizontal, 20)
        .frame(
             maxWidth: .infinity,
             alignment: .topLeading
        )
        .background(
            Color(red: 0.98, green: 0.98, blue: 0.98).opacity(0.9)
        )
    }
}

#Preview {
    QuestionListScreenView(questionGroup: previewQuestionGroup)
}
