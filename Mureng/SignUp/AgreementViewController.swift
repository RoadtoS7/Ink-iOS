//
//  AgreementViewController.swift
//  Mureng
//
//  Created by nylah.j on 2023/04/08.
//

import UIKit
import SnapKit

class AgreementViewController: UIViewController {
    private enum Constant {
        static let next = "다음"
        static let title = "먼저 이용약관을 읽고\n동의해주세요."
        static let allAgreeText = "모든 약관을 읽었으며, 이에 동의해요."
        static let agreeServiceText = "[필수] 서비스 이용약관 동의"
        static let agreePrivacyText = "[필수] 서비스 이용약관 동의"
    }
    
    private let nextButton: ButtonSolid48 = .init(text: Constant.next)

    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
    }
}

extension AgreementViewController {
    private func initViews() {
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
        
        // MARK: - 다음 버튼
        view.addSubview(nextButton)
        nextButton.isEnabled = false
        nextButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(48)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}
