//
//  ImageSourceTapBar.swift
//  Mureng
//
//  Created by 김수현 on 3/1/24.
//

import UIKit

protocol ImageSourceTapBarDelegate: AnyObject {
    func touched()
    func imageSourceTabBar(_ imageSourceTapBar: ImageSourceTapBar, didSelect localImage: UIImage?)
}

final class ImageSourceTapBar: UIView {
    final class SourceButton: UIButton {
        let title: String
        
        init(title: String) {
            self.title = title
            
            super.init(frame: .zero)
            
            setTitle(title, for: .normal)
            setTitleColor(Colors.Greyscale.greyscale800.color, for: .normal)
        }
        
        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError()
        }
    }
    
    private let stackView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        return $0
    }(UIStackView())
    
    private let galleryButton = SourceButton(title: "사진")
    private let appSourcingButton = SourceButton(title: "배경")
    private var appSourcingBackgroundListView: UIStackView!
    private var appSourcingBackgroundScrollView: UIScrollView!
    private var images: [UIImage] = []
    
    private let galleryPickerDelegate: GalleryPickerDelegate
    private let localSourceButtonDelegate: ImageSourceTapBarDelegate
    
    init(galleryPickerDelegate: GalleryPickerDelegate, localSourceButtonDelegate: ImageSourceTapBarDelegate) {
        self.galleryPickerDelegate = galleryPickerDelegate
        self.localSourceButtonDelegate = localSourceButtonDelegate
        super.init(frame: .zero)
        initLayout()
        addButtonActions()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initLayout() {
        backgroundColor = .white
        addSubviews()
        setupSubViews()
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 52),
        ])
    }
    
    private func setupSubViews() {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentInset = UIEdgeInsets(top: 12, left: 24, bottom: 12, right: 24)
        addSubview(scrollView)
        appSourcingBackgroundScrollView = scrollView
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: self.stackView.bottomAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.heightAnchor.constraint(equalToConstant: 144),
        ])
        
        
        let backgroundStackView = UIStackView()
        backgroundStackView.axis = .horizontal
        backgroundStackView.spacing = 8.0
        backgroundStackView.translatesAutoresizingMaskIntoConstraints = false
        backgroundStackView.distribution = .equalSpacing
        backgroundStackView.isHidden = true
        scrollView.addSubview(backgroundStackView)
        appSourcingBackgroundListView = backgroundStackView
        
        NSLayoutConstraint.activate([
            backgroundStackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            backgroundStackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            backgroundStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            backgroundStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
        ])
        
        setBackgroundImages()
    }
    
    private func addSubviews() {
        addSubview(stackView)
        stackView.addArrangedSubview(galleryButton)
        stackView.addArrangedSubview(appSourcingButton)
    }
    
    private func addButtonActions() {
        galleryButton.addTouchAction { [unowned self] _ in
            self.galleryPickerDelegate.present()
        }
        appSourcingButton.addTouchAction { [unowned self] _ in
            appSourcingBackgroundListView.isHidden = false
            localSourceButtonDelegate.touched()
        }
    }
    
    func setBackgroundImages() {
        if images.isEmpty {
            let placeholderCount: Int = 5
            placeholderViews(count: placeholderCount).forEach { view in
                appSourcingBackgroundListView.addArrangedSubview(view)
            }
        }
    }
    
    func placeholderViews(count: Int) -> [UIView] {
        (0..<count).map { _ in
            return makeImageButton(image: .add)
        }
    }
    
    func placeholderView() -> UIView {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 100).isActive = true
        view.heightAnchor.constraint(equalToConstant: 120).isActive = true
        return view
    }
    
    func makeImageButton(image: UIImage) -> UIButton {
        let button = UIButton()
        button.setImage(image, for: .normal)
        button.addTouchAction { [unowned self] _  in
            self.localSourceButtonDelegate.imageSourceTabBar(self, didSelect: image)
        }
        return button
    }
}
