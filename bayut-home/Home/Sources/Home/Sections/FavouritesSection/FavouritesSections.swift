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
        let id: String
        let property: Property?
        func hash(into hasher: inout Hasher) { hasher.combine(id) }
        static func == (lhs: Item, rhs: Item) -> Bool { lhs.id == rhs.id }
    }
    
    private let state: Home.DataState<[Property]>
    private let actions: FavouritesActions
    
    init(state: Home.DataState<[Property]>, section: HomeSection?, actions: FavouritesActions) {
        self.state = state
        self.actions = actions
    }
    
    func buildItems() -> [Item] {
        switch state {
        case .loading:
            return (0..<3).map { Item(id: "shimmer.\($0)", property: nil) }
        case .data(let properties):
            return properties.map { Item(id: $0.id, property: $0) }
        case .empty:
            return []
        }
    }
    
    func layoutSection(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        Self.getLayout(environment: environment)
    }

    static func getLayout(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(FavouritesLayout.cardHeight)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(FavouritesLayout.cardHeight)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.interGroupSpacing = 0
        section.contentInsets = NSDirectionalEdgeInsets(
            top: FavouritesLayout.spacing,
            leading: 0,
            bottom: 0,
            trailing: 0
        )
        return section
    }
    
    func configureCell(in collectionView: UICollectionView, at indexPath: IndexPath, with item: Item) -> UICollectionViewCell {
        if case .loading = state {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "FavoritesShimmerCell", for: indexPath)
        }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavouritesCell.reuseId, for: indexPath) as? FavouritesCell else { return UICollectionViewCell() }
        if let property = item.property {
            let vm = FavouriteCellViewModel(property: property)
            cell.configure(with: vm)
        }
        return cell
    }
    
    func didSelectItem(at indexPath: IndexPath, with item: Item) {
        if case .data = state, let property = item.property {
            actions.delegate?.favouritesDidTapCard(at: indexPath.row, with: property.id)
        }
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
