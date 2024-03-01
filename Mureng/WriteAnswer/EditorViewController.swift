//
//  EditorViewController.swift
//  Mureng
//
//  Created by 김수현 on 2/3/24.
//

import UIKit
import PhotosUI

protocol GalleryPickerDelegate: AnyObject {
    func present()
}

final class GalleryPickerUseCase: GalleryPickerDelegate {
    weak var rootViewController: UIViewController!
    let galleryPickerReceiver: GalleryPickerReceiver
    
    init(rootViewController: UIViewController, imageLoadingDone: @escaping (UIImage?) -> Void) {
        self.rootViewController = rootViewController
        self.galleryPickerReceiver = .init(imageLoadingDone: imageLoadingDone)
    }
    
    func present() {
        let view = PHPickerViewController(configuration: PHPickerConfiguration())
        view.delegate = galleryPickerReceiver
        
        rootViewController?.present(view, animated: true)
    }
}


class EditorViewController: UIViewController {
    let question = Question(id: 0, content: "This is Question", koreanContent: "이것은 한국어 번역입니다.")
    private lazy var questionHeaderView = QuestionHeaderView(question: question)
    
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
    
    private var imageSourceSelectionView: ImageSourceTapBar!
    
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
        let galleryPickerDelegate = GalleryPickerUseCase(rootViewController: self) { image in
            self.imageView.image = image
        }
        imageSourceSelectionView = .init(galleryPickerDelegate: galleryPickerDelegate)
        imageSourceSelectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = .white
        textView.delegate = self
        addSubviews()
        
        NSLayoutConstraint.activate([
            questionHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            questionHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            questionHeaderView.topAnchor.constraint(equalTo: view.topAnchor),
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
            imageSourceSelectionView.bottomAnchor.constraint(equalTo:
                                                                view.safeAreaLayoutGuide.bottomAnchor),
            imageSourceSelectionView.heightAnchor.constraint(equalToConstant: 52)
        ])
    }
    
    private func addSubviews() {
        view.addSubview(questionLabel)
        view.addSubview(questionHeaderView)
        view.addSubview(scrollView)
        view.addSubview(imageSourceSelectionView)
        
        scrollView.addSubview(scrollContentView)
        scrollContentView.addSubview(textView)
        scrollContentView.addSubview(imageView)
    }
    
    private func showImagePickerVC() {
        let viewController = UIImagePickerController(rootViewController: self)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension EditorViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        adjustTextViewHeight()
    }
    
    private func adjustTextViewHeight() {
        let size = textView.sizeThatFits(CGSize(width: textView.frame.size.width, height: CGFloat.infinity))
        let textViewHeight: CGFloat = size.height > self.textViewHeight ? size.height : self.textViewHeight
        
        if textViewHeightConstraint?.constant != textViewHeight  {
            textViewHeightConstraint?.constant = textViewHeight
            self.view.layoutIfNeeded()
        }
    }
}
