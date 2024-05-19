//
//  UIScrollView+.swift
//  Mureng
//
//  Created by 김수현 on 3/1/24.
//

import UIKit

extension UIEdgeInsets {
    init(top: CGFloat) {
        self = .init(top: top, left: .zero, bottom: .zero, right: .zero)
    }
    
    init(bottom: CGFloat) {
        self = .init(top: .zero, left: .zero, bottom: bottom, right: .zero)
    }
    
    init(left: CGFloat) {
        self = .init(top: .zero, left: left, bottom: .zero, right: .zero)
    }
    
    init(right: CGFloat) {
        self = .init(top: .zero, left: .zero, bottom: .zero, right: right)
    }
    
    init(horizontal: CGFloat) {
        self = .init(top: .zero, left: horizontal, bottom: .zero, right: horizontal)
    }
}
