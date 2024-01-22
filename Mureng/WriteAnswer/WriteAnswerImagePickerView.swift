//
//  WriteAnswerImagePickerView.swift
//  Mureng
//
//  Created by nylah.j on 11/24/23.
//

import SwiftUI
import UIKit

extension Spacer {
    public func onTapGesture(count: Int = 1, perform action: @escaping () -> Void) -> some View {
        ZStack {
            Color.black.opacity(0.001).onTapGesture(count: count, perform: action)
            self
        }
    }
}

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
    
    func dismissAllPicker() {
        withAnimation {
            galleryPickerPresented = false
            backgroundPickerPresented = false
        }
    }
    
    func showBackgroundPicker() {
        withAnimation {
            backgroundPickerPresented = true
        }
    }
    var body: some View {
        ZStack {
            if backgroundPickerPresented {
                collpasedBackgroundPicker
                    .transition(
                        .asymmetric(insertion: .move(edge: .bottom),
                                    removal: .move(edge: .bottom)
                    ))
            } else {
                VStack {
                    Spacer()
                    imageSourceOptionButtons
                }
            }
        }
        .sheet(isPresented: $galleryPickerPresented) {
            GalleryPickerView(sourceType: .photoLibrary) { image in
                self.imageFromGallery = image
            }
        }
    }
    
    var collpasedBackgroundPicker : some View {
        VStack(spacing: .zero) {
            Spacer()
                .onTapGesture {
                    self.backgroundPickerPresented = false
                }
            imageSourceOptionButtons
            backgroundPickerView
        }
    }
    
    var backgroundPickerView: some View {
        ScrollView(.horizontal) {
            LazyHGrid(rows: [GridItem(.fixed(97))],
                      spacing: 8.0,
                      content: {
                ForEach(backgroundViews) { background in
                    AnswerBackgroundView(color: background.color, selected: false)
                        .frame(width: 90, height: 100)
                        
                }
            })
            .padding(.horizontal, 24)
        }
        .scrollIndicators(.hidden)
        .frame(height: 144)
        .frame(maxWidth: .infinity)
        .background(.white)
    }
    
    var imageSourceOptionButtons: some View {
        HStack(spacing: 24) {
            Button(action: {
                galleryPickerPresented.toggle()
                backgroundPickerPresented = false
            }, label: {
                Text("사진")
                    .frame(
                        maxWidth: .infinity,
                        minHeight: 44,
                        maxHeight: .infinity
                    )
            })
            
            Button(action: {
                showBackgroundPicker()
            }, label: {
                Text("배경")
                    .frame(
                        maxWidth: .infinity,
                        minHeight: 44,
                        maxHeight: .infinity
                    )
            })
        }
        .frame(maxWidth: .infinity, maxHeight: 52)
        .padding(.vertical, 4)
        .background(.white)
    }
}

#Preview {
    @State var imageFromGallery: UIImage? = nil
    return WriteAnswerImagePickerView(imageFromGallery: $imageFromGallery)
}
