//
//  HomeHeader.swift
//  Mureng
//
//  Created by nylah.j on 2023/08/23.
//

import SwiftUI

struct HomeHeader: View {
    let nickname: String
    let imageUrl: String
    
    var body: some View {
        HStack(alignment: .center, spacing: 28) {
            HomeTitle(nickname: nickname)
            HomeProfileImage(imageUrl: imageUrl)
        }
        .padding(0)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct HomeHeader_Preview: PreviewProvider {
    static var previews: some View {
        HomeHeader(nickname: "잉크", imageUrl: "")
    }
}
