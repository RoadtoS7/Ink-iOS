//
//  TestViewController.swift
//  Mureng
//
//  Created by 김수현 on 3/1/24.
//

import UIKit

class TestViewController: UIViewController {
    private var scrollView: UIScrollView!
    private var contentView: UIView!
    private var questionHeaderView: QuestionHeaderView!
    private var divider: UIView!
    
    private var textView: UITextView!
    private var textViewHeightConstraint: NSLayoutConstraint?
    private var textViewHeight: CGFloat = .zero
    
    private var imageView: UIImageView!
    private var imageViewHeightZeroConstraint: NSLayoutConstraint!
    private var imageViewDimensionRatioConstraint: NSLayoutConstraint!
    private var imageSourceTapBar: ImageSourceTapBar!
    
    let testQuestion: Question = Question(id: 0, content: "this is eng title", koreanContent: "이것은 한국어 컨텐츠 입니다.")
    
    var image: UIImage? {
        didSet {
            let imageIsHidden = image == nil
            imageViewHeightZeroConstraint.isActive = imageIsHidden
            imageView.image = image
        }
    }
    
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
        setupScrollView()
        setupContentView()
        setupHeaderView()
        setupDivider()
        setupDiaryTextView()
        setupImageSourceSelectionView()
        setupImageView()
    }
    
    private func setupScrollView() {
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentInset = UIEdgeInsets(bottom: 52)
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    
    private func setupContentView() {
        contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .yellow
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func setupHeaderView() {
        questionHeaderView = QuestionHeaderView(question: testQuestion)
        questionHeaderView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(questionHeaderView)
        
        NSLayoutConstraint.activate([
            questionHeaderView.topAnchor.constraint(equalTo: contentView.topAnchor),
            questionHeaderView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            questionHeaderView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
    
    private func setupDivider() {
        self.divider = UIView()
        divider.backgroundColor = Colors.Greyscale.greyscale200.color
        divider.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(divider)
        
        NSLayoutConstraint.activate([
            divider.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            divider.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            divider.topAnchor.constraint(equalTo: questionHeaderView.bottomAnchor, constant: 26),
            divider.heightAnchor.constraint(equalToConstant: 1),
        ])
    }
    
    private func setupDiaryTextView() {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.bounces = false
        textView.showsVerticalScrollIndicator = false
        contentView.addSubview(textView)
        self.textView = textView
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 32),
            textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            contentView.bottomAnchor.constraint(greaterThanOrEqualTo: textView.bottomAnchor),
        ])
        
        textViewHeightConstraint = textView.heightAnchor.constraint(equalToConstant: 40)
        textViewHeightConstraint?.isActive = true
        
        let bottomConstraint = contentView.bottomAnchor.constraint(equalTo: textView.bottomAnchor)
        bottomConstraint.priority = .defaultLow
        bottomConstraint.isActive = true
    }
    
    private func setupImageSourceSelectionView() {
        let galleryPickerDelegate = GalleryPickerUseCase(
            rootViewController: self,
            imageLoadingDone: { [weak self] image in
            DispatchQueue.main.async {
                self?.image = image
            }
        })
        let imageSourceSelectionView = ImageSourceTapBar(galleryPickerDelegate: galleryPickerDelegate)
        imageSourceSelectionView.translatesAutoresizingMaskIntoConstraints = false
        self.imageSourceTapBar = imageSourceSelectionView
        view.addSubview(imageSourceSelectionView)
        
        NSLayoutConstraint.activate([
            imageSourceSelectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageSourceSelectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageSourceSelectionView.bottomAnchor.constraint(equalTo:
                                                                view.safeAreaLayoutGuide.bottomAnchor),
            imageSourceSelectionView.heightAnchor.constraint(equalToConstant: 52)
        ])
    }
    
    private func setupImageView() {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        self.imageView = imageView
        contentView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 40),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            contentView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 50),
        ])
        
        imageViewHeightZeroConstraint = imageView.heightAnchor.constraint(equalToConstant: .zero)
        imageViewHeightZeroConstraint.isActive = true
    }
}

extension TestViewController: UITextViewDelegate {
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
