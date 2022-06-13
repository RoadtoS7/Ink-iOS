//
//  SplashViewController.swift
//  Mureng
//
//  Created by nylah.j on 2022/06/13.
//

import UIKit

class SplashViewController: UIViewController {
    private var murengIcon: UIImageView = {
        let uiImage = UIImageView(image: Images.appIcon.image)
        uiImage.translatesAutoresizingMaskIntoConstraints = false
        return uiImage
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(murengIcon)
        NSLayoutConstraint.activate([
            murengIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            murengIcon.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
