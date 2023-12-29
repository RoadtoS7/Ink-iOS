//
//  WriteAnswerImagePickerView.swift
//  Mureng
//
//  Created by nylah.j on 11/24/23.
//

import SwiftUI
import UIKit

struct WriteAnswerImagePickerView: View {
    @State private var galleryPickerPresented: Bool = false
    @State private var backgroundPickerPresented: Bool = false
    @Binding var imageFromGallery: UIImage?
    

    let backgroundViews: [AnswerBackground] = [.init(color: .red),
                                               .init(color: .yellow),
                                               .init(color: .orange),
                                               .init(color: .green),
                                               .init(color: .blue),
                                               .init(color: .purple)]
    
    var body: some View {
        VStack {
            Spacer()
                .onTapGesture {
                    galleryPickerPresented = false
                }
            
            HStack(spacing: 24) {
                Button("사진") {
                    galleryPickerPresented.toggle()
                    backgroundPickerPresented = false
                }
                .frame(maxWidth: .infinity, minHeight: 44, maxHeight: .infinity)
                
                Button("배경") {
                    backgroundPickerPresented = true
                }
                .frame(height: 44)
                .frame(maxWidth: .infinity, minHeight: 44, maxHeight: .infinity)
            }
            .frame(maxWidth: .infinity, maxHeight: 52)
            .padding(.vertical, 4)
            .background(.white)
            
//            if backgroundPickerPresented {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()),
                                        GridItem(.flexible()),
                                        GridItem(.flexible())],
                              spacing: 5, content: {
                        ForEach(backgroundViews) { background in
                            AnswerBackgroundView(color: background.color, selected: false)
                                .frame(width: 90, height: 100)
                                
                        }
                    })
                }
                .frame(height: .infinity)
                .background(.white)
//            }
        }
        .sheet(isPresented: $galleryPickerPresented) {
            GalleryPickerView(sourceType: .photoLibrary) { image in
                self.imageFromGallery = image
            }
        }
    }
}

#Preview {
    @State var imageFromGallery: UIImage? = nil
    return WriteAnswerImagePickerView(imageFromGallery: $imageFromGallery)
}
