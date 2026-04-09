//
//  ShadowRoundedView.swift
//  Home
//
//  Created by Hammad Shahid on 08/04/2026.
//

import UIKit

class ShadowRoundedView: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        self.layer.cornerRadius = 12
        self.layer.shadowColor = UIColor.black.withAlphaComponent(0.1).cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.layer.shadowRadius = 4
        self.layer.masksToBounds = false
        self.backgroundColor = .white
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        // Update shadow path for better performance
        self.layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 12).cgPath
    }
}
