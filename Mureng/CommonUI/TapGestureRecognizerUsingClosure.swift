//
//  TapGestureRecognizerUsingClosure.swift
//  Mureng
//
//  Created by 김수현 on 2023/05/06.
//

import UIKit

final class TapGestureRecognizerUsingClosure: UITapGestureRecognizer {
    private var action: () -> Void

    init(action: @escaping () -> Void) {
        self.action = action
        super.init(target: nil, action: nil)
        self.addTarget(self, action: #selector(execute))
    }

    @objc private func execute() {
        action()
    }
}
