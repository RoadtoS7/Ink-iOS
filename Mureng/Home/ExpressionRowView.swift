//
//  ExpressionRowView.swift
//  Mureng
//
//  Created by 김수현 on 2023/09/03.
//

import SwiftUI

struct ExpressionRowView: View {
    let engExpression: EnglishExpression
    
    var body: some View {
        HStack(alignment: .center, spacing: 20) {
            // TODO: 색상 변경
            Rectangle()
                .frame(minWidth: 3, maxWidth: 3, minHeight: 3, maxHeight: .infinity)
                .background(Colors.Grey.grey2Default1.swiftUIColor)
            // TODO: 텍스트 줄간 간격 변경
            VStack(alignment: .leading, spacing: 16) {
                HStack(alignment: .firstTextBaseline, spacing: 12) {
                    Text(engExpression.content)
                    Text(engExpression.koConent)
                }
                .font(FontFamily.Pretendard
                    .semiBold
                    .swiftUIFont(size: 16)
                )
                
                VStack(alignment: .leading, spacing: 12) {
                    Text(engExpression.example)
                    Text(engExpression.koExample)
                }
                .font(FontFamily.Pretendard
                    .regular
                    .swiftUIFont(size: 14)
                )
                .foregroundColor(Colors.Grey.dark1.swiftUIColor)
            }
        }
    }
}

struct ExpressionRowView_Previews: PreviewProvider {
    private static var sampleExpression: EnglishExpression = .init(
        id: 0,
        content: "can’t wait to ~",
        koConent: "얼른 ~하고 싶다",
        example: "I can’t wait to go on this trip.",
        koExample: "얼른 여행을 떠났으면 좋겠어."
    )
    
    static var previews: some View {
        ExpressionRowView(engExpression: sampleExpression)
            .frame(maxWidth: .infinity, minHeight: 72, maxHeight: 72, alignment: .leading)
    }
}
