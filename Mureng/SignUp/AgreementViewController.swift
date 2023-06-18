//
//  AgreementViewController.swift
//  Mureng
//
//  Created by nylah.j on 2023/04/08.
//

import UIKit
import SnapKit
import Combine
import ComposableArchitecture

struct Agreement: Equatable {
    let text: String
    
    struct State: Equatable, Identifiable {
        let id = UUID()
        var text: String
        var agreed: Bool = false
    }
    
    enum Action: Equatable {
        case agree
        case disagree
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
      switch action {
      case .agree:
          state.agreed = true
          return .none
      case .disagree:
          state.agreed = false
          return .none
      }
    }
}



struct AgreementChecker: ReducerProtocol {
    struct State: Equatable, Identifiable {
        let id = UUID()
        var agreedService: Bool
        var agreedPrivacy: Bool
        var agreedAll: Bool
        var nextButtonActive: Bool {
            agreedAll
        }
    }
    
    enum Action: Equatable {
        case agreeAllButtonTapped
        case agreeServiceButtonTapped
        case agreePrivacyButtonTapped
    }
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .agreeAllButtonTapped:
                state.agreedAll.toggle()
                state.agreedService = state.agreedAll
                state.agreedPrivacy = state.agreedAll
                return .none
            case .agreeServiceButtonTapped:
                state.agreedService.toggle()
                state.agreedAll = state.agreedService && state.agreedService
                return .none
            case .agreePrivacyButtonTapped:
                state.agreedPrivacy.toggle()
                state.agreedAll = state.agreedService && state.agreedService
                return .none
            }
        }
    }
}

class Agreements {
    let value: [Agreement]
    
    var last: Agreement? {
        value.last
    }
    
    subscript(_ index: Int) -> Agreement? {
        value[index]
    }
    
    init(_ value: [Agreement]) {
        self.value = value
    }
    
    func agree() {
        
    }
    
    func disagree() {
        
    }
}

class AgreementViewModel {
    @Published var agreements: Agreements = .init([
        Agreement(text: "[필수] 서비스 이용약관 동의"),
        Agreement(text: "[필수] 개인정보 수집/이용 동의")
    ])
}

class AgreementViewController: UIViewController {
    private let viewModel: AgreementViewModel
    var cancellables: Set<AnyCancellable> = []
    
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
    }
}

extension AgreementViewController {
    private func initViews() {
        view.backgroundColor = .white
        
        // MARK: - titleLable
        let titleLabel: UILabel = .init()
        titleLabel.text = Constant.title
        titleLabel.font = FontFamily.OmyuPretty.regular.font(size: 30)
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
        
        // MARK: - 각 약관
        viewModel.$agreements
            .sink { agreements in
                agreements.value.forEach { state in
                    let agreementView = ArrowCheckBoxView(title: state.text)
                    stackView.addArrangedSubview(agreementView)
                    agreementView.snp.makeConstraints { make in
                        make.height.equalTo(24)
                        make.width.equalToSuperview().offset(-32)
                    }
                    
                    if state != agreements.last {
                        stackView.setCustomSpacing(16, after: agreementView)
                    }
                }
            }.store(in: &self.cancellables)
        
        // MARK: - 다음 버튼
        view.addSubview(nextButton)
//        nextButton.isEnabled = false
        nextButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(48)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        nextButton.addTouchAction { _ in
            self.navigationController?.pushViewController(PutUserNicknameViewController(), animated: true)
        }
    }
}
