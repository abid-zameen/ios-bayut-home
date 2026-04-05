//
//  HomeHeaderAISearchView.swift
//  Home
//
//  Created by Hammad Shahid on 03/04/2026.
//

import UIKit

class HomeHeaderAISearchView: UIView {
    
    // MARK: - UI Components
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 26
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 4
        view.heightAnchor.constraint(equalToConstant: 52).isActive = true
        return view
    }()
    
    private let aiIcon: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "AI-Stars-Icon") // Assuming this asset exists or using a placeholder
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let aiLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Search your dream home with AI"
        lbl.textColor = .darkGray
        lbl.font = .systemFont(ofSize: 15, weight: .medium)
        return lbl
    }()
    
    private let aiBadge: UILabel = {
        let lbl = UILabel()
        lbl.text = "AI"
        lbl.textColor = .white
        lbl.backgroundColor = UIColor(red: 0, green: 173/255, blue: 101/255, alpha: 1.0)
        lbl.font = .systemFont(ofSize: 10, weight: .bold)
        lbl.textAlignment = .center
        lbl.layer.cornerRadius = 4
        lbl.clipsToBounds = true
        lbl.widthAnchor.constraint(equalToConstant: 20).isActive = true
        lbl.heightAnchor.constraint(equalToConstant: 14).isActive = true
        return lbl
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - Setup
    private func setupView() {
        addSubview(containerView)
        containerView.addSubview(aiIcon)
        containerView.addSubview(aiLabel)
        containerView.addSubview(aiBadge)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        aiIcon.translatesAutoresizingMaskIntoConstraints = false
        aiLabel.translatesAutoresizingMaskIntoConstraints = false
        aiBadge.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 343),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            aiIcon.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            aiIcon.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            aiIcon.widthAnchor.constraint(equalToConstant: 24),
            aiIcon.heightAnchor.constraint(equalToConstant: 24),
            
            aiLabel.leadingAnchor.constraint(equalTo: aiIcon.trailingAnchor, constant: 12),
            aiLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            aiBadge.leadingAnchor.constraint(greaterThanOrEqualTo: aiLabel.trailingAnchor, constant: 8),
            aiBadge.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            aiBadge.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
    }
    
    // MARK: - Animation Support
    func setProgress(_ progress: CGFloat) {
        let activeColor = UIColor(red: 0, green: 173/255, blue: 101/255, alpha: 1.0)
        
        // Keep background white as requested
        containerView.backgroundColor = .white
        
        // Text and Badge colors
        aiLabel.textColor = progress > 0.5 ? .black : .darkGray
        aiBadge.backgroundColor = activeColor
        aiBadge.textColor = .white
        aiIcon.tintColor = activeColor
    }
}
