//
//  ScrollViewPreferenceKey.swift
//  Mureng
//
//  Created by 김수현 on 1/14/24.
//

import SwiftUI

struct ScrollOffsetKey: PreferenceKey {
    typealias Offset = CGFloat

    static var defaultValue: Offset = .zero

    static func reduce(value: inout Offset, nextValue: () -> Offset) {
        value += nextValue()
        // value가 inout이기 때문에 value가 변하면 자동으로 반영된다.
        // value 값이 변하면 onPreferenceChange에서 확인할 수 있다.
        // value 값을 수정하는 연산을 해야 계산을 했다. 변형을 했다. 인식이 된다.
    }
}
