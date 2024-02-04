//
//  EditorViewController.swift
//  Mureng
//
//  Created by 김수현 on 2/3/24.
//

import UIKit

final class ImageSourceSelectionView: UIView {
    private let stackView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        return $0
    }(UIStackView())
    
    private let galleryButton: UIButton = {
        $0.setTitle("앨범", for: .normal)
        $0.setTitleColor(Colors.Greyscale.greyscale800.color, for: .normal)
        return $0
    }(UIButton())
    
    private var appSourcingButton: UIButton = {
        $0.setTitle("배경", for: .normal)
        return $0
    }(UIButton())
    
    init() {
        super.init(frame: .zero)
        initLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initLayout() {
        addSubviews()
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    
    private func addSubviews() {
        self.addSubview(stackView)
        stackView.addArrangedSubview(galleryButton)
        stackView.addArrangedSubview(appSourcingButton)
    }
}

class EditorViewController: UIViewController {
    let questionLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "이것은 영어질문입니다."
        return $0
    }(UILabel())
    
    let textView: UITextView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.bounces = false
        $0.showsVerticalScrollIndicator = false
        return $0
    }(UITextView())
    
    private var textViewHeightConstraint: NSLayoutConstraint?
    
    let imageView: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(named: "logoDark112")
        return $0
    }(UIImageView())
    
    let scrollView: UIScrollView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.bounces = false
        return $0
    }(UIScrollView())
    
    let scrollContentView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .red
        return $0
    }(UIView())
    
    let editorStack: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        $0.distribution = .fill
        $0.alignment = .fill
        return $0
    }(UIStackView())
    
    let imageSourceSelectionView: ImageSourceSelectionView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(ImageSourceSelectionView())
    
    private var textViewHeight: CGFloat = .zero
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        makeTextViewFillHalfOfScrollView()
    }
    
    private func makeTextViewFillHalfOfScrollView() {
        let halfScrollViewHeight = scrollView.frame.height / 2
        textViewHeightConstraint?.constant = halfScrollViewHeight
        self.textViewHeight = halfScrollViewHeight
        
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initLayout()
    }
    
    private func initLayout() {
        view.backgroundColor = .white
        textView.delegate = self
        addSubviews()
        
        NSLayoutConstraint.activate([
            questionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            questionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            questionLabel.topAnchor.constraint(equalTo: view.topAnchor),
        ])
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 20),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            scrollContentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollContentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            scrollContentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            scrollContentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            scrollContentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: scrollContentView.topAnchor),
            textView.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 20),
            textView.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -20),
            
            imageView.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 20),
            imageView.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 20),
            imageView.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -20),
            imageView.bottomAnchor.constraint(equalTo: scrollContentView.bottomAnchor, constant: -20),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ])
        
        textViewHeightConstraint = textView.heightAnchor.constraint(equalToConstant: 40)
        textViewHeightConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            imageSourceSelectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageSourceSelectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageSourceSelectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            imageSourceSelectionView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func addSubviews() {
        view.addSubview(questionLabel)
        view.addSubview(scrollView)
        view.addSubview(imageSourceSelectionView)
        
        scrollView.addSubview(scrollContentView)
        scrollContentView.addSubview(textView)
        scrollContentView.addSubview(imageView)
    }
}

extension EditorViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        adjustTextViewHeight()
    }
    
    private func adjustTextViewHeight() {
        let size = textView.sizeThatFits(CGSize(width: textView.frame.size.width, height: CGFloat.infinity))

        let textViewHeight: CGFloat = size.height > self.textViewHeight ? size.height : self.textViewHeight
        
        textViewHeightConstraint?.constant = textViewHeight
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
}

extension NSLayoutConstraint {
    func settingPriority(_ priority: UILayoutPriority) -> NSLayoutConstraint {
        self.priority = priority
        return self
    }
}
