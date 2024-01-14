//
//  ScrollObservableView.swift
//  Mureng
//
//  Created by 김수현 on 1/14/24.
//

import SwiftUI

struct ScrollObservableView: View {
    let viewModel: ScrollObservableViewModel
    
    var body: some View {
        GeometryReader(content: { geometry in
        // geometry.frame = container view의 bounds rectangle 반환
            let offsetY = geometry.frame(in: .global).origin.y
            Color.clear
                .preference(key: ScrollOffsetKey.self, value: offsetY)
                .onAppear(perform: {
                    viewModel.setOriginOffset(offsetY)
                })
        })
        .frame(height: 0)
    }
}

// onAppear 호출 순서로 인해: setOffset(부모뷰) -> setOriginOffset(자식 Color.clear 뷰 호출됨)
// setOffset이 먼저 호출되지 않도록 방어 코드 넣어야함
final class ScrollObservableViewModel: ObservableObject {
    @Published var offsetY: CGFloat = .zero
    var originOffset: CGFloat = .zero
    var originOffsetInitialized: Bool = false
    
    deinit {
        print("$$ deinit ScrollObservableViewModel")
    }
    
    func setOriginOffset(_ offsetY: CGFloat) {
        guard originOffsetInitialized == false else {
            return
        }
        self.originOffset = offsetY
        self.offsetY = offsetY
        originOffsetInitialized = true
    }
    
    func setOffset(_ offsetY: CGFloat) {
        guard originOffsetInitialized else {
            return
        }
        self.offsetY = offsetY
    }
}
