//
//  LocationChipsCell.swift
//  Home
//
//  Created by Hammad Shahid on 01/04/2026.
//

import UIKit

final class LocationChipsCollectionViewCell: HighlightableCollectionViewCell {

    // MARK: - IBOutlets
    @IBOutlet private weak var chipsBackgroundView: UIView?
    @IBOutlet private weak var locName: UILabel?
    
    // MARK: - Properties
    var chip: LocationChipViewModel?
    
    // MARK: - View Cycle
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        chipsBackgroundView?.layer.cornerRadius = bounds.height / 2
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    override func configure(with any: Any) {
          guard let chip = any as? LocationChipViewModel else { return }
          self.chip = chip
          locName?.text = chip.localizedName
          setupWithViewModel()
      }
}

    // MARK: - Setup
private extension LocationChipsCollectionViewCell {
    func setupViews() {
        chipsBackgroundView?.clipsToBounds = true
        chipsBackgroundView?.layer.borderWidth = 1.0
        chipsBackgroundView?.layer.borderColor = UIColor.AppColors.green2.cgColor
        chipsBackgroundView?.backgroundColor = UIColor.AppColors.green1
        locName?.font = UIFont.appBoldFont(ofSize: 14.0)
    }
    
    func setupWithViewModel() {
        guard let chip = chip else { return }
        if chip.isSelected {
            chipsBackgroundView?.layer.borderColor = UIColor.AppColors.green2.cgColor
            chipsBackgroundView?.backgroundColor = UIColor.AppColors.green1
            locName?.font = UIFont.appBoldFont(ofSize: 14)
            locName?.textColor = UIColor.AppColors.green7
        } else {
            chipsBackgroundView?.layer.borderColor = UIColor.AppColors.grey2.cgColor
            chipsBackgroundView?.backgroundColor = .clear
            locName?.font = UIFont.appRegularFont(ofSize: 14)
            locName?.textColor = UIColor.AppColors.grey5
        }
    }
}
