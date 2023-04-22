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
        
        // MARK: LoginButton
        let loginButton: UIButton = .init()
        loginButton.setImage(Images.kakaoLoginButton.image, for: .normal)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginButton)
        loginButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.width.equalTo(loginButton.snp.height).multipliedBy(343 / 48)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
        }
        self.loginButton = loginButton
    }
}
