//
//  FavouritesCell.swift
//  Home
//
//  Created by Hammad Shahid on 01/04/2026.
//

import UIKit

struct FavouriteCellViewModel: Hashable {
    let id: String
    let price: String
    let beds: String
    let baths: String
    let area: String
    let location: String
    let imageUrl: URL?
}

class FavouritesCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var propertyImage: UIImageView?
    @IBOutlet private weak var priceLabel: UILabel?
    @IBOutlet private weak var bedsLabel: UILabel?
    @IBOutlet private weak var bathsLabel: UILabel?
    @IBOutlet private weak var areaLabel: UILabel?
    @IBOutlet private weak var locationLabel: UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    func configure(with viewModel: FavouriteCellViewModel) {
        priceLabel?.text = viewModel.price
        bedsLabel?.text = viewModel.beds
        bathsLabel?.text = viewModel.baths
        areaLabel?.text = viewModel.area
        locationLabel?.text = viewModel.location
        
        // Image loading logic would go here (e.g. SDWebImage)
        // propertyImage?.sd_setImage(with: viewModel.imageUrl)
    }
}

private extension FavouritesCell {
    func setupViews() {
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
        
        // Add shadow to the cell if needed, or rely on mainContentView
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        clipsToBounds = false
    }
}
