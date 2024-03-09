//
//  TestViewController.swift
//  Mureng
//
//  Created by 김수현 on 3/1/24.
//

import UIKit

class DiaryEditorViewController: UIViewController {
    private var scrollView: UIScrollView!
    private var contentView: UIView!
    private var questionHeaderView: QuestionHeaderView!
    private var divider: UIView!
    
    private var textView: UITextView!
    private var textViewHeightConstraint: NSLayoutConstraint?
    private var textViewHeight: CGFloat = .zero
    
    private var imageView: UIImageView!
    private var imageViewDimensionRatioConstraint: NSLayoutConstraint!
    private var imageSourceTapBar: ImageSourceTapBar!
    
    let testQuestion: Question = Question(id: 0, content: "this is eng title", koreanContent: "이것은 한국어 컨텐츠 입니다.")
    
    var image: UIImage? {
        didSet {
            guard let image = image else { return }
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
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
        setupTapDownGesture()
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
            questionHeaderView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24.0),
            questionHeaderView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24.0),
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
        textView.delegate = self
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
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(textViewTapped))
        tapGesture.delegate = self
        textView.addGestureRecognizer(tapGesture)
    }
    
    @objc func textViewTapped(sender: UITapGestureRecognizer) {
        if scrollView.transform == CGAffineTransform.identity {
            UIView.animate(withDuration: 0.3) {
                self.dismissImageSourceTapBar()
            }
        }
    }
    
    private func setupImageSourceSelectionView() {
        let galleryPickerDelegate = GalleryPickerUseCase(
            rootViewController: self,
            imageLoadingDone: { [weak self] image in
                DispatchQueue.main.async {
                    self?.image = image
                }
            })
        let imageSourceTabBar = ImageSourceTapBar(galleryPickerDelegate: galleryPickerDelegate, localSourceButtonDelegate: self)
        imageSourceTabBar.translatesAutoresizingMaskIntoConstraints = false
        imageSourceTabBar.transform = CGAffineTransform(translationX: 0, y: 144)
        self.imageSourceTapBar = imageSourceTabBar
        view.addSubview(imageSourceTabBar)
        
        NSLayoutConstraint.activate([
            imageSourceTabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageSourceTabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageSourceTabBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            imageSourceTabBar.heightAnchor.constraint(equalToConstant: 196)
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
            imageView.heightAnchor.constraint(equalToConstant: 0).settingPriority(.defaultLow),
            contentView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 50),
        ])
    }
    
    private func setupTapDownGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOutside))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTapOutside(sender: UITapGestureRecognizer) {
        let location = sender.location(in: view)
        if imageSourceTapBar.transform == CGAffineTransform.identity, !imageSourceTapBar.frame.contains(location) {
            UIView.animate(withDuration: 0.3) {
                self.imageSourceTapBar.transform = CGAffineTransform(translationX: 0, y: 144)
            }
        }
    }
}

extension DiaryEditorViewController: UITextViewDelegate {
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

extension DiaryEditorViewController: ImageSourceTapBarDelegate {
    func touched() {
        UIView.animate(withDuration: 0.2) {
            self.imageSourceTapBar.transform = .identity
        }
    }
    
    @objc private func dismissImageSourceTapBar() {
        UIView.animate(withDuration: 0.2) {
            self.imageSourceTapBar.transform = CGAffineTransform(translationX: 0, y: 144)
        }
    }
}


extension DiaryEditorViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let location = touch.location(in: textView)
        
        if textView.bounds.contains(location) {
            textView.becomeFirstResponder()
            return true
        }
        return false
    }
}
