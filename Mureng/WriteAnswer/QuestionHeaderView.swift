//
//  QuestionHeaderView.swift
//  Mureng
//
//  Created by 김수현 on 2/6/24.
//

import UIKit

class QuestionHeaderView: UIView {
    private var rootStackView: UIStackView!
    
    private let questionMark: UILabel = {
        $0.text = "Q."
        $0.font = FontFamily.NanumMyeongjo.extraBold.font(size: 24.0)
        return $0
    }(UILabel())
    
    private let translationLabel: UILabel = {
        $0.font = FontFamily.Pretendard.regular.font(size: 14)
        $0.textColor = Colors.Grey.dark1.color
        return $0
    }(UILabel())
    
    private let questionLabel: UILabel = {
        $0.font = FontFamily.NanumMyeongjo.extraBold.font(size: 28)
        return $0
    }(UILabel())
    
    private var question: Question? {
        didSet {
            questionLabel.text = question?.content
            translationLabel.text = question?.koreanContent
            layoutIfNeeded()
            invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        layoutSubviews()
        return CGSize(width: UIView.noIntrinsicMetric, height: rootStackView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height)
    }
    
    init(question: Question) {
        self.question = question
        super.init(frame: .zero)
        initLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func set(question: Question) {
        self.question = question
    }
    
    func addSubviews() {
        let stackView: UIStackView = .init()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16.0
        
        stackView.addArrangedSubview(questionLabel)
        stackView.addArrangedSubview(translationLabel)
        
        questionLabel.text = question?.content
        translationLabel.text = question?.koreanContent
        
        let hStackView: UIStackView = .init()
        hStackView.frame = bounds
        hStackView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        hStackView.axis = .horizontal
        hStackView.distribution = .fillProportionally
        hStackView.alignment = .top
        rootStackView = hStackView
        
        hStackView.addArrangedSubview(questionMark)
        hStackView.addArrangedSubview(stackView)
        addSubview(hStackView)
    }
    
    func initLayout() {
        backgroundColor = .white
        addSubviews()
        
        print("$$ questionLable: ", questionLabel.contentHuggingPriority(for: .horizontal) == .defaultHigh)
        questionLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
}
