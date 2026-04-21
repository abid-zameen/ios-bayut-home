//
//  RecentSearchesViewCell.swift
//  Home
//
//  Created by Hammad Shahid on 10/04/2026.
//

import UIKit

final class RecentSearchesViewCell: UICollectionViewCell {
        
    // MARK: - Outlets
    @IBOutlet private weak var containerView: UIView?
    @IBOutlet private weak var recentImageView: UIImageView?
    @IBOutlet private weak var recentImageContainerView: UIView?
    @IBOutlet private weak var titleLabel: UILabel?
    @IBOutlet private weak var subtitleLabel: UILabel?
    @IBOutlet private weak var filterStackView: UIStackView?
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        recentImageView?.image = UIImage(named: "image-placeholder")
        titleLabel?.text = nil
        subtitleLabel?.text = nil
        filterStackView?.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
    
    // MARK: - Configuration
    func configure(with model: HomeScreenRecentSearch) {
        if let urlString = model.imageURL, let imageUrl = URL(string: urlString) {
            recentImageView?.loadImage(with: imageUrl)
        } else {
            recentImageView?.image = UIImage(named: "image-placeholder", in: .module, compatibleWith: nil)
        }
        
        if !model.locations.isEmpty {
            titleLabel?.text = model.locations.joined(separator: ", ")
        } else {
            titleLabel?.text = model.title
        }
        
        subtitleLabel?.text = model.subtitle
        
        setupFilterChips(filters: model.filters)
    }
    
}

// MARK: - Setup
private extension RecentSearchesViewCell {
    func setupViews() {
        self.clipsToBounds = false
        contentView.clipsToBounds = false
        
        containerView?.backgroundColor = .white
        containerView?.layer.cornerRadius = 12
        containerView?.clipsToBounds = false
        
        containerView?.sketchShadow(
            shadowColor: UIColor.black,
            height: 2,
            shadowOpacity: 0.08,
            shadowRadius: 6
        )
        
        recentImageView?.setRoundedCorner(radius: 6)
        recentImageView?.setBorder(.white, width: 2)
        
        recentImageContainerView?.setRoundedCorner(radius: 6)
        recentImageContainerView?.sketchShadow(
            shadowColor: UIColor.black,
            height: 2,
            shadowOpacity: 0.2,
            shadowRadius: 6
        )
        
        titleLabel?.font = UIFont.semiBoldBody
        titleLabel?.textColor = UIColor.AppColors.grey7
        
        subtitleLabel?.font = UIFont.body
        subtitleLabel?.textColor = UIColor.AppColors.grey7
    }
    
    func setupFilterChips(filters: [HomeScreenRecentSearchFilter]) {
        guard let filterStackView = filterStackView else { return }
        filterStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let viewModel = RecentSearchesFilterChipsViewModel(filters: filters)
        let presentation = viewModel.present()
        
        var chipTexts: [String] = []
        if filters.isEmpty {
            chipTexts.append("All Filters".localized())
        } else {
            if let first = presentation.first { chipTexts.append(first) }
            if let second = presentation.second { chipTexts.append(second) }
            if let plus = presentation.plusText { chipTexts.append(plus) }
        }
        
        for text in chipTexts {
            let chipView = createFilterChip(with: text)
            filterStackView.addArrangedSubview(chipView)
        }
        
        let spacer = UIView()
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        filterStackView.addArrangedSubview(spacer)
    }
    
    func createFilterChip(with text: String) -> UIView {
        let label = UILabel()
        label.text = text
        label.font = UIFont.body0
        label.textColor = UIColor.AppColors.grey7
        label.backgroundColor = UIColor.AppColors.grey1
        label.layer.cornerRadius = 6
        label.clipsToBounds = true
        
        let container = UIView()
        container.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: container.topAnchor, constant: 3),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -3),
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8)
        ])
        
        container.backgroundColor = UIColor.AppColors.grey1
        container.layer.cornerRadius = 6
        
        return container
    }
}
