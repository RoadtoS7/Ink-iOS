//
//  ButtonSolid48.swift
//  Mureng
//
//  Created by 김수현 on 2023/05/05.
//

import UIKit

class ButtonSolid48: UIButton {
    override var isEnabled: Bool {
        didSet {
            isEnabled ? setEnabledColor() : setDisabledColor()
        }
    }
    
    convenience init(text: String) {
        self.init(frame: .zero)
        titleLabel?.text = text
        setTitle(text, for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ButtonSolid48 {
    private func initViews() {
        setTitleColor(Colors.Grey.grey1Disabled1.color, for: .disabled)
        setTitleColor(Colors.white.color, for: .normal)
        titleLabel?.font = FontFamily.AppleSDGothicNeo.regular.font(size: 16)
        titleLabel?.textAlignment = .center
        layer.cornerRadius = 24
        clipsToBounds = true
    }
    
    private func setEnabledColor() {
        backgroundColor = Colors.black.color
    }
    
    private func setDisabledColor() {
        backgroundColor = Colors.Grey.greylight0.color
    }
}


