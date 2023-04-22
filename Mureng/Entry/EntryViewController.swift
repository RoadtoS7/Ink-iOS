//
//  SplashViewController.swift
//  Mureng
//
//  Created by nylah.j on 2022/06/13.
//

import UIKit

class EntryViewController: UIViewController {
    private var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        loginButton.addTarget(self, action: #selector(navigateToLoginProcess), for: .touchUpInside)
    }
            
    @objc func navigateToLoginProcess() {
        let agreementViewController = AgreementViewController()
        self.navigationController?.pushViewController(agreementViewController, animated: true)
        self.dismiss(animated: false)
    }
}

extension EntryViewController {
    private func initViews() {
        let murengIcon: UIImageView = .init(image: Images.inkIcon.image)
        murengIcon.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(murengIcon)
        NSLayoutConstraint.activate([
            murengIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            murengIcon.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        let loginButton: UIButton = .init()
        loginButton.setImage(Images.kakaoLoginButton.image, for: .normal)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginButton)
        NSLayoutConstraint.activate([
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 16),
            loginButton.widthAnchor.constraint(equalTo: loginButton.heightAnchor, multiplier: 343 / 48),
            loginButton.heightAnchor.constraint(equalToConstant: 48),
            // TODO: 하단 간격 조절
            loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 16)
        ])
        self.loginButton = loginButton
    }
}
