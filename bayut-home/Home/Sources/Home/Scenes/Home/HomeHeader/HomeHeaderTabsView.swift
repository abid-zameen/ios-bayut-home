//
//  HomeHeaderTabsView.swift
//  Home
//
//  Created by Hammad Shahid on 03/04/2026.
//

import UIKit

class HomeHeaderTabsView: UIView {
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 8
        return stack
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 22
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 4
        return view
    }()
    
    private var buttons: [UIButton] = []
    var onTabSelected: ((Int) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        addSubview(containerView)
        containerView.addSubview(stackView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 370),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 44),
            
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 4),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 4),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -4),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -4)
        ])
        
        setupTabs(titles: ["Properties", "New Projects"])
    }
    
    func setupTabs(titles: [String]) {
        buttons.forEach { $0.removeFromSuperview() }
        buttons.removeAll()
        
        for (index, title) in titles.enumerated() {
            let button = UIButton(type: .custom)
            button.setTitle(title, for: .normal)
            button.titleLabel?.font = .headingL4
            button.layer.cornerRadius = 14 // From Figma: 14pt corner radius for active tab
            button.tag = index
            button.addTarget(self, action: #selector(tabTapped(_:)), for: .touchUpInside)
            
            if index == 0 {
                selectButton(button)
            } else {
                deselectButton(button)
            }
            
            stackView.addArrangedSubview(button)
            buttons.append(button)
        }
    }
    
    @objc private func tabTapped(_ sender: UIButton) {
        buttons.forEach { deselectButton($0) }
        selectButton(sender)
        onTabSelected?(sender.tag)
    }
    
    private func selectButton(_ button: UIButton) {
        button.backgroundColor = UIColor(red: 0, green: 173/255, blue: 101/255, alpha: 1.0) // #00AD65
        button.setTitleColor(.white, for: .normal)
    }
    
    private func deselectButton(_ button: UIButton) {
        button.backgroundColor = .clear
        button.setTitleColor(UIColor(red: 102/255, green: 102/255, blue: 102/255, alpha: 1.0), for: .normal) // #666666
    }
}
