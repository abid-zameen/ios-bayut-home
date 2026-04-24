//
//  WhatsappButton.swift
//  Home
//
//  Created by Hammad Shahid on 13/04/2026.
//

import UIKit

final class WhatsappButton: UIButton {
    
    //MARK: - Inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setups()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setups()
    }
    
    //MARK: - Configurations
    
    private func setups(){
        backgroundColor = UIColor.AppColors.green1
        titleLabel?.font = UIFont.appBoldFont(ofSize: 16)
        layer.borderColor = UIColor.clear.cgColor
        layer.cornerRadius = 8.0
        setImage(UIImage(named: Constants.whatsappImage, in: .module, with: nil)?.withRenderingMode(.alwaysOriginal), for: .normal)
        setTitle(Constants.whatsapp, for: .normal)
        setTitleColor(UIColor.AppColors.green7, for: .normal)
        updateInsets()
        adjustsImageWhenHighlighted = false
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        setBackgroundColor(color: UIColor.AppColors.green2, forState: .highlighted)
    }
    
    private func updateInsets() {
        if HomeModule.shared.environment.appLanguage  != "ar" {
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 0)
        } else {
           imageEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
           titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 4)
        }
    }
    
    func hideTitle(_ isHidden: Bool) {
        if isHidden {
            setTitle("", for: .normal)
            imageEdgeInsets = .zero
            titleEdgeInsets = .zero
        } else {
            setTitle(Constants.whatsapp, for: .normal)
            updateInsets()
        }
    }
    
    @objc private func buttonTapped() {
        backgroundColor = UIColor.AppColors.green1
    }
}

private enum Constants {
    static let whatsappImage = "whatsapp"
    static let whatsapp = "WhatsApp"
}


