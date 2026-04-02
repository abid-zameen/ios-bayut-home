//
//  NewProjectsSections.swift
//  Home
//
//  Created by Hammad Shahid on 01/04/2026.
//

import UIKit

// MARK: - Shared Identifier
/// Single identifier type reused across all sub-sections.
/// The `rawValue` is unique per sub-section so each gets its own diffable slot.
enum NewProjectsSectionId: String, SectionIdentifier {
    case title      = "newProjects.title"
    case locations  = "newProjects.locations"
    case projects   = "newProjects.projects"
    case viewAll    = "newProjects.viewAll"
    
    var displayName: String? { nil }
    var section: HomeSection? { .main }
}

// MARK: - Constants
private enum NewProjectsLayout {
    static let sectionInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
    static let spacing: CGFloat = 16
    
    // Location chips
    static let chipHeight: CGFloat = 36
    static let chipSpacing: CGFloat = 8
    
    // Project cards
    static let cardWidth: CGFloat = 220
    static let cardHeight: CGFloat = 280
}

final class NewProjectsTitleSection: SectionDescriptor {
    typealias Identifier = NewProjectsSectionId
    
    let identifier: NewProjectsSectionId = .title
    
    struct Item: Hashable {
        let title: String
    }
    
    private let title: String
    
    init(title: String, section: HomeSection?) {
        self.title = title
    }
    
    func buildItems() -> [Item] {
        [Item(title: title)]
    }
    
    func layoutSection(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        .fullWidthList(sectionInsets: NewProjectsLayout.sectionInsets)
    }
    
    func configureCell(in collectionView: UICollectionView, at indexPath: IndexPath, with item: Item) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TitleCell.reuseId, for: indexPath
        ) as? TitleCell else {
            return UICollectionViewCell()
        }
        cell.configure(title: item.title)
        return cell
    }
}


final class NewProjectsLocationsSection: SectionDescriptor {
    typealias Identifier = NewProjectsSectionId
    
    let identifier: NewProjectsSectionId = .locations
    
    struct Item: Hashable {
        let externalID: String
        let name: String
        let localizedName: String
        let isSelected: Bool
    }
    
    private let locations: [LocationChipViewModel]
    private let actions: NewProjectsActions
    
    init(locations: [LocationChipViewModel], section: HomeSection?, actions: NewProjectsActions) {
        self.locations = locations
        self.actions = actions
    }
    
    func buildItems() -> [Item] {
        locations.map {
            Item(
                externalID: $0.externalID,
                name: $0.name,
                localizedName: $0.localizedName,
                isSelected: $0.isSelected
            )
        }
    }
    
    func layoutSection(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(80),
            heightDimension: .estimated(NewProjectsLayout.chipHeight)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .estimated(120),
            heightDimension: .estimated(NewProjectsLayout.chipHeight)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = NewProjectsLayout.chipSpacing
        section.contentInsets = NSDirectionalEdgeInsets(
            top: NewProjectsLayout.spacing,
            leading: 16,
            bottom: 0,
            trailing: 16
        )
        return section
    }
    
    func configureCell(in collectionView: UICollectionView, at indexPath: IndexPath, with item: Item) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: LocationChipsCollectionViewCell.reuseId, for: indexPath
        ) as? LocationChipsCollectionViewCell else {
            return UICollectionViewCell()
        }
        let viewModel = LocationChipViewModel(
            name: item.name,
            localizedName: item.localizedName,
            externalID: item.externalID,
            isSelected: item.isSelected
        )
        cell.configure(with: viewModel)
        return cell
    }
    
    func didSelectItem(at indexPath: IndexPath, with item: Item) {
        actions.delegate?.newProjectsDidTapLocationChip(externalID: item.externalID)
    }
}


final class NewProjectsCarouselSection: SectionDescriptor {
    typealias Identifier = NewProjectsSectionId
    
    let identifier: NewProjectsSectionId = .projects
    
    struct Item: Hashable {
        let data: NewProject
        
        func hash(into hasher: inout Hasher) { hasher.combine(data.id) }
        static func == (lhs: Item, rhs: Item) -> Bool { lhs.data.id == rhs.data.id }
    }
    
    private let projects: [NewProject]
    private let actions: NewProjectsActions
    
    init(projects: [NewProject], section: HomeSection?, actions: NewProjectsActions) {
        self.projects = projects
        self.actions = actions
    }
    
    func buildItems() -> [Item] {
        projects.map { Item(data: $0) }
    }
    
    func layoutSection(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(NewProjectsLayout.cardHeight)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .estimated(NewProjectsLayout.cardWidth),
            heightDimension: .estimated(NewProjectsLayout.cardHeight)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = NewProjectsLayout.spacing
        section.contentInsets = NSDirectionalEdgeInsets(
            top: NewProjectsLayout.spacing,
            leading: 16,
            bottom: 0,
            trailing: 16
        )
        return section
    }
    
    func configureCell(in collectionView: UICollectionView, at indexPath: IndexPath, with item: Item) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ProjectsCollectionViewCell.reuseId, for: indexPath
        ) as? ProjectsCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: item.data)
        return cell
    }
    
    func didSelectItem(at indexPath: IndexPath, with item: Item) {
        actions.delegate?.newProjectsDidTapCard(at: indexPath.row)
    }
}

final class NewProjectsViewAllSection: SectionDescriptor {
    typealias Identifier = NewProjectsSectionId
    
    let identifier: NewProjectsSectionId = .viewAll
    
    struct Item: Hashable {
        let buttonTitle: String
    }
    
    private let buttonTitle: String
    private let actions: NewProjectsActions
    
    init(buttonTitle: String, section: HomeSection?, actions: NewProjectsActions) {
        self.buttonTitle = buttonTitle
        self.actions = actions
    }
    
    func buildItems() -> [Item] {
        [Item(buttonTitle: buttonTitle)]
    }
    
    func layoutSection(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        .fullWidthList(
            sectionInsets: NSDirectionalEdgeInsets(
                top: NewProjectsLayout.spacing,
                leading: 0,
                bottom: NewProjectsLayout.spacing,
                trailing: 0
            )
        )
    }
    
    func configureCell(in collectionView: UICollectionView, at indexPath: IndexPath, with item: Item) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ViewMoreCell.reuseId, for: indexPath
        ) as? ViewMoreCell else {
            return UICollectionViewCell()
        }
        cell.configure(buttonTitle: item.buttonTitle) { [weak delegate = actions.delegate] in
            delegate?.newProjectsDidTapViewAll()
        }
        return cell
    }
}
