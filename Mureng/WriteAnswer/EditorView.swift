//
//  EditorView.swift
//  Mureng
//
//  Created by 김수현 on 1/21/24.
//

import SwiftUI

struct EditorView: View {
    @Binding var answer: String
    let placeholder: String
    @FocusState private var isTextEditorFocused: Bool
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $answer)
                .scrollContentBackground(.hidden)
                .focused($isTextEditorFocused)
                .onTapGesture {
                    if isTextEditorFocused {
                        // 키보드가 보이는 상태에서 TextField를 다시 탭하면 키보드 숨김
                        isTextEditorFocused = false
                    } else {
                        // TextField가 포커스를 잃었을 때 탭하면 키보드 표시
                        isTextEditorFocused = true
                    }
                }
            
            if answer.isEmpty && !isTextEditorFocused {
                Text("여기에 입력하세요...")
                    .foregroundColor(.gray)
                    .padding(.top, 8)
                    .padding(.leading, 5)
            }
        }
        .onAppear(perform: {
            UIScrollView.appearance().bounces = false
        })
        .onDisappear(perform: {
            UIScrollView.appearance().bounces = true
        })
    }
}

#Preview {
    @State var answer: String = ""
    let placeholder = "이것은 placeholder 텍스트입니다."
    return EditorView(answer: $answer, placeholder: placeholder)
}
