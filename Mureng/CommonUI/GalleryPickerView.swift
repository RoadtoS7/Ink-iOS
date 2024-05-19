//
//  GalleryPickerView.swift
//  Mureng
//
//  Created by nylah.j on 11/13/23.
//

import SwiftUI

struct GalleryPickerView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    
    typealias SourceType = UIImagePickerController.SourceType
    let sourceType: SourceType
    
    typealias OnImagePicked = (UIImage) -> Void
    let onImagePicked: OnImagePicked
    
    final class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        @Binding private var presentationMode: PresentationMode
        private let sourceType: SourceType
        private let onImagePicked: OnImagePicked
        
        init(presentationMode: Binding<PresentationMode>, sourceType: SourceType, onImagePicker: @escaping OnImagePicked) {
            _presentationMode = presentationMode
            self.sourceType = sourceType
            self.onImagePicked = onImagePicker
        }
        
        // UIImagePickerControllerDelegate
        
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let uiImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            onImagePicked(uiImage)
            presentationMode.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            presentationMode.dismiss()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(presentationMode: presentationMode, sourceType: sourceType, onImagePicker: onImagePicked)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<GalleryPickerView>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController,
                                context: UIViewControllerRepresentableContext<GalleryPickerView>) {
        
    }
}

#Preview {
    GalleryPickerView(sourceType: .photoLibrary, onImagePicked: { _ in
        // DO NOTHING
    })
}
