//
//  UIControl+.swift
//  Mureng
//
//  Created by 김수현 on 2023/04/22.
//

import UIKit

extension UIControl {
    func addAction(for event: Event, _ handler: (UIAction) -> Void) {
        addAction(.init(handler: { action in
            handler(action)
        }), for:   event)
    }
}
