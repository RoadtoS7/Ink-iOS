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
    @State var email: String = ""
    
    var body: some View {
        ZStack(alignment: .leading) {
            if email.isEmpty {
                Text("이메일이 비어있씁니다.")
                    .font(.custom("Helvetica", size: 24))
                    .padding(.all)
                    .foregroundStyle(.black)
            }
            
            TextEditor(text: $email)
                .font(.custom("Helvetica", size: 24))
                .padding(.all)
        }
    }
}

#Preview {
    TestView()
}
