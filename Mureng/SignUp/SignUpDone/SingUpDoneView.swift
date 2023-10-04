//
//  SingUpDoneView.swift
//  Mureng
//
//  Created by nylah.j on 2023/05/24.
//

import SwiftUI

struct SingUpDoneView: View {
    @State var nextButtonTapped: Int?
    
    var body: some View {
            VStack {
                Spacer()
                
                VStack(spacing: 4) {
                    Image(uiImage: Images.logoDark112.image)
                        .padding([.bottom], 20)
                    Text("준비를 마쳤어요!")
                        .font(FontFamily.OmyuPretty.regular.swiftUIFont(size: 28))
                    Text("매일 1개의 질문에 답변해봐요.")
                }
                
                Spacer()
                
                NavigationLink("시작하기",
                               destination: { HomeScreenView() })
                .frame(height: 48)
                .buttonStyle(ButtonSoild48Style())
            }
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationBarBackButtonHidden(true)
    }
}

struct SingUpDoneView_Previews: PreviewProvider {
    static var previews: some View {
        SingUpDoneView()
    }
}
