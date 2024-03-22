//
//  TestViewController.swift
//  Mureng
//
//  Created by 김수현 on 3/1/24.
//

import UIKit

// TODO: DiaryEditorViewContoller 코드 정리 
class DiaryEditorViewController: BaseTopNavigationTabBarController {
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
    private var imageSourceTapBarBottomAnchor: NSLayoutConstraint!
    
    private var dictionaryButton: UIButton!
    
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
        view.backgroundColor = Colors.Neutral.Container.primary.color
        setupTopNavigationBar()
        setupScrollView()
        setupContentView()
        setupHeaderView()
        setupDivider()
        setupDiaryTextView()
        setupImageSourceSelectionView()
        setupImageView()
        setupTapDownGesture()
        setupDictionaryButton()
    }
    
    private func setupTopNavigationBar() {
        navigationBar.addRightButtons([TopNavigationBarItem(title: "등록", action: UIAction(handler: { _ in
            // TODO: 등록 action
            print("$$ 등록!!")
        }))])
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
        textView.backgroundColor = Colors.Neutral.Container.primary.color
        textView.textColor = Colors.diaryContent.color
        
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
        
        showHintText()
    }
    
    @objc func textViewTapped(sender: UITapGestureRecognizer) {
        if imageSourceTapBarBottomAnchor.constant == .zero {
            dismissImageSourceTapBar()
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
        self.imageSourceTapBar = imageSourceTabBar
        view.addSubview(imageSourceTabBar)
        
        NSLayoutConstraint.activate([
            imageSourceTabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageSourceTabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageSourceTabBar.heightAnchor.constraint(equalToConstant: 196)
        ])
        
        let bottomAnchor =  imageSourceTabBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 144.0)
        bottomAnchor.isActive = true
        imageSourceTapBarBottomAnchor = bottomAnchor
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
    
    private func setupDictionaryButton() {
        let button = DictionaryButton()
        self.dictionaryButton = button
        
        view.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.bottomAnchor.constraint(equalTo: imageSourceTapBar.topAnchor, constant: -27.0),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.0),
            button.widthAnchor.constraint(equalToConstant: 56.0),
            button.heightAnchor.constraint(equalTo: button.widthAnchor)
        ])
    }
    
    @objc func handleTapOutside(sender: UITapGestureRecognizer) {
        let location = sender.location(in: view)
        if imageSourceTapBarBottomAnchor.constant == .zero,
           !imageSourceTapBar.frame.contains(location) {
            UIView.animate(withDuration: 0.3) {
                self.dismissImageSourceTapBar()
            }
        }
    }
}

extension DiaryEditorViewController: UITextViewDelegate {
    var hintText: String {
        """
        질문에 대한 내 생각을 적어보세요.
        50 글자만 넘기면 돼요.
        """
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard textView.text.isNotEmpty,
              textView.text == hintText else {
            return
        }
        
        textView.text = nil
        textView.textColor = Colors.diaryContent.color
        textView.font = .body18R
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            showHintText()
        }
    }
    
    private func showHintText() {
        textView.text = hintText
        textView.textColor = Colors.Greyscale.greyscale600.color
        textView.font = .body16R
    }
    
    func textViewDidChange(_ textView: UITextView) {
        adjustTextViewHeight()
    }
    
    private func adjustTextViewHeight() {
        let size = textView.sizeThatFits(CGSize(width: textView.frame.size.width, height: CGFloat.infinity))
        let textViewHeight: CGFloat = size.height > self.textViewHeight ? size.height : self.textViewHeight
        
        if textViewHeightConstraint?.constant != textViewHeight {
            textViewHeightConstraint?.constant = textViewHeight
            self.view.layoutIfNeeded()
        }
    }
}

extension DiaryEditorViewController: ImageSourceTapBarDelegate {
    func touched() {
        UIView.animate(withDuration: 0.2) {
            self.imageSourceTapBarBottomAnchor.constant = .zero
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func dismissImageSourceTapBar() {
        UIView.animate(withDuration: 0.2) {
            self.imageSourceTapBarBottomAnchor.constant = 144
            self.view.layoutIfNeeded()
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
    
    func imageSourceTabBar(_ imageSourceTapBar: ImageSourceTapBar, didSelect localImage: UIImage?) {
        image = localImage
    }
}
