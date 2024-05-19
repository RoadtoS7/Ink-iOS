//
//  BottomSheetView.swift
//  Mureng
//
//  Created by nylah.j on 11/13/23.
//

import SwiftUI

struct BottomSheetView<ContentView: View>: View {
    @State var presenting: Bool = true
    let contentView: ContentView
    @Binding var bottomSheetHeight: PresentationDetent
    
    var body: some View {
        ZStack(content: {
            Button("Show Credits") {
                presenting.toggle()
            }
        })
        .sheet(isPresented: $presenting, content: {
            contentView
                .presentationDetents([.height(52), .large], selection: $bottomSheetHeight)
        })
    }
}

#Preview {
    @State var image: UIImage?
    @State var bottomSheetHeight: PresentationDetent = .height(52)

    return BottomSheetView(
        contentView: WriteAnswerImagePickerView(imageFromGallery: $image),
        bottomSheetHeight: $bottomSheetHeight
    )
}
