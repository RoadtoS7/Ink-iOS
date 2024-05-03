//
//  ToastView.swift
//  Mureng
//
//  Created by 김수현 on 5/4/24.
//

import UIKit

final class ToastView: UIView {
    private let messageLabel: UILabel = .init()
    
    init(message: String) {
        super.init(frame: .zero)
        messageLabel.text = message
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        backgroundColor = Colors.black.color
        clipsToBounds = true
        layer.cornerRadius = 8.0
        
        messageLabel.textColor = Colors.white.color
        addSubview(messageLabel)
        messageLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.left.right.equalToSuperview().inset(10)
        }
    }
    
    static func present(message: String, parentView: UIView) {
        let toastView = ToastView(message: message)
        parentView.addSubview(toastView)
        toastView.alpha = 0
        
        toastView.snp.makeConstraints { make in
            make.height.equalTo(48.0)
            make.bottom.equalTo(parentView.safeAreaLayoutGuide.snp.bottom).offset(-70)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        UIView.animate(withDuration: 2, animations: {
            toastView.alpha = 0.7
        }) { _ in
            toastView.alpha = 0
            toastView.removeFromSuperview()
        }
    }
}
