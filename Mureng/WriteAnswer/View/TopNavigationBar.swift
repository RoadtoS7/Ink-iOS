//
//  TopNavigationTapBar.swift
//  Mureng
//
//  Created by 김수현 on 3/22/24.
//

import UIKit

struct TopNavigationBarItem {
    let title: String
    let action: UIAction
}

class TopNavigationBar: UIView {
    private unowned let viewController: UIViewController
    
    private var hStackView: UIStackView = { hStackView in
        hStackView.axis = .horizontal
        hStackView.distribution = .fill
        hStackView.alignment = .fill
        hStackView.translatesAutoresizingMaskIntoConstraints = false
        return hStackView
    }(UIStackView())
    
    private var backButton: UIButton = {
        $0.frame = .init(x: 0, y: 0, width: 32.0, height: 32.0)
        $0.setImage(Images.leftTouch.image, for: .normal)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIButton())
    
    private var rightStackView: UIStackView = {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .fill
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIStackView())
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: .greatestFiniteMagnitude, height: 44.0)
    }
    
    init(viewController: UIViewController) {
        self.viewController = viewController
        super.init(frame: .zero)
        initLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }
    
    private func initLayout() {
        addSubviews()
        backButton.addTouchAction { _ in
            self.viewController.navigationController?.popViewController(animated: true)
        }
        
        let horizontalPadding: CGFloat = 16.0
        let verticalPadding: CGFloat = 6.0
        NSLayoutConstraint.activate([
            hStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            hStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            hStackView.widthAnchor.constraint(equalTo: widthAnchor, constant: -(horizontalPadding * 2)),
            hStackView.heightAnchor.constraint(equalTo: heightAnchor, constant: -(verticalPadding * 2)),
        ])
        
        let view = UIView()
        view.setContentHuggingPriority(.defaultLow, for: .horizontal)
        hStackView.addArrangedSubview(view)
        
        let rightStackView = UIStackView()
        self.rightStackView = rightStackView
        hStackView.addArrangedSubview(rightStackView)
    }
    
    private func addSubviews() {
        addSubview(hStackView)
        hStackView.addArrangedSubview(backButton)
    }
    
    func addRightButtons(_ items: [TopNavigationBarItem]) {
        items.forEach { item in
            let button = UIButton()
            button.setTitleColor(Colors.Neutral.Label.quaternary.color, for: .normal)
            button.setTitle(item.title, for: .normal)
            button.addAction(item.action, for: .touchUpInside)
            rightStackView.addArrangedSubview(button)
        }
    }
}

class BaseTopNavigationTabBarController: UIViewController {
    private(set) var navigationBar: TopNavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navigationBar = TopNavigationBar(viewController: self)
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navigationBar)
        self.navigationBar = navigationBar
        
        NSLayoutConstraint.activate([
            navigationBar.leadingAnchor.constraint(equalTo: safeAreaLeadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: safeAreaTrailingAnchor),
            navigationBar.bottomAnchor.constraint(equalTo: safeAreaTopAnchor),
        ])
        
        additionalSafeAreaInsets = .init(top: navigationBar.intrinsicContentSize.height, left: 0.0, bottom: 0.0, right: 0.0)
    }
}
