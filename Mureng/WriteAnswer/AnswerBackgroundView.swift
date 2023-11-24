//
//  AnswerBackgroundView.swift
//  Mureng
//
//  Created by nylah.j on 11/15/23.
//

import SwiftUI

struct AnswerBackgroundView: View {
    let color: Color
    @State var selected: Bool
    
    var body: some View {
        ZStack(content: {
            RoundedRectangle(cornerRadius: 4)
                .background(color)
            
            if selected {
                Images.selected24.swiftUIImage
            }
        })
    }
    
    func select() {
        selected = true
    }
    
    func deselect() {
        selected = false
    }
}

#Preview {
    @State var selected: Bool = false
    @State var deselected: Bool = false
    return Group {
        AnswerBackgroundView(color: .yellow, selected: selected)
        AnswerBackgroundView(color: .yellow, selected: deselected)
    }
}
