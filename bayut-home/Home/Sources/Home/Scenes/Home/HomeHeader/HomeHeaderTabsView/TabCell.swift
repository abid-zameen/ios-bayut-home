//
//  TabCell.swift
//  Home
//
//  Created by Hammad Shahid on 14/04/2026.
//

import UIKit

final class TabCell: UICollectionViewCell {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .headingL4
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(titleLabel)
        self.setRoundedWithRespectToHeight(shouldClipToBounds: true)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String, isSelected: Bool) {
        titleLabel.text = title
        if isSelected {
            backgroundColor = .green5
            titleLabel.textColor = .white
        } else {
            backgroundColor = .clear
            titleLabel.textColor = .grey5
        }
    }
}
