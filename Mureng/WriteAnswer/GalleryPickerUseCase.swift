//
//  GalleryPickerUseCase.swift
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
