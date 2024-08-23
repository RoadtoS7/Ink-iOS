//
//  MurengApp.swift
//  Mureng
//
//  Created by 김수현 on 6/23/24.
//

import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth

@main
struct InkApp: App {
    private let nativeAppKey: String = "81e6d349cfd84771e8e20876e041773c"
    private let service: AuthenticationService = DefaultAuthService()
    
    init() {
        KakaoSDK.initSDK(appKey: nativeAppKey)
    }
    
    var body: some Scene {
        WindowGroup {
            Group {
//                if Login.shared.hasUserLogined() {
//                    HomeScreenView()
//                } else {
                    EntryView(authenticationService: service)
//                }
            }
            .onOpenURL(perform: { url in
                if (AuthApi.isKakaoTalkLoginUrl(url)) {
                    AuthController.handleOpenUrl(url: url)
                }
            })
        }
    }
}
