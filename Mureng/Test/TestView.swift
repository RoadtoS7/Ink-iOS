//
//  TestView.swift
//  Mureng
//
//  Created by 김수현 on 12/30/23.
//
// SwiftUI의 view를 테스트해보는 view

import SwiftUI

struct FullScreenModalView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            Color.primary.edgesIgnoringSafeArea(.all)
            Button("Dismiss Modal") {
                dismiss()
            }
        }
    }
}

struct TestView: View {
    @State private var isPresented = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Button("Present!") {
            isPresented.toggle()
        }
                .fullScreenCover(isPresented: $isPresented, content: FullScreenModalView.init)
    }
}

#Preview {
    TestView()
}
