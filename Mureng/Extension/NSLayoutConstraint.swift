//
//  NSLayoutConstraint.swift
//  Mureng
//
//  Created by 김수현 on 2/4/24.
//

import UIKit

extension NSLayoutConstraint {
    func settingPriority(_ priority: UILayoutPriority) -> NSLayoutConstraint {
        self.priority = priority
        return self
    }
}
