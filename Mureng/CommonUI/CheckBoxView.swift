//
//  CheckBoxView.swift
//  Mureng
//
//  Created by 김수현 on 2023/04/23.
//

import UIKit
import SnapKit

class CheckBoxView: UIView {
    private var checkButton: CheckButton!
    private var label: UILabel!
    
    convenience init(title: String) {
        self.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        label.text = title
        layoutIfNeeded()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
        checkButton.addTouchAction { checkButton in
            checkButton.isSelected.toggle()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initViews() {
        let stackView: UIStackView = .init()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
        let checkButton: CheckButton = .init()
        checkButton.setContentHuggingPriority(.required, for: .horizontal)
        checkButton.setContentHuggingPriority(.required, for: .vertical)
        checkButton.snp.makeConstraints { make in
            make.width.height.equalTo(24)
        }
        stackView.addArrangedSubview(checkButton)
        
        self.checkButton = checkButton
        
        let label: UILabel = .init()
        label.font = FontFamily.AppleSDGothicNeo.regular.font(size: 14)
        stackView.addArrangedSubview(label)
        self.label = label
        
    }
}
