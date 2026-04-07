//
//  RailingSections.swift
//  Home
//
//  Created by Hammad Shahid on 01/04/2026.
//

import UIKit

// MARK: - Shared Identifier
enum RailingSectionId: String, SectionIdentifier {
    case carousel    = "railing.carousel"
    case pageControl = "railing.pageControl"
    
    var displayName: String? { nil }
    var section: HomeSection? { .main }
}

final class RailingCarouselSection: SectionDescriptor {
    typealias Identifier = RailingSectionId
    
    let identifier: RailingSectionId = .carousel
    
    struct Item: Hashable {
        let type: RailingCellType
    }
    
    private let cellTypes: [RailingCellType]
    private let syncState: RailingSyncState
    private let actions: RailingActions
    
    init(cellTypes: [RailingCellType], syncState: RailingSyncState, section: HomeSection?, actions: RailingActions) {
        self.cellTypes = cellTypes
        self.syncState = syncState
        self.actions = actions
    }
    
    func buildItems() -> [Item] {
        cellTypes.map { Item(type: $0) }
    }
    
    func layoutSection(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let isIpad = environment.traitCollection.horizontalSizeClass == .regular
        let horizontalInset: CGFloat = isIpad ? 0 : 22
        let interItemSpacing: CGFloat = 4
        
        let visibleWidth = environment.container.contentSize.width - horizontalInset
        let cardWidth: CGFloat = isIpad ? visibleWidth * 0.58 : 340.0
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(cardWidth),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(cardWidth),
            heightDimension: .absolute(isIpad ? 220 : 190)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.interGroupSpacing = interItemSpacing
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 16,
            leading: horizontalInset / 2,
            bottom: 0,
            trailing: horizontalInset / 2
        )
        
        // MARK: Native Auto-Sync -> Write index downstream dynamically
        section.visibleItemsInvalidationHandler = { [weak syncState] (visibleItems, offset, env) in
            let collectionCenterX = offset.x + (env.container.contentSize.width / 2)
            guard let centeredItem = visibleItems.min(by: {
                abs($0.frame.midX - collectionCenterX) < abs($1.frame.midX - collectionCenterX)
            }) else { return }
            
            let index = centeredItem.indexPath.item
            if syncState?.currentPage != index { // Prevent duplicate firing freezes
                syncState?.currentPage = index
            }
        }
        
        return section
    }
    
    func configureCell(in collectionView: UICollectionView, at indexPath: IndexPath, with item: Item) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: RailingCardCell.reuseId, for: indexPath
        ) as? RailingCardCell else {
            return UICollectionViewCell()
        }
        let viewModel = RailingCardCellViewModel(type: item.type)
        cell.configure(with: viewModel)
        return cell
    }
    
    func didSelectItem(at indexPath: IndexPath, with item: Item) {
        actions.delegate?.railingDidTapCard(at: indexPath.item)
    }
}

final class RailingPageControlSection: SectionDescriptor {
    typealias Identifier = RailingSectionId
    
    let identifier: RailingSectionId = .pageControl
    
    struct Item: Hashable {
        let numberOfPages: Int
    }
    
    private let numberOfPages: Int
    private let syncState: RailingSyncState
    private let actions: RailingActions
    
    init(numberOfPages: Int, syncState: RailingSyncState, section: HomeSection?, actions: RailingActions) {
        self.numberOfPages = numberOfPages
        self.syncState = syncState
        self.actions = actions
    }
    
    func buildItems() -> [Item] {
        [Item(numberOfPages: numberOfPages)]
    }
    
    func layoutSection(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        return .fullWidthList(
            estimatedHeight: 40,
            sectionInsets: NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
        )
    }
    
    func configureCell(in collectionView: UICollectionView, at indexPath: IndexPath, with item: Item) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PageControlCell.reuseId, for: indexPath
        ) as? PageControlCell else {
            return UICollectionViewCell()
        }
        
        // Primary Initialization Binding
        cell.configure(numberOfPages: item.numberOfPages, currentPage: syncState.currentPage) { [weak self] page in
            self?.actions.delegate?.railingDidTapPageControl(index: page)
        }
        
        // Reverse Listener - Carousel writes to syncState -> Updates cell UI in real-time
        syncState.onPageChangedHandler = { [weak cell] newPage in
            cell?.updateCurrentPage(newPage)
        }
        
        return cell
    }
}
