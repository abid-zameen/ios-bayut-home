//
//  RecentSearchesSections.swift
//  Home
//
//  Created by Hammad Shahid on 13/04/2026.
//

import UIKit

// MARK: - Shared Identifier
enum RecentSearchesSectionId: String, SectionIdentifier {
    case title      = "recentSearches.title"
    case carousel   = "recentSearches.carousel"
    
    var displayName: String? { nil }
    var section: HomeSection? { .main }
}

// MARK: - Constants
private enum RecentSearchesLayout {
    static let sectionInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
    static let spacing: CGFloat = 16
    static let cardWidth: CGFloat = 322
    static let cardHeight: CGFloat = 96
}

// MARK: ─────────────────────────────────────────────────────────────
// MARK: 1. Title Section
// MARK: ─────────────────────────────────────────────────────────────
final class RecentSearchesTitleSection: SectionDescriptor {
    typealias Identifier = RecentSearchesSectionId
    let identifier: RecentSearchesSectionId = .title
    
    struct Item: Hashable { let title: String }
    private let title: String
    
    init(title: String, section: HomeSection?) {
        self.title = title
    }
    
    func buildItems() -> [Item] { [Item(title: title)] }
    
    func layoutSection(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        .fullWidthList(sectionInsets: RecentSearchesLayout.sectionInsets)
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
final class RecentSearchesCarouselSection: SectionDescriptor {
    typealias Identifier = RecentSearchesSectionId
    let identifier: RecentSearchesSectionId = .carousel
    
    struct Item: Hashable {
        let model: HomeScreenRecentSearch
        func hash(into hasher: inout Hasher) { hasher.combine(model.id) }
        static func == (lhs: Item, rhs: Item) -> Bool { lhs.model.id == rhs.model.id }
    }
    
    private let searches: [HomeScreenRecentSearch]
    private let actions: RecentSearchesActions
    
    init(searches: [HomeScreenRecentSearch], section: HomeSection?, actions: RecentSearchesActions) {
        self.searches = searches
        self.actions = actions
    }
    
    func buildItems() -> [Item] {
        searches.map { Item(model: $0) }
    }
    
    func layoutSection(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(RecentSearchesLayout.cardWidth),
            heightDimension: .absolute(RecentSearchesLayout.cardHeight)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(RecentSearchesLayout.cardWidth),
            heightDimension: .absolute(RecentSearchesLayout.cardHeight)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        section.interGroupSpacing = 12
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 12,
            leading: 16,
            bottom: 12,
            trailing: 16
        )
        return section
    }
    
    func configureCell(in collectionView: UICollectionView, at indexPath: IndexPath, with item: Item) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentSearchesViewCell.reuseId, for: indexPath) as? RecentSearchesViewCell else { return UICollectionViewCell() }
        cell.configure(with: item.model)
        return cell
    }
    
    func didSelectItem(at indexPath: IndexPath, with item: Item) {
        actions.delegate?.recentSearchesDidTapCard(at: indexPath.row)
    }
}
