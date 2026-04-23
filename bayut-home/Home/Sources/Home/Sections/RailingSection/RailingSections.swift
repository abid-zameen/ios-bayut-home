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

final class RailingCarouselSection: SectionDescriptor, SectionAutoscrollable {
    
    typealias Identifier = RailingSectionId
    let identifier: RailingSectionId = .carousel
    static let infiniteMultiplier = 1000
    var autoscrollInterval: TimeInterval { 2.0 }
    var onInteractionBegan: (() -> Void)?
    
    struct Item: Hashable {
        let type: RailingCellType
        let virtualIndex: Int
    }
    
    private let cellTypes: [RailingCellType]
    let syncState: RailingSyncState
    private let actions: RailingActions
    
    init(cellTypes: [RailingCellType], syncState: RailingSyncState, section: HomeSection?, actions: RailingActions) {
        self.cellTypes = cellTypes
        self.syncState = syncState
        self.actions = actions
        
        self.syncState.onInteractionBegan = { [weak self] in
            self?.onInteractionBegan?()
        }
    }
    
    func scrollToNext(in collectionView: UICollectionView, at sectionIndex: Int) {
        let nextItemIndex = syncState.currentVirtualIndex + 1
        let indexPath = IndexPath(item: nextItemIndex, section: sectionIndex)
        
        let numberOfItems = collectionView.numberOfItems(inSection: sectionIndex)
        if nextItemIndex < numberOfItems {
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    func scrollToPage(_ page: Int, in collectionView: UICollectionView, at sectionIndex: Int) {
        guard cellTypes.count > 0 else { return }
        
        let currentItem = syncState.currentVirtualIndex
        let currentSet = Int(currentItem / cellTypes.count)
        let targetItem = (currentSet * cellTypes.count) + page
        
        let indexPath = IndexPath(item: targetItem, section: sectionIndex)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    func centerIfNeeded(in collectionView: UICollectionView, at sectionIndex: Int) {
        let middleIndex = (RailingCarouselSection.infiniteMultiplier / 2)
        let realCount = cellTypes.count
        
        guard realCount > 0 else { return }
        
        let targetItem = middleIndex * realCount
        let indexPath = IndexPath(item: targetItem, section: sectionIndex)
        
        DispatchQueue.main.async {
           // collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        }
    }
    
    func buildItems() -> [Item] {
        var items: [Item] = []
        let totalVirtualItems = cellTypes.count * Self.infiniteMultiplier
        
        for i in 0..<totalVirtualItems {
            let type = cellTypes[i % cellTypes.count]
            items.append(Item(type: type, virtualIndex: i))
        }
        
        syncState.realCount = cellTypes.count
        return items
    }
    
    func layoutSection(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let isIpad = environment.traitCollection.horizontalSizeClass == .regular
        let horizontalInset: CGFloat = 16
        let interItemSpacing: CGFloat = 16
        
        let visibleWidth = environment.container.contentSize.width - horizontalInset
        let cardWidth: CGFloat = isIpad ? visibleWidth * 0.58 : 340.0
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(cardWidth),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(cardWidth),
            heightDimension: .absolute(157)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.interGroupSpacing = interItemSpacing
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 12,
            leading: 16,
            bottom: 0,
            trailing: 16
        )
        
        section.visibleItemsInvalidationHandler = { [weak syncState, cellCount = cellTypes.count] (visibleItems, offset, env) in
            guard cellCount > 0, let syncState = syncState else { return }
            
            syncState.onInteractionBegan?()
            
            let collectionCenterX = offset.x + (env.container.contentSize.width / 2)
            guard let centeredItem = visibleItems.min(by: {
                abs($0.frame.midX - collectionCenterX) < abs($1.frame.midX - collectionCenterX)
            }) else { return }
            
            let virtualIndex = centeredItem.indexPath.item
            syncState.currentVirtualIndex = virtualIndex
            
            let realIndex = virtualIndex % cellCount
            if syncState.currentPage != realIndex {
                syncState.currentPage = realIndex
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
        viewModel.onCTATap = { [weak self] in
            self?.actions.delegate?.railingDidTapCard(type: item.type)
        }
        cell.configure(with: viewModel)
        return cell
    }
    
    func didSelectItem(at indexPath: IndexPath, with item: Item) {
        actions.delegate?.railingDidTapCard(type: item.type)
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
            estimatedHeight: 12,
            sectionInsets: NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 0, trailing: 16)
        )
    }
    
    func configureCell(in collectionView: UICollectionView, at indexPath: IndexPath, with item: Item) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PageControlCell.reuseId, for: indexPath
        ) as? PageControlCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(numberOfPages: item.numberOfPages, currentPage: syncState.currentPage) { [weak self] page in
            self?.actions.delegate?.railingDidTapPageControl(index: page)
        }
        syncState.onPageChangedHandler = { [weak cell] newPage in
            cell?.updateCurrentPage(newPage)
        }
        
        return cell
    }
}
