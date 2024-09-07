//
//  AsyncButton.swift
//  Mureng
//
//  Created by 김수현 on 8/25/24.
//

import SwiftUI

struct AsyncButton<Label: View>: View {
    var action: () async -> Void
    var actionOptions: Set<ActionOption> = .init(ActionOption.allCases)
    @ViewBuilder var label: () -> Label
    
    @State private var isDisabled: Bool = false
    @State private var showProgress: Bool = false
    var body: some View {
        Button(action: {
            if actionOptions.contains(.disableButton) {
                isDisabled = true
            }
            
            Task {
                var progressiveTask: Task<Void, Error>?
                
                if actionOptions.contains(.showProgressView) {
                    progressiveTask = Task {
                        try await Task.sleep(nanoseconds: 150_000_000)
                        showProgress = true
                    }
                }
                
                await action()
                progressiveTask?.cancel()
                
                isDisabled = false
                showProgress = false
            }
        }, label: {
            ZStack(content: {
                label().opacity(showProgress ? 0 : 1)
                
                if showProgress {
                    ProgressView()
                }
            })
        })
        .disabled(isDisabled)
    }
}

extension AsyncButton {
    enum ActionOption: CaseIterable {
        case disableButton
        case showProgressView
    }
}

extension AsyncButton where Label == Text {
    init(_ label: String,
         actionOptions: Set<ActionOption> = .init(ActionOption.allCases),
         action: @escaping () async -> Void
    ) {
        self.init(action: action) {
            Text(label)
        }
    }
}

extension AsyncButton where Label == Image {  
    init(_ image: Image,
         actionOptions: Set<ActionOption> = .init(ActionOption.allCases),
         action: @escaping () async -> Void
    ) {
        self.init(action: action) {
            image
        }
    }
}

#Preview("Async Button") {
    AsyncButton(
        Image(systemName: "hand.thumbsup.fill"),
        action: {}
    )
}
