//
//  HomeScreenView.swift
//  Mureng
//
//  Created by 김수현 on 2023/09/03.
//

import SwiftUI

struct HomeScreenView: View {
    let question: Question
    var body: some View {
        VStack {
            HomeHeaderView()
            QuestionCardView(question: question, refreshAction: {})
            Button("글쓰기", action: {
                
            })
            .buttonStyle(ButtonSoild48Style())
            .frame(height: 48)
            Text("오늘의 표현")
                .font(FontFamily.Pretendard.regular.swiftUIFont(size: 16))
            
                
        }
        .padding(.horizontal, 24)
    }
}

struct HomeScreenView_Previews: PreviewProvider {
    private static var question: Question = .init(id: 0, content: "What do you want?", koreanContent: "어떤 습관을 만들고 싶나요?")
    static var previews: some View {
        HomeScreenView(question: question)
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
