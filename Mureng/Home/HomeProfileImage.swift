//
//  HomeProfileImage.swift
//  Mureng
//
//  Created by nylah.j on 2023/08/23.
//

import SwiftUI

struct HomeProfileImage: View {
    // TODO: 이미지 로딩 처리
    let imageUrl: String
    
    var body: some View {
        Image("graphic")
        .frame(width: 48, height: 48)
        // TODO: 컬러 수정 grey/light-3-bg, divider
        .background(Color(red: 0.89, green: 0.89, blue: 0.89))
        .clipShape(Circle())
        
    }
}

#Preview {
    HomeProfileImage(imageUrl: "")
}
