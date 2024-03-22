//
//  UIViewController+.swift
//  Mureng
//
//  Created by 김수현 on 3/22/24.
//

import UIKit

extension UIViewController {
    var safeAreaTopAnchor: NSLayoutYAxisAnchor {
        view.safeAreaLayoutGuide.topAnchor
    }
    
    var safeAreaBottomAnchor: NSLayoutYAxisAnchor {
        view.safeAreaLayoutGuide.bottomAnchor
    }
    
    var safeAreaLeadingAnchor: NSLayoutXAxisAnchor {
        view.safeAreaLayoutGuide.leadingAnchor
    }
    
    var safeAreaTrailingAnchor: NSLayoutXAxisAnchor {
        view.safeAreaLayoutGuide.trailingAnchor
    }
}
