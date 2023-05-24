//
//  SingUpDoneView.swift
//  Mureng
//
//  Created by nylah.j on 2023/05/24.
//

import SwiftUI

struct SingUpDoneView: View {
    var body: some View     {
        VStack(spacing: 4) {
            Image(uiImage: Images.logoDark112.image)
                .padding([.bottom], 20)
            Text("준비를 마쳤어요!")
                .font(.custom(FontFamily.OmyuPretty.regular.name, size: 28))
            Text("매일 1개의 질문에 답변해봐요.")
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct SingUpDoneView_Previews: PreviewProvider {
    static var previews: some View {
        SingUpDoneView()
    }
}
