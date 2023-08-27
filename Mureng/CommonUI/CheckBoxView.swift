//  CheckBoxView.swift
//  Mureng
//
//  Created by 김수현 on 2023/04/23.
//

import UIKit
import SnapKit
import SwiftUI

struct CheckBox: View {
    private let height: CGFloat = 24
    @Binding var checked: Bool
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                Button(action: {
                    
                }, label: {
                    
                })
            }
            .frame(width: geometry.size.width, height: height)
        }
    }
}

class CheckBoxView: UIView {
    typealias CheckAction = () -> Void
    private var checkButton: CheckButton!
    private var checkAction: CheckAction?
    private var label: UILabel!
    var isEnabled: Bool {
        get {
            checkButton.isEnabled
        }
        set {
            checkButton.isEnabled = newValue
        }
    }
    @objc dynamic var isSelected: Bool = false
    
    convenience init(title: String, checkAction: CheckAction? = nil) {
        self.init(frame: .zero)
        self.checkAction = checkAction
        translatesAutoresizingMaskIntoConstraints = false
        label.text = title
        layoutIfNeeded()
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
//        addCheckButtonAction()
    }
    
//    private func addCheckButtonAction(_ checkAction: CheckAction? = nil) {
//        checkButton.addTouchAction { checkButton in
//            checkButton.isSelected.toggle()
//            checkAction?()
//        }
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initViews() {
        let stackView: UIStackView = .init()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        let tapRecognizer = TapGestureRecognizerUsingClosure { [unowned self] in
            self.checkButton.isSelected.toggle()
            self.checkAction?()
        }
        stackView.addGestureRecognizer(tapRecognizer)
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
        checkButton.isUserInteractionEnabled = false
        stackView.addArrangedSubview(checkButton)
        self.checkButton = checkButton
        
        let label: UILabel = .init()
        label.font = FontFamily.AppleSDGothicNeo.regular.font(size: 14)
        stackView.addArrangedSubview(label)
        self.label = label
    }
}
