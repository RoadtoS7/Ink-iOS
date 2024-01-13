//
//  QuestionListScreenView.swift
//  Mureng
//
//  Created by 김수현 on 12/31/23.
//

import SwiftUI

struct QuestionListScreenView: View {
    var questionGroup: [Question]
    
    var body: some View {
        ZStack(alignment: .top, content: {
            gradientBackground
            titleArea
            
            ScrollView {
                VStack {
                    QuestionListHeaderView()
                        .offset(y: 12.0)
                    QuestionListView(questionGroup: questionGroup)
                        .offset(y: 28.0)
                }
                .padding(.bottom, 28.0)
                .padding(.horizontal, 20.0)
                .background(Colors.Neutral
                    .Container
                    .primary
                    .swiftUIColor)
                .clipShape(RoundedRectangle(cornerRadius: 12.0))
                .padding(.top, 292.0)
            }
            .onAppear {
                UIScrollView.appearance().bounces = false
            }
            .onDisappear {
                UIScrollView.appearance().bounces = true
            }
        })
        .ignoresSafeArea()
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
}

#Preview {
    QuestionListScreenView(questionGroup: previewQuestionGroup)
}
