//
//  SingUpDoneView.swift
//  Mureng
//
//  Created by nylah.j on 2023/05/24.
//

import SwiftUI

struct SingUpDoneView: View {
    var body: some View {
        VStack {
            Image(uiImage: Images.imgSplashLogo.image)
            Text("준비를 마쳤어요!")
            Text("매일 1개의 질문에 답변해봐요.")
        }
        
    }
}

struct SingUpDoneView_Previews: PreviewProvider {
    static var previews: some View {
        SingUpDoneView()
    }
}
