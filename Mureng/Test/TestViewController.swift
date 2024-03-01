//
//  TestViewController.swift
//  Mureng
//
//  Created by 김수현 on 3/1/24.
//

import UIKit

class TestViewController: UIViewController {
    private var scrollView: UIScrollView!
    private var contentView: UIView!
    private var questionHeaderView: QuestionHeaderView!
    let testQuestion: Question = Question(id: 0, content: "this is eng title", koreanContent: "이것은 한국어 컨텐츠 입니다.")
    private var divider: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
        setupContentView()
        setupHeaderView()
        setupDivider()
    }
    
    private func setupScrollView() {
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    
    private func setupContentView() {
        contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        contentView.backgroundColor = .yellow
    }
    
    private func setupHeaderView() {
        questionHeaderView = QuestionHeaderView(question: testQuestion)
        questionHeaderView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(questionHeaderView)
        
        NSLayoutConstraint.activate([
            questionHeaderView.topAnchor.constraint(equalTo: contentView.topAnchor),
            questionHeaderView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            questionHeaderView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
        
        // Ensure the contentView's bottom is pinned to the last view
        NSLayoutConstraint.activate([
            contentView.bottomAnchor.constraint(equalTo: questionHeaderView.bottomAnchor)
        ])
    }
    
    private func setupDivider() {
        self.divider = UIView()
        divider.backgroundColor = Colors.Greyscale.greyscale200.color
        divider.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(divider)
        
        NSLayoutConstraint.activate([
            divider.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            divider.topAnchor.constraint(equalTo: questionHeaderView.bottomAnchor, constant: 26),
            divider.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            divider.heightAnchor.constraint(equalToConstant: 1),
        ])
    }
}
