//
//  ArrowCheckBoxView.swift
//  Mureng
//
//  Created by 김수현 on 2023/05/05.
//

import UIKit

class ArrowCheckBoxView: UIView {
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
        stackView.distribution = .fill
        stackView.alignment = .center
        addSubview(stackView)
        let tapRecognizer = TapGestureRecognizerUsingClosure { [unowned self] in
            self.checkButton.isSelected.toggle()
        }
        stackView.addGestureRecognizer(tapRecognizer)
        stackView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
        let checkButton: CheckButton = .init()
        checkButton.setContentHuggingPriority(.required, for: .horizontal)
        checkButton.setContentHuggingPriority(.required, for: .vertical)
        checkButton.isUserInteractionEnabled = false
        checkButton.snp.makeConstraints { make in
            make.width.height.equalTo(24)
        }
        stackView.addArrangedSubview(checkButton)
        self.checkButton = checkButton
        
        let label: UILabel = .init()
        label.font = FontFamily.AppleSDGothicNeo.regular.font(size: 14)
        stackView.addArrangedSubview(label)
        self.label = label
        
        let arrowImageView: UIImageView = .init(image: Images.iconsChevronMore24.image)
        arrowImageView.setContentHuggingPriority(.required, for: .horizontal)
        arrowImageView.setContentHuggingPriority(.required, for: .vertical)
        arrowImageView.snp.makeConstraints { make in
            make.width.height.equalTo(24)
        }
        stackView.addArrangedSubview(arrowImageView)
    }
}
