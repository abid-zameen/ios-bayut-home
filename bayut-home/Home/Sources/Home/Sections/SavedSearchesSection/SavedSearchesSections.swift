//
//  SavedSearchesSections.swift
//  Home
//
//  Created by Hammad Shahid on 02/04/2026.
//

import UIKit

// MARK: - Shared Identifier
enum SavedSearchesSectionId: String, SectionIdentifier {
    case title      = "savedSearches.title"
    case carousel   = "savedSearches.carousel"
    case viewAll    = "savedSearches.viewAll"
    
    var displayName: String? { nil }
    var section: HomeSection? { .main }
}

// MARK: - Constants
private enum SavedSearchesLayout {
    static let sectionInsets = NSDirectionalEdgeInsets(top: 38, leading: 16, bottom: 0, trailing: 16)
    static let spacing: CGFloat = 16
    static let cardWidth: CGFloat = 280
    static let estimatedCardHeight: CGFloat = 100
}

final class SavedSearchesTitleSection: SectionDescriptor {
    typealias Identifier = SavedSearchesSectionId
    let identifier: SavedSearchesSectionId = .title
    
    struct Item: Hashable { let title: String }
    private let title: String
    
    init(title: String, section: HomeSection?) {
        self.title = title
    }
    
    func buildItems() -> [Item] { [Item(title: title)] }
    
    func layoutSection(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        .fullWidthList(sectionInsets: SavedSearchesLayout.sectionInsets)
    }
    
    func configureCell(in collectionView: UICollectionView, at indexPath: IndexPath, with item: Item) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCell.reuseId, for: indexPath) as? TitleCell else { return UICollectionViewCell() }
        cell.configure(title: item.title)
        return cell
    }
}

final class SavedSearchesCarouselSection: SectionDescriptor {
    typealias Identifier = SavedSearchesSectionId
    let identifier: SavedSearchesSectionId = .carousel
    
    struct Item: Hashable {
        let id: String
        let search: SavedSearchesModel?
        func hash(into hasher: inout Hasher) { hasher.combine(id) }
        static func == (lhs: Item, rhs: Item) -> Bool { lhs.id == rhs.id }
    }
    
    private let state: Home.DataState<[SavedSearchesModel]>
    private let actions: SavedSearchesActions
    
    init(state: Home.DataState<[SavedSearchesModel]>, section: HomeSection?, actions: SavedSearchesActions) {
        self.state = state
        self.actions = actions
    }
    
    func buildItems() -> [Item] {
        switch state {
        case .loading:
            return (0..<4).map { Item(id: "shimmer.\($0)", search: nil) }
        case .data(let searches):
            return searches.map { Item(id: $0.name, search: $0) }
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
            heightDimension: .estimated(SavedSearchesLayout.estimatedCardHeight)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(SavedSearchesLayout.estimatedCardHeight)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.interGroupSpacing = SavedSearchesLayout.spacing
        section.contentInsets = NSDirectionalEdgeInsets(
            top: SavedSearchesLayout.spacing,
            leading: 0,
            bottom: 0,
            trailing: 0
        )
        return section
    }
    
    func configureCell(in collectionView: UICollectionView, at indexPath: IndexPath, with item: Item) -> UICollectionViewCell {
        if case .loading = state {
            return collectionView.dequeueReusableCell(withReuseIdentifier: SavedSearchesShimmerCell.reuseId, for: indexPath)
        }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SavedSearchesCell.reuseId, for: indexPath) as? SavedSearchesCell else { return UICollectionViewCell() }
        if let search = item.search {
            let vm = SavedSearchesCellViewModel(search: search)
            cell.configure(with: vm)
        }
        return cell
    }
    
    func didSelectItem(at indexPath: IndexPath, with item: Item) {
        if case .data = state, let _ = item.search {
            actions.delegate?.savedSearchesDidTapCard(at: indexPath.row)
        }
    }
}

final class SavedSearchesViewAllSection: SectionDescriptor {
    typealias Identifier = SavedSearchesSectionId
    let identifier: SavedSearchesSectionId = .viewAll
    
    struct Item: Hashable { let buttonTitle: String }
    private let buttonTitle: String
    private let actions: SavedSearchesActions
    
    init(buttonTitle: String, section: HomeSection?, actions: SavedSearchesActions) {
        self.buttonTitle = buttonTitle
        self.actions = actions
    }
    
    func buildItems() -> [Item] { [Item(buttonTitle: buttonTitle)] }
    
    func layoutSection(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        .fullWidthList(
            sectionInsets: NSDirectionalEdgeInsets(
                top: 0,
                leading: 0,
                bottom: 0,
                trailing: 0
            )
        )
    }
    
    func configureCell(in collectionView: UICollectionView, at indexPath: IndexPath, with item: Item) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ViewMoreCell.reuseId, for: indexPath) as? ViewMoreCell else { return UICollectionViewCell() }
        cell.configure(buttonTitle: item.buttonTitle) { [weak self] in
            self?.actions.delegate?.savedSearchesDidTapViewAll()
        }
        return cell
    }
}
