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
    static let sectionInsets = NSDirectionalEdgeInsets(top: .sectionTopSpace, leading: .standard, bottom: .zero, trailing: .standard)
    static let chipHeight: CGFloat = 36
    static let cardWidth: CGFloat = 280
    static let cardHeight: CGFloat = 340
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
        section.interGroupSpacing = .extraSmall
        section.contentInsets = NSDirectionalEdgeInsets(
            top: .standard,
            leading: .standard,
            bottom: .zero,
            trailing: .standard
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
        let id: String
        let data: ProjectHit?
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
        
        static func == (lhs: Item, rhs: Item) -> Bool {
            lhs.id == rhs.id
        }
    }
    
    private let state: Home.DataState<[ProjectHit]>
    private let showWhatsappButton: Bool
    private let actions: NewProjectsActions
    
    init(state: Home.DataState<[ProjectHit]>, showWhatsappButton: Bool, section: HomeSection?, actions: NewProjectsActions) {
        self.state = state
        self.showWhatsappButton = showWhatsappButton
        self.actions = actions
    }
    
    func buildItems() -> [Item] {
        switch state {
        case .loading:
            return (0..<2).map { Item(id: "shimmer.\($0)", data: nil) }
        case .data(let projects):
            return projects.map { Item(id: $0.externalID ?? $0.objectID, data: $0) }
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
        section.interGroupSpacing = .standard
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
            return collectionView.dequeueReusableCell(withReuseIdentifier: ProjectsShimmerCell.reuseId, for: indexPath)
        }
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ProjectsCollectionViewCell.reuseId, for: indexPath
        ) as? ProjectsCollectionViewCell else {
            return UICollectionViewCell()
        }
        if let data = item.data {
            let viewModel = NewProjectCellViewModel(hit: data, showWhatsappButton: showWhatsappButton)
            cell.configure(with: viewModel)
            cell.whatsappCallback = { [weak self] in
                self?.actions.delegate?.newProjectsDidTapWhatsapp(hit: data, index: indexPath.item)
            }
        }
        return cell
    }
    
    func didSelectItem(at indexPath: IndexPath, with item: Item) {
        if case .data = state, let data = item.data {
            actions.delegate?.newProjectsDidTapCard(hit: data)
        }
    }
}

final class NewProjectsViewAllSection: SectionDescriptor {
    typealias Identifier = NewProjectsSectionId
    
    let identifier: NewProjectsSectionId = .viewAll
    
    struct Item: Hashable {
        let buttonTitle: String
    }
    
    private let buttonTitle: String
    private let externalID: String
    private let displayName: String
    private let actions: NewProjectsActions
    
    init(buttonTitle: String, externalID: String, displayName: String, section: HomeSection?, actions: NewProjectsActions) {
        self.buttonTitle = buttonTitle
        self.externalID = externalID
        self.displayName = displayName
        self.actions = actions
    }
    
    func buildItems() -> [Item] {
        [Item(buttonTitle: buttonTitle)]
    }
    
    func layoutSection(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        .fullWidthList(
            sectionInsets: NSDirectionalEdgeInsets(
                top: .zero,
                leading: .zero,
                bottom: .zero,
                trailing: .zero
            )
        )
    }
    
    func configureCell(in collectionView: UICollectionView, at indexPath: IndexPath, with item: Item) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ViewMoreCell.reuseId, for: indexPath
        ) as? ViewMoreCell else {
            return UICollectionViewCell()
        }
        cell.configure(buttonTitle: item.buttonTitle) { [weak self] in
            guard let self = self else { return }
            self.actions.delegate?.newProjectsDidTapViewAll(externalID: self.externalID, displayName: self.displayName)
        }
        return cell
    }
}
