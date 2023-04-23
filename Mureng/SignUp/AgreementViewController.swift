//
//  AgreementViewController.swift
//  Mureng
//
//  Created by nylah.j on 2023/04/08.
//

import UIKit
import SnapKit

class CheckBoxView: UIView {
    private var checkButton: CheckButton!
    private var label: UILabel!
    
    init(title: String) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        initViews()
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

class AgreementViewController: UIViewController {
    private enum Constant {
        static let title = "먼저 이용약관을 읽고\n동의해주세요."
        static let allAgreeText = "모든 약관을 읽었으며, 이에 동의해요."
        static let agreeServiceText = "[필수] 서비스 이용약관 동의"
        static let agreePrivacyText = "[필수] 서비스 이용약관 동의"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // MARK: - titleLable
        let titleLabel: UILabel = .init()
        titleLabel.text = Constant.title
        titleLabel.font = FontFamily.LeeSeoyun.regular.font(size: 30)
        titleLabel.numberOfLines = 0
        view.addSubview(titleLabel)
        titleLabel.setContentHuggingPriority(.required, for: .horizontal)
        titleLabel.setContentHuggingPriority(.required, for: .vertical)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(88)
        }
        
        // MARK: - stackView
        let stackView: UIStackView = .init()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        stackView.layer.cornerRadius = 10
        stackView.layer.borderColor = Colors.lightestBg3.color.cgColor
        stackView.layer.borderWidth = 1
        stackView.layoutMargins = .init(top: 24, left: 0, bottom: 28, right: 0)
        stackView.isLayoutMarginsRelativeArrangement = true
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(titleLabel.snp.bottom).offset(60)
        }
        
        // MARK: - agreeAllCheckBox
        let agreeAllCheckBox: CheckBoxView = .init(title: Constant.allAgreeText)
        stackView.addArrangedSubview(agreeAllCheckBox)
        agreeAllCheckBox.snp.makeConstraints { make in
            make.height.equalTo(24)
            make.width.equalToSuperview().offset(-32)
        }
        
        stackView.setCustomSpacing(24, after: agreeAllCheckBox)
        
        // MARK: - line
        let line: UIView = .init()
        line.backgroundColor = Colors.lightestBg3.color
        stackView.addArrangedSubview(line)
        line.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.width.equalToSuperview()
        }
        
        stackView.setCustomSpacing(24, after: line)

        // MARK: - Agree Service
        let agreeServiceView: ArrowCheckBoxView = .init(title: Constant.agreeServiceText)
        stackView.addArrangedSubview(agreeServiceView)
        agreeServiceView.snp.makeConstraints { make in
            make.height.equalTo(24)
            make.width.equalToSuperview().offset(-32)
        }

        stackView.setCustomSpacing(16, after: agreeServiceView)
        
        // MARK: - Agree Privacy
        let agreePrivacy: ArrowCheckBoxView = .init(title: Constant.agreePrivacyText)
        stackView.addArrangedSubview(agreePrivacy)
        agreePrivacy.snp.makeConstraints { make in
            make.height.equalTo(24)
            make.width.equalToSuperview().offset(-32)
        }
    }
}
