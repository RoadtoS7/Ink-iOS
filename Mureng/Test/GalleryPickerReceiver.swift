//
//  GalleryPickerReceiver.swift
//  Mureng
//
//  Created by 김수현 on 3/1/24.
//

import UIKit
import PhotosUI

class GalleryPickerReceiver: PHPickerViewControllerDelegate {
    typealias AfterImageLoading = (UIImage?) -> Void
    let imageLoadingDone: AfterImageLoading
    
    init(imageLoadingDone: @escaping AfterImageLoading) {
        self.imageLoadingDone = imageLoadingDone
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        let itemProvider = results.first?.itemProvider
        guard let itemProvider = itemProvider,
              itemProvider.canLoadObject(ofClass: UIImage.self) else {
            imageLoadingDone(nil)
            return
        }
        
        itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
            print("$$ image loadgin error:", error)
            
            if let image = image as? UIImage {
                self?.imageLoadingDone(image)
            }

            self?.imageLoadingDone(nil)
        }
    }
}
