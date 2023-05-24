//
//  FullScreenHostingViewController.swift
//  Mureng
//
//  Created by nylah.j on 2023/05/24.
//

import UIKit
import SwiftUI

final class FullScreenHostingViewController<V: View>: UIViewController {
    let swiftUIView: V
    
    init(swiftUIView: V) {
        self.swiftUIView = swiftUIView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let hostVC = UIHostingController(rootView: swiftUIView)
        let hostView = hostVC.view!
        
        hostView.translatesAutoresizingMaskIntoConstraints = false
        addChild(hostVC)
        view.addSubview(hostView)
        hostView.snp.makeConstraints { make in
            make.width.height.equalToSuperview()
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        hostVC.didMove(toParent: self)
    }
}
