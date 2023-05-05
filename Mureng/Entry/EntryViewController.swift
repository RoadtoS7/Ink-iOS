//
//  SplashViewController.swift
//  Mureng
//
//  Created by nylah.j on 2022/06/13.
//

import UIKit
import ComposableArchitecture

class EntryViewController: UIViewController {
    private var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        loginButton.addTarget(self, action: #selector(navigateToLoginProcess), for: .touchUpInside)
    }
            
    @objc func navigateToLoginProcess() {
        let agreementViewController = AgreementViewController(
          store: Store(
            initialState: AgreementList.State(
              agreements: [
                Agreement.State(text: "[필수] 서비스 이용약관 동의"),
                Agreement.State(text: "[필수] 개인정보 수집/이용 동의"),
              ]
            ),
            reducer: AgreementList()
          )
        )
     
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
