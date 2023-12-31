//
//  Typo.swift
//  Mureng
//
//  Created by 김수현 on 12/31/23.
//

import SwiftUI

extension SwiftUI.Font {
    private static let nanumMyeonJoRegular: String = "NanumMyeongjo"
    private static let nanumMyeonJoBold: String = "NanumMyeongjoBold"
    private static let nanumMyeonJoExtraBold: String = "NanumMyeongjoExtraBold"
    private static let pretendardRegular: String = "Pretendard-Regular"
    private static let pretendardSemiBold: String = "Pretendard-SemiBold"
    
    // title
    static let title20R: Self = .custom(pretendardRegular, fixedSize: 20)
    static let title18R: Self = .custom(pretendardRegular, fixedSize: 18)
    static let title16SB: Self = .custom(pretendardSemiBold, fixedSize: 20)
    
    // body
    static let body18R: Self = .custom(pretendardRegular, fixedSize: 18)
    static let body18RSub: Self = .custom(pretendardRegular, fixedSize: 18)
    static let body16SB: Self = .custom(pretendardSemiBold, fixedSize: 16)
    static let body16R: Self = .custom(pretendardRegular, fixedSize: 16)
    static let body14R: Self = .custom(pretendardRegular, fixedSize: 14)
    
    // label
    static let label18R: Self = .custom(pretendardRegular, fixedSize: 18)
    static let label16R: Self = .custom(pretendardRegular, fixedSize: 16)
    static let label14R: Self = .custom(pretendardRegular, fixedSize: 14)
    static let label12R: Self = .custom(pretendardRegular, fixedSize: 12)
}
