//
//  AgreementViewController.swift
//  Mureng
//
//  Created by nylah.j on 2023/04/08.
//

import UIKit
import SnapKit

class CheckBoxView: UIView {
    private let checkButton: UIButton!
    private var label: UILabel!
    
    convenience init(title: String) {
        self.init(frame: .zero)
        label.text = title
        layoutIfNeeded()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
        checkButton.addTarget(self, action: #selector(toggleSelected), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initViews()
        checkButton.addTarget(self, action: #selector(toggleSelected), for: .touchUpInside)
    }
    
    @objc private func toggleSelected() {
        checkButton.isSelected.toggle()
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
        
        let checkButton: UIButton = .init()
        stackView.addArrangedSubview(checkButton)
        checkButton.setImage(Images.checkboxOn24.image, for: .selected)
        checkButton.setImage(Images.checkboxOff24.image, for: .normal)
        checkButton.setContentHuggingPriority(.required, for: .horizontal)
        checkButton.snp.makeConstraints { make in
            make.width.height.equalTo(24)
        }
        self.checkButton = checkButton
        
        let label: UILabel = .init()
        stackView.addArrangedSubview(label)
        self.label = label
    }
}

class ArrowCheckBoxView: UIView {
    private var title: String?
    
    init(title: String) {
        self.title = title
        super.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let stackView: UIStackView = .init()
        stackView.axis = .horizontal
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
        let checkBoxView: CheckBoxView = .init(title: title ?? "")
        stackView.addArrangedSubview(checkBoxView)
        
        let arrowImageView = UIImageView(image: Images.chevronMore24.image)
        arrowImageView.setContentHuggingPriority(.required, for: .horizontal)
        stackView.addArrangedSubview(arrowImageView)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

class AgreementViewController: UIViewController {
    private enum Constant {
        static let title = "먼저 이용약관을 읽고\n동의해주세요."
        static let allAgreeText = "모든 약관을 읽었으며, 이에 동의해요."
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let titleLabel: UILabel = .init()
        titleLabel.text = Constant.title
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(88)
        }
        
        let stackView: UIStackView = .init()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.layoutMargins = .init(top: 24, left: 0, bottom: 0, right: 0)
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().offset(20)
            make.top.equalTo(titleLabel).offset(60)
        }
        
        let agreeAllCheckBox: CheckBoxView = .init(title: Constant.allAgreeText)
//        stackView.addArrangedSubview(agreeAllCheckBox)
//        stackView.setCustomSpacing(24, after: agreeAllCheckBox)
        
        view.addSubview(agreeAllCheckBox)
        agreeAllCheckBox.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
    }
}
