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
    static let sectionInsets = NSDirectionalEdgeInsets(top: .sectionTopSpace, leading: .standard, bottom: .zero, trailing: .standard)
    static let purposeHeight: CGFloat = 40
    static let cardWidth: CGFloat = 217
    static let cardHeight: CGFloat = 64
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
        item.contentInsets = NSDirectionalEdgeInsets(top: .zero, leading: .tiny, bottom: .zero, trailing: .tiny)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(PopularSearchLayout.purposeHeight)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: .standard, leading: .small, bottom: .zero, trailing: .small)
        return section
    }
    
    func configureCell(in collectionView: UICollectionView, at indexPath: IndexPath, with item: Item) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PopularSearchPurposeCell.reuseId, for: indexPath) as? PopularSearchPurposeCell else { return UICollectionViewCell() }
        let vm = PopularSearchPurposeCellViewModel(title: item.purpose.rawValue, isSelected: item.isSelected)
        cell.configure(with: vm)
        return cell
    }
    
    func didSelectItem(at indexPath: IndexPath, with item: Item) {
        actions.delegate?.popularSearchDidSelectPurpose(at: indexPath.item, purpose: item.purpose)
    }
}

final class PopularSearchCarouselSection: SectionDescriptor {
    typealias Identifier = PopularSearchSectionId
    let identifier: PopularSearchSectionId = .carousel
    
    struct Item: Hashable {
        let id: String
        let search: PopularSearch?
        func hash(into hasher: inout Hasher) { hasher.combine(id) }
        static func == (lhs: Item, rhs: Item) -> Bool { lhs.id == rhs.id }
    }
    
    private let state: Home.DataState<[PopularSearch]>
    private let actions: PopularSearchActions
    
    init(state: Home.DataState<[PopularSearch]>, section: HomeSection?, actions: PopularSearchActions) {
        self.state = state
        self.actions = actions
    }
    
    var isShimmering: Bool {
        if case .loading = state { return true }
        return false
    }
    
    func buildItems() -> [Item] {
        switch state {
        case .loading:
            return (0..<3).map { Item(id: "shimmer.\($0)", search: nil) }
        case .data(let searches):
            return searches.map { Item(id: $0.title, search: $0) }
        case .empty:
            return []
        }
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
        section.interGroupSpacing = .small
        section.contentInsets = NSDirectionalEdgeInsets(
            top: .standard,
            leading: .standard,
            bottom: .zero,
            trailing: .standard
        )
        return section
    }
    
    func configureCell(in collectionView: UICollectionView, at indexPath: IndexPath, with item: Item) -> UICollectionViewCell {
        if case .loading = state {
            return collectionView.dequeueReusableCell(withReuseIdentifier: PopularSearchShimmerCell.reuseId, for: indexPath)
        }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PopularSearchCell.reuseId, for: indexPath) as? PopularSearchCell else { return UICollectionViewCell() }
        if let search = item.search {
            let vm = PopularSearchCellViewModel(search: search)
            cell.configure(with: vm)
        }
        return cell
    }
    
    func didSelectItem(at indexPath: IndexPath, with item: Item) {
        if case .data = state, let _ = item.search {
            actions.delegate?.popularSearchDidSelectSearchItem(at: indexPath.row)
        }
    }
}
