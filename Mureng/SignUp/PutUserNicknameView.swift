//
//  PutUserNicknameView.swift
//  Mureng
//
//  Created by 김수현 on 2023/05/07.
//

import SwiftUI

struct PutUserNicknameView: View {
    @State var nickname: String = ""
    enum Constant {
        static let title: String = "잉크에서 사용할\n닉네임을 알려주세요."
        
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 48) {
            Text(Constant.title)
                .font(.custom(FontFamily.OmyuPretty.regular.name, size: 22))

            VStack(spacing: 7) {
                TextField("닉네임", text: $nickname)
                Divider()
            }
            Spacer()
            Button("다음") {
                // TODO: 다음
            }
            .frame(maxWidth: .infinity)
        }
        .edgesIgnoringSafeArea(.all)
        .padding(.init(top: 52, leading: 20, bottom: 22, trailing: 20))
    }
}

struct PutUserNicknameView_Previews: PreviewProvider {
    static var previews: some View {
        PutUserNicknameView()
    }
}
