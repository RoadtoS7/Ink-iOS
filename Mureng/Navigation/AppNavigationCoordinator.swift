//
//  AppNavigationCoordinator.swift
//  Mureng
//
//  Created by 김수현 on 6/23/24.
//

import SwiftUI

private final class AppNavigationCoordinator: ObservableObject {
    @Published var path: [NavigationPath] = []
}
