//
//  BottomSheetView.swift
//  Mureng
//
//  Created by nylah.j on 11/13/23.
//

import SwiftUI

struct BottomSheetView<ContentView: View> : View {
    let height: CGFloat
    let contentView: ContentView
    @Binding var showing: Bool
    
    init(height: CGFloat, contentView: ContentView, showing: Binding<Bool>) {
        self.height = height
        self.contentView = contentView
        self._showing = showing
    }
    
    var heightFactor: CGFloat {
        UIScreen.main.bounds.height > 800 ? 3.6 : 3
    }
    
    private var offset: CGFloat {
        showing ? 0 : UIScreen.main.bounds.height / heightFactor
    }
    
    var body: some View {
//        GeometryReader(content: { geometry in
//            VStack(content: {
//                Rectangle()
//                    .background(Color.clear)
//                    .onTapGesture {
//                        showing = false
//                    }
//                
//                contentView
//                    .frame(
//                        width: geometry.size.width,
//                        height: contentViewHeight(parentHeight: geometry.size.height),
//                        alignment: .center
//                    )
//                    .offset(y: offset)
//                    .animation(.easeInOut(duration: 0.49), value: showing)
//            })
//        })
//        .edgesIgnoringSafeArea(.bottom)
        
        GeometryReader(content: { geometry in
            VStack(content: {
                Spacer()
                contentView
                .frame(
                    width: geometry.size.width,
                    height: contentViewHeight(parentHeight: geometry.size.height),
                    alignment: .center
                )
                .animation(.easeInOut(duration: 0.49), value: showing)
            })
        })
        .edgesIgnoringSafeArea(.bottom)
    }
    
    func contentViewHeight(parentHeight: CGFloat) -> CGFloat {
        parentHeight / heightFactor
    }
    
    func show() {
        showing = true
    }
}

#Preview {
    @State var showing: Bool = false
    return BottomSheetView(height: 280, contentView: Color.blue, showing: $showing)
}
