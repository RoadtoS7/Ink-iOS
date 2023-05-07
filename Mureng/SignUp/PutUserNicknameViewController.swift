//
//  PutUserNicknameViewController.swift
//  Mureng
//
//  Created by 김수현 on 2023/05/07.
//

import UIKit
import SwiftUI

class PutUserNicknameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let hostVC = UIHostingController(rootView: PutUserNicknameView())
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
