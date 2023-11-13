//
//  WriteAnswerView.swift
//  Mureng
//
//  Created by nylah.j on 2023/10/07.
//

import SwiftUI
import PhotosUI

struct WriteAnswerView: View {
    let question: Question
    private let placeholder: String = "질문에 대한 내 생각을 적어보세요. 50 글자만 넘기면 돼요."
    @State private var editing: Bool = false
    @State private var answer: String = ""
    @State private var image: UIImage? = nil
    @State private var galleryPickerPresented: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            QuestionView(question: question)
            
            Rectangle()
                .frame(minWidth: 1, maxWidth: .infinity, maxHeight: 1)
                .foregroundColor(.clear)
                .background(Colors.Greyscale.greyscale200.swiftUIColor)
            
            EditorView(answer: $answer, placeholder: placeholder)
            
            if let image {
                GeometryReader(content: { geometry in
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: geometry.size.width)
                        .aspectRatio(1.0, contentMode: .fit)
                })
            }
            
            HStack {
                Button {
                    galleryPickerPresented.toggle()
                } label: {
                    Text("사진")
                }
            }
            .sheet(isPresented: $galleryPickerPresented) {
                GalleryPickerView(sourceType: .photoLibrary) { image in
                    self.image = image
                }
            }
        }.padding(.horizontal, 24)
    }
}

struct WriteAnswerView_Previews: PreviewProvider {
    private static let question: Question = .init(id: 0, content: "What are the habits you want to build?", koreanContent: "어떤 습관을 만들고 싶나요?")
    
    static var previews: some View {
        WriteAnswerView(question: question)
    }
}

struct EditorView: View {
    @State var editing: Bool = false
    @Binding var answer: String
    let placeholder: String
    
    var body: some View {
        ZStack(alignment: .topLeading, content: {
            TextEditor(text: $answer)
                .multilineTextAlignment(.leading)
                .background(Color.clear)
                .font(FontFamily.Pretendard
                    .regular
                    .swiftUIFont(fixedSize: 18))
                .onChange(of: answer, perform: { _ in
                    editing = true
                })
            
            if answer.isEmpty && editing == false {
                Text(placeholder)
                    .frame(maxWidth: .infinity,
                           alignment: .topLeading)
                    .foregroundColor(Colors.Greyscale.greyscale200.swiftUIColor)
            }
        })
    }
}

struct QuestionView: View {
    let question: Question
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Text("Q.")
                .font(FontFamily.NanumMyeongjo
                    .extraBold
                    .swiftUIFont(fixedSize: 24))
            
            VStack(alignment: .leading, spacing: 12) {
                Text(question.content)
                    .font(FontFamily.NanumMyeongjo
                        .extraBold
                        .swiftUIFont(fixedSize: 28))
                
                Text(question.koreanContent)
                    .font(FontFamily.Pretendard
                        .regular
                        .swiftUIFont(fixedSize: 14))
                    .foregroundColor(Colors.Grey.dark1.swiftUIColor)
            }
        }
        .frame(maxWidth: .infinity)
    }
}
