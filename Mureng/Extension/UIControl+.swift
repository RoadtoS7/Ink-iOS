//
//  UIControl+.swift
//  Mureng
//
//  Created by 김수현 on 2023/04/22.
//

import UIKit

extension UIControl {
    func addTouchAction(_ handler: @escaping (Self) -> Void) {
        addAction(.init(handler: { _ in
            handler(self as! Self)
        }), for: .touchUpInside)
    }
}
