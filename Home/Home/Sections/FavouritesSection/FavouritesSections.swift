//
//  FavouritesSections.swift
//  Home
//
//  Created by Hammad Shahid on 01/04/2026.
//

import UIKit

// MARK: - Shared Identifier
enum FavouritesSectionId: String, SectionIdentifier {
    case title      = "favourites.title"
    case carousel   = "favourites.carousel"
    case viewAll    = "favourites.viewAll"
    
    var displayName: String? { nil }
    var section: HomeSection? { .main }
}

// MARK: - Constants
private enum FavouritesLayout {
    static let sectionInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
    static let spacing: CGFloat = 16
    
    // Carousel cards
    static let cardWidth: CGFloat = 280
    static let cardHeight: CGFloat = 340
}

// MARK: ─────────────────────────────────────────────────────────────
// MARK: 1. Title Section
// MARK: ─────────────────────────────────────────────────────────────
final class FavouritesTitleSection: SectionDescriptor {
    typealias Identifier = FavouritesSectionId
    let identifier: FavouritesSectionId = .title
    
    struct Item: Hashable { let title: String }
    private let title: String
    
    init(title: String, section: HomeSection?) {
        self.title = title
    }
    
    func buildItems() -> [Item] { [Item(title: title)] }
    
    func layoutSection(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        .fullWidthList(sectionInsets: FavouritesLayout.sectionInsets)
    }
    
    func configureCell(in collectionView: UICollectionView, at indexPath: IndexPath, with item: Item) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCell.reuseId, for: indexPath) as? TitleCell else { return UICollectionViewCell() }
        cell.configure(title: item.title)
        return cell
    }
}

// MARK: ─────────────────────────────────────────────────────────────
// MARK: 2. Carousel Section
// MARK: ─────────────────────────────────────────────────────────────
final class FavouritesCarouselSection: SectionDescriptor {
    typealias Identifier = FavouritesSectionId
    let identifier: FavouritesSectionId = .carousel
    
    struct Item: Hashable {
        let property: FavouriteProperty
        func hash(into hasher: inout Hasher) { hasher.combine(property.id) }
        static func == (lhs: Item, rhs: Item) -> Bool { lhs.property.id == rhs.property.id }
    }
    
    private let properties: [FavouriteProperty]
    private let actions: FavouritesActions
    
    init(properties: [FavouriteProperty], section: HomeSection?, actions: FavouritesActions) {
        self.properties = properties
        self.actions = actions
    }
    
    func buildItems() -> [Item] {
        properties.map { Item(property: $0) }
    }
    
    func layoutSection(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(FavouritesLayout.cardHeight)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(FavouritesLayout.cardWidth),
            heightDimension: .estimated(FavouritesLayout.cardHeight)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = FavouritesLayout.spacing
        section.contentInsets = NSDirectionalEdgeInsets(
            top: FavouritesLayout.spacing,
            leading: 16,
            bottom: 0,
            trailing: 16
        )
        return section
    }
    
    func configureCell(in collectionView: UICollectionView, at indexPath: IndexPath, with item: Item) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavouritesCell.reuseId, for: indexPath) as? FavouritesCell else { return UICollectionViewCell() }
        let vm = FavouriteCellViewModel(
            id: item.property.id,
            price: item.property.price,
            beds: item.property.beds,
            baths: item.property.baths,
            area: item.property.area,
            location: item.property.location,
            imageUrl: item.property.imageURL
        )
        cell.configure(with: vm)
        return cell
    }
    
    func didSelectItem(at indexPath: IndexPath, with item: Item) {
        actions.delegate?.favouritesDidTapCard(at: indexPath.row)
    }
}

// MARK: ─────────────────────────────────────────────────────────────
// MARK: 3. View All Section
// MARK: ─────────────────────────────────────────────────────────────
final class FavouritesViewAllSection: SectionDescriptor {
    typealias Identifier = FavouritesSectionId
    let identifier: FavouritesSectionId = .viewAll
    
    struct Item: Hashable { let buttonTitle: String }
    private let buttonTitle: String
    private let actions: FavouritesActions
    
    init(buttonTitle: String, section: HomeSection?, actions: FavouritesActions) {
        self.buttonTitle = buttonTitle
        self.actions = actions
    }
    
    func buildItems() -> [Item] { [Item(buttonTitle: buttonTitle)] }
    
    func layoutSection(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        .fullWidthList(
            sectionInsets: NSDirectionalEdgeInsets(
                top: FavouritesLayout.spacing,
                leading: 0,
                bottom: FavouritesLayout.spacing,
                trailing: 0
            )
        )
    }
    
    func configureCell(in collectionView: UICollectionView, at indexPath: IndexPath, with item: Item) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ViewMoreCell.reuseId, for: indexPath) as? ViewMoreCell else { return UICollectionViewCell() }
        cell.configure(buttonTitle: item.buttonTitle) { [weak self] in
            self?.actions.delegate?.favouritesDidTapViewAll()
        }
        return cell
    }
}
