//
//  NearbyLocationsSections.swift
//  Home
//
//  Created by Hammad Shahid on 02/04/2026.
//

import UIKit

// MARK: - Shared Identifier
enum NearbyLocationsSectionId: String, SectionIdentifier {
    case title      = "nearby.title"
    case carousel   = "nearby.carousel"
    case map        = "nearby.map"
    
    var displayName: String? { nil }
    var section: HomeSection? { .main }
}

// MARK: - Constants
private enum NearbyLocationsLayout {
    static let sectionInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
    static let spacing: CGFloat = 16
    
    static let cardWidth: CGFloat = 200
    static let cardHeight: CGFloat = 80
    
    static let mapHeight: CGFloat = 240
}

final class NearbyLocationsTitleSection: SectionDescriptor {
    typealias Identifier = NearbyLocationsSectionId
    let identifier: NearbyLocationsSectionId = .title
    
    struct Item: Hashable { let title: String }
    private let title: String
    
    init(title: String, section: HomeSection?) {
        self.title = title
    }
    
    func buildItems() -> [Item] { [Item(title: title)] }
    
    func layoutSection(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        .fullWidthList(sectionInsets: NearbyLocationsLayout.sectionInsets)
    }
    
    func configureCell(in collectionView: UICollectionView, at indexPath: IndexPath, with item: Item) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCell.reuseId, for: indexPath) as? TitleCell else { return UICollectionViewCell() }
        cell.configure(title: item.title)
        return cell
    }
}

final class NearbyLocationsCarouselSection: SectionDescriptor {
    typealias Identifier = NearbyLocationsSectionId
    let identifier: NearbyLocationsSectionId = .carousel
    
    struct Item: Hashable {
        let location: NearbyLocation
        func hash(into hasher: inout Hasher) { hasher.combine(location.name) }
        static func == (lhs: Item, rhs: Item) -> Bool { lhs.location.name == rhs.location.name }
    }
    
    private let locations: [NearbyLocation]
    private let actions: NearbyLocationsActions
    
    init(locations: [NearbyLocation], section: HomeSection?, actions: NearbyLocationsActions) {
        self.locations = locations
        self.actions = actions
    }
    
    func buildItems() -> [Item] {
        locations.map { Item(location: $0) }
    }
    
    func layoutSection(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(NearbyLocationsLayout.cardHeight)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .estimated(NearbyLocationsLayout.cardWidth),
            heightDimension: .absolute(NearbyLocationsLayout.cardHeight)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = NearbyLocationsLayout.spacing
        section.contentInsets = NSDirectionalEdgeInsets(
            top: NearbyLocationsLayout.spacing,
            leading: 16,
            bottom: 0,
            trailing: 16
        )
        return section
    }
    
    func configureCell(in collectionView: UICollectionView, at indexPath: IndexPath, with item: Item) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NearbyLocationCell.reuseId, for: indexPath) as? NearbyLocationCell else { return UICollectionViewCell() }
        let vm = NearbyLocationCellViewModel(location: item.location)
        cell.configure(with: vm)
        return cell
    }
    
    func didSelectItem(at indexPath: IndexPath, with item: Item) {
        actions.delegate?.nearbyLocationsDidTapCard(at: indexPath.row)
    }
}

final class NearbyLocationMapSection: SectionDescriptor {
    typealias Identifier = NearbyLocationsSectionId
    let identifier: NearbyLocationsSectionId = .map
    
    struct Item: Hashable { let id: String = "map" }
    private let actions: NearbyLocationsActions
    
    init(section: HomeSection?, actions: NearbyLocationsActions) {
        self.actions = actions
    }
    
    func buildItems() -> [Item] { [Item()] }
    
    func layoutSection(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(NearbyLocationsLayout.mapHeight)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(NearbyLocationsLayout.mapHeight)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: NearbyLocationsLayout.spacing,
            leading: 16,
            bottom: 0,
            trailing: 16
        )
        return section
    }
    
    func configureCell(in collectionView: UICollectionView, at indexPath: IndexPath, with item: Item) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MapCell.reuseId, for: indexPath) as? MapCell else { return UICollectionViewCell() }
        let vm = MapCellViewModel { [weak self] in
            self?.actions.delegate?.nearbyLocationsDidTapAllowLocation()
        }
        cell.configure(with: vm)
        return cell
    }
}
