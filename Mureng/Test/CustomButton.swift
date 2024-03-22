//
//  CustomButton.swift
//  Mureng
//
//  Created by 김수현 on 3/22/24.
//

import Foundation
import UIKit

final class DictionaryButton: UIButton {
    override var intrinsicContentSize: CGSize {
        CGSize(width: 56.0, height: 56.0)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureButton()
    }
    
    private func configureButton() {
        setImage(UIImage(named: "dictionary"), for: .normal)
        backgroundColor = Colors.Neutral.Container.secondary.color
        
        layer.cornerRadius = intrinsicContentSize.height / 2.0
        layer.borderWidth = 1.0
        layer.borderColor = Colors.Greyscale.greyscale200.color.cgColor
        
        addTarget(self, action: #selector(touchDown), for: .touchDown)
        addTarget(self, action: #selector(touchUp), for: [.touchUpInside, .touchDragExit, .touchCancel])
    }
    
    @objc private func touchDown() {
        backgroundColor = UIColor.gray
    }
    
    @objc private func touchUp() {
        backgroundColor = Colors.Neutral.Container.secondary.color
    }
}
