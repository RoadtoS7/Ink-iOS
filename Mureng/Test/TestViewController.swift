//
//  TestViewController.swift
//  Mureng
//
//  Created by 김수현 on 3/1/24.
//

import UIKit

class TestViewController: UIViewController {
    private var imageSourceTapBar: ImageSourceTapBar!
    private var imageSourceTapBarHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let delegate = GalleryPickerUseCase(rootViewController: self) { image in
            print("$$ image loading: ", image != nil)
        }
        imageSourceTapBar = ImageSourceTapBar(galleryPickerDelegate: delegate, localSourceButtonDelegate: self)
        imageSourceTapBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageSourceTapBar)
        
        NSLayoutConstraint.activate([
            imageSourceTapBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageSourceTapBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageSourceTapBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            imageSourceTapBar.heightAnchor.constraint(equalToConstant: 196),
        ])
        
//        imageSourceTapBar.transform = CGAffineTransform(translationX: 0, y: 144)
    }
}

extension TestViewController: ImageSourceTapBarDelegate {
    func touched() {
        UIView.animate(withDuration: 0.2) {
            self.imageSourceTapBar.transform = .identity
        }
    }
}
