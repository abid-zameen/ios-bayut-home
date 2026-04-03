//
//  PopularSearchSections.swift
//  Home
//
//  Created by Hammad Shahid on 03/04/2026.
//

import UIKit

// MARK: - Shared Identifier
enum PopularSearchSectionId: String, SectionIdentifier {
    case title      = "popularSearch.title"
    case purpose    = "popularSearch.purpose"
    case carousel   = "popularSearch.carousel"
    
    var displayName: String? { nil }
    var section: HomeSection? { .main }
}

// MARK: - Constants
private enum PopularSearchLayout {
    static let sectionInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
    static let spacing: CGFloat = 12
    static let purposeHeight: CGFloat = 40
    static let cardWidth: CGFloat = 160
    static let cardHeight: CGFloat = 72
}

final class PopularSearchTitleSection: SectionDescriptor {
    typealias Identifier = PopularSearchSectionId
    let identifier: PopularSearchSectionId = .title
    
    struct Item: Hashable { let title: String }
    private let title: String
    
    init(title: String, section: HomeSection?) {
        self.title = title
    }
    
    func buildItems() -> [Item] { [Item(title: title)] }
    
    func layoutSection(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        .fullWidthList(sectionInsets: PopularSearchLayout.sectionInsets)
    }
    
    func configureCell(in collectionView: UICollectionView, at indexPath: IndexPath, with item: Item) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCell.reuseId, for: indexPath) as? TitleCell else { return UICollectionViewCell() }
        cell.configure(title: item.title)
        return cell
    }
}

final class PopularSearchPurposeSection: SectionDescriptor {
    typealias Identifier = PopularSearchSectionId
    let identifier: PopularSearchSectionId = .purpose
    
    struct Item: Hashable {
        let purpose: PopularSearchPurpose
        let isSelected: Bool
    }
    
    private let purposes: [PopularSearchPurpose]
    private let selectedPurpose: PopularSearchPurpose
    private let actions: PopularSearchActions
    
    init(purposes: [PopularSearchPurpose], selectedPurpose: PopularSearchPurpose, section: HomeSection?, actions: PopularSearchActions) {
        self.purposes = purposes
        self.selectedPurpose = selectedPurpose
        self.actions = actions
    }
    
    func buildItems() -> [Item] {
        purposes.map { Item(purpose: $0, isSelected: $0 == selectedPurpose) }
    }
    
    func layoutSection(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let itemCount = CGFloat(max(1, purposes.count))
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0 / itemCount),
            heightDimension: .absolute(PopularSearchLayout.purposeHeight)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 4)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(PopularSearchLayout.purposeHeight)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12)
        return section
    }
    
    func configureCell(in collectionView: UICollectionView, at indexPath: IndexPath, with item: Item) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PopularSearchPurposeCell", for: indexPath) as? PopularSearchPurposeCell else { return UICollectionViewCell() }
        let vm = PopularSearchPurposeCellViewModel(title: item.purpose.rawValue, isSelected: item.isSelected)
        cell.configure(with: vm)
        return cell
    }
    
    func didSelectItem(at indexPath: IndexPath, with item: Item) {
        actions.delegate?.popularSearchDidSelectPurpose(item.purpose)
    }
}

final class PopularSearchCarouselSection: SectionDescriptor {
    typealias Identifier = PopularSearchSectionId
    let identifier: PopularSearchSectionId = .carousel
    
    struct Item: Hashable {
        let search: PopularSearch
        func hash(into hasher: inout Hasher) { hasher.combine(search.title) }
        static func == (lhs: Item, rhs: Item) -> Bool { lhs.search.title == rhs.search.title }
    }
    
    private let searches: [PopularSearch]
    private let actions: PopularSearchActions
    
    init(searches: [PopularSearch], section: HomeSection?, actions: PopularSearchActions) {
        self.searches = searches
        self.actions = actions
    }
    
    func buildItems() -> [Item] {
        searches.map { Item(search: $0) }
    }
    
    func layoutSection(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(PopularSearchLayout.cardHeight)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .estimated(PopularSearchLayout.cardWidth),
            heightDimension: .estimated(PopularSearchLayout.cardHeight)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = PopularSearchLayout.spacing
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 8,
            leading: 16,
            bottom: 16,
            trailing: 16
        )
        return section
    }
    
    func configureCell(in collectionView: UICollectionView, at indexPath: IndexPath, with item: Item) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PopularSearchCell", for: indexPath) as? PopularSearchCell else { return UICollectionViewCell() }
        let vm = PopularSearchCellViewModel(search: item.search)
        cell.configure(with: vm)
        return cell
    }
    
    func didSelectItem(at indexPath: IndexPath, with item: Item) {
        actions.delegate?.popularSearchDidSelectSearchItem(at: indexPath.row)
    }
}
