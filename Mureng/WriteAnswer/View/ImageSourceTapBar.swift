//
//  ImageSourceTapBar.swift
//  Mureng
//
//  Created by 김수현 on 3/1/24.
//

import UIKit

final class ImageSourceTapBar: UIView {
    class SourceButton: UIButton {
        let title: String
        
        init(title: String) {
            self.title = title
            
            super.init(frame: .zero)
            
            backgroundColor = .white
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
    private var appSourcingBackgroundStackView: UIStackView!
    
    private let galleryPickerDelegate: GalleryPickerDelegate
    
    init(galleryPickerDelegate: GalleryPickerDelegate) {
        self.galleryPickerDelegate = galleryPickerDelegate
        super.init(frame: .zero)
        initLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initLayout() {
        backgroundColor = .white
        setupSubViews()
        addSubviews()
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    
    private func setupSubViews() {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.appSourcingBackgroundStackView = stackView
    }
    
    private func addSubviews() {
        self.addSubview(stackView)
        stackView.addArrangedSubview(galleryButton)
        stackView.addArrangedSubview(appSourcingButton)
    }
    
    private func addButtonActions() {
        galleryButton.addTouchAction { [unowned self] _ in
            self.galleryPickerDelegate.present()
        }
        appSourcingButton.addTouchAction { [unowned self] _ in
            
        }
    }
}
