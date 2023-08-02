//
//  Extension.swift
//  Mureng
//
//  Created by 김수현 on 2023/07/30.
//

import SwiftUI

enum InkError: Error {
    case unknownError(_ message: String)
}

extension View {
    func hideNavigationBar() -> some View {
        if #available(iOS 16.0, *) {
            return self.toolbar(.hidden, for: .navigationBar)
        } else {
            return self.navigationBarHidden(true)
        }
    }
}
