//
//  TestTokenApp.swift
//  TestToken
//
//  Created by 김수현 on 9/7/24.
//

import SwiftUI

enum Destination: Hashable {
    case firstView(number: Int)
    case secondView
    case thirdView(number: Int)
}

@Observable
final class NavigationCoordinator<T: Hashable>  {
    var paths: [T] = []
    
    func push(_ path: T) {
        paths.append(path)
    }
    
    func pop() {
        paths.removeLast()
    }
    
    func pop(to: T) {
        guard let found = paths.firstIndex(where: { $0 == to }) else {
            return
        }
        
        let numToPop = (found..<paths.endIndex).count - 1
        paths.removeLast(numToPop)
    }
    
    func popToRoot() {
        paths.removeAll()
    }
}

@main
struct TestTokenApp: App {
    
    var body: some Scene {
        WindowGroup {
            NavigationView(contentBuilder: {
                
            })
        }
    }
}

struct NavigationView<Content: View>: View {
    @State var navigationCoordinator: NavigationCoordinator<Destination> = .init()
    
      let content: Content
      
      init(@ViewBuilder contentBuilder: () -> Content){
          self.content = contentBuilder()
      }
    
    var body: some View {
        NavigationStack(path: $navigationCoordinator.paths) {
            VStack {
                content
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
            .navigationBarTitleDisplayMode(.large)
            .toolbar(content: {
                Button(action: {
                    navigationCoordinator.push(.firstView(number: 1))
                }, label: {
                    Text("FirstView")
                })
            })
            .navigationDestination(for: Destination.self) { destination in
                switch destination {
                case .firstView(let number): FirstView(number: number)
                case .secondView: SecondView()
                case .thirdView(let number): ThirdView(number: number)
                }
            }
        }
        .environment(navigationCoordinator)
    }
}

struct FirstView: View {
    @Environment(NavigationCoordinator<Destination>.self) var navigationCoordinator
    private let title = "FirstView"
    let number: Int
    var body: some View {
        VStack {
                Text("\(number)")
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.secondary)
            .navigationTitle(title)
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing, content: {
                    Button(action: {
                        navigationCoordinator.push(.secondView)
                    }, label: {
                        Text("SecondView")
                    })
                })
            })
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading, content: {
                    Button(action: {
                        navigationCoordinator.pop()
                    }, label: {
                        Text("back button")
                    })
                })
            })
            .navigationBarBackButtonHidden()
    }
}

struct SecondView: View {
    @Environment(NavigationCoordinator<Destination>.self) var navigationCoordinator
    private let title = "SecondView"
    var body: some View {
        VStack {
                Text("")
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.secondary)
            .navigationTitle(title)
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing, content: {
                    Button(action: {
                        navigationCoordinator.push(.thirdView(number: 3))
                    }, label: {
                        Text("SecondView")
                    })
                })
            })
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading, content: {
                    Button(action: {
                        navigationCoordinator.pop()
                    }, label: {
                        Text("back button")
                    })
                })
            })
            .navigationBarBackButtonHidden()
    }
}

struct ThirdView: View {
    @Environment(NavigationCoordinator<Destination>.self) var navigationCoordinator
    private let title = "ThirdView"
    let number: Int
    var body: some View {
        VStack {
                Text("\(number)")
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.secondary)
            .navigationTitle(title)
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing, content: {
                    Button(action: {
                        navigationCoordinator.push(.thirdView(number: 3))
                    }, label: {
                        Text("ThirdView")
                    })
                })
            })
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading, content: {
                    Button(action: {
                        navigationCoordinator.pop()
                    }, label: {
                        Text("back button")
                    })
                })
            })
            .navigationBarBackButtonHidden()
    }
}
