//
//  AgreementViewController.swift
//  Mureng
//
//  Created by nylah.j on 2023/04/08.
//

import UIKit
import SnapKit
import Combine

class Agreement: Equatable {
    static func == (lhs: Agreement, rhs: Agreement) -> Bool {
        return lhs.text == rhs.text
        && lhs.agreed == rhs.agreed
    }
    
    let text: String
    @Published var agreed: Bool = false
    
    init(text: String) {
        self.text = text
    }
    
    func agree() {
        self.agreed = true
    }
    
    func disagree() {
        self.agreed = false
    }
    
    struct State: Equatable, Identifiable {
        let id = UUID()
        var text: String
        var agreed: Bool = false
    }
    
    enum Action: Equatable {
        case agree
        case disagree
    }
}

class Agreements {
    @Published var value: [Agreement]
    @Published var agreedAll: Bool = false
    
    var last: Agreement? {
        value.last
    }
    
    subscript(_ index: Int) -> Agreement? {
        value[index]
    }
    
    init(_ value: [Agreement]) {
        self.value = value
    }
    
    func agree(_ agreement: Agreement) {
        agreement.agree()
        checkAgreedAll()
    }
    
    func disagree(_ agreement: Agreement) {
        agreement.disagree()
        checkAgreedAll()
    }
    
    func agreeAll() {
        value.forEach { $0.agree() }
        checkAgreedAll()
    }
    
    func disagreeAll() {
        value.forEach { $0.disagree() }
        checkAgreedAll()
    }
    
    private func checkAgreedAll() {
        agreedAll = value.allSatisfy { $0.agreed == true}
    }
}

class AgreementViewModel {
    @Published var agreements: Agreements = .init([
        Agreement(text: "[필수] 서비스 이용약관 동의"),
        Agreement(text: "[필수] 개인정보 수집/이용 동의")
    ])
    
    var agreedAll: some Publisher<Bool, Never> {
        agreements.$agreedAll
    }
    
    func agree(_ agree: Agreement) {
        agreements.agree(agree)
    }
    
    func disagree(_ agreement: Agreement) {
        agreements.disagree(agreement)
    }
    
    func toggleAllAgreed() {
        if agreements.agreedAll {
            agreements.disagreeAll()
            return
        }
        agreements.agreeAll()
    }
}

class AgreementViewController: UIViewController {
    private let viewModel: AgreementViewModel
    private var cancellables: Set<AnyCancellable> = []
    private var agreeAllCheckBox: CheckBoxView!
    private var agreementCheckBoxes: [ArrowCheckBoxView] = []
    
    init(viewModel: AgreementViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private enum Constant {
        static let next = "다음"
        static let title = "먼저 이용약관을 읽고\n동의해주세요."
        static let allAgreeText = "모든 약관을 읽었으며, 이에 동의해요."
    }
    
    private let nextButton: ButtonSolid48 = .init(text: Constant.next)

    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        bind()
    }
}

extension AgreementViewController {
    private func initViews() {
        view.backgroundColor = .white
        
        // MARK: - titleLable
        let titleLabel: UILabel = .init()
        titleLabel.text = Constant.title
        titleLabel.font = FontFamily.Pretendard.regular.font(size: 30)
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
        let agreeAllCheckBox: CheckBoxView = .init(title: Constant.allAgreeText, checkAction: { [weak self] in
            self?.viewModel.toggleAllAgreed()
        })
        stackView.addArrangedSubview(agreeAllCheckBox)
        agreeAllCheckBox.snp.makeConstraints { make in
            make.height.equalTo(24)
            make.width.equalToSuperview().offset(-32)
        }
        self.agreeAllCheckBox = agreeAllCheckBox
        
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
        
        // MARK: - 각 약관
        viewModel.$agreements
            .sink { [weak self] agreements in
                agreements.value.forEach { state in
                    let agreementView = ArrowCheckBoxView(agreement: state)
                    stackView.addArrangedSubview(agreementView)
                    agreementView.snp.makeConstraints { make in
                        make.height.equalTo(24)
                        make.width.equalToSuperview().offset(-32)
                    }
                    
                    if state != agreements.last {
                        stackView.setCustomSpacing(16, after: agreementView)
                    }
                    self?.agreementCheckBoxes.append(agreementView)
                }
            }.store(in: &self.cancellables)
        
        // MARK: - 다음 버튼
        view.addSubview(nextButton)
        nextButton.isEnabled = false
        nextButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(48)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        nextButton.addTouchAction { _ in
            self.navigationController?.pushViewController(PutUserNicknameViewController(), animated: true)
        }
    }
    
    private func bind() {
        viewModel.agreedAll
            .sink { [weak self] agreedAll in
                self?.agreeAllCheckBox.isSelected = agreedAll
                self?.agreementCheckBoxes.forEach { $0.isSelected = agreedAll }
                self?.nextButton.isEnabled = agreedAll
            }.store(in: &cancellables)
    }
}
