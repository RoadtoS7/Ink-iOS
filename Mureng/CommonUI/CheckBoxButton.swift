//
//  CheckBox.swift
//  Mureng
//
//  Created by 김수현 on 2023/04/22.
//

import UIKit
import SwiftUI


class CheckButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setImage(Images.checkboxOff24.image, for: .normal)
        setImage(Images.checkboxOn24.image, for: .selected)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

