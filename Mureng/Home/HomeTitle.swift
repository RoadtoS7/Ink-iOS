//
//  HomeTitle.swift
//  Mureng
//
//  Created by nylah.j on 2023/08/23.
//

import SwiftUI

struct HomeTitle: View {
    let nickname: String
    
    var body: some View {
        Text("반가워요, \(nickname)")
//            .font(
////                Font.custom("Pretendard", size: 20)
////                    .weight(.medium)
//            )
            .foregroundColor(Color("blue-500"))
            .frame(maxWidth: .infinity, alignment: .topLeading)
    }
}

#Preview {
    HomeTitle(nickname: "잉크")
}
