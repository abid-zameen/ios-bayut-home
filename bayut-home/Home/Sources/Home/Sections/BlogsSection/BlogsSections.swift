//
//  BlogsSections.swift
//  Home
//
//  Created by Hammad Shahid on 02/04/2026.
//

import UIKit

// MARK: - Shared Identifier
enum BlogsSectionId: String, SectionIdentifier {
    case title      = "blogs.title"
    case carousel   = "blogs.carousel"
    case viewAll    = "blogs.viewAll"
    
    var displayName: String? { nil }
    var section: HomeSection? { .main }
}

// MARK: - Constants
private enum BlogsLayout {
    static let sectionInsets = NSDirectionalEdgeInsets(top: 20, leading: 16, bottom: 0, trailing: 16)
    static let spacing: CGFloat = 16
    
    static let cardWidth: CGFloat = 10
    static let estimatedCardHeight: CGFloat = 260
}

final class BlogsTitleSection: SectionDescriptor {
    typealias Identifier = BlogsSectionId
    let identifier: BlogsSectionId = .title
    
    struct Item: Hashable { let title: String }
    private let title: String
    
    init(title: String, section: HomeSection?) {
        self.title = title
    }
    
    func buildItems() -> [Item] { [Item(title: title)] }
    
    func layoutSection(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        .fullWidthList(sectionInsets: BlogsLayout.sectionInsets)
    }
    
    func configureCell(in collectionView: UICollectionView, at indexPath: IndexPath, with item: Item) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCell.reuseId, for: indexPath) as? TitleCell else { return UICollectionViewCell() }
        cell.configure(title: item.title)
        return cell
    }
}

final class BlogsCarouselSection: SectionDescriptor {
    typealias Identifier = BlogsSectionId
    let identifier: BlogsSectionId = .carousel
    
    struct Item: Hashable {
        let id: String
        let blog: Blog?
        func hash(into hasher: inout Hasher) { hasher.combine(id) }
        static func == (lhs: Item, rhs: Item) -> Bool { lhs.id == rhs.id }
    }
    
    private let state: Home.DataState<[Blog]>
    private let actions: BlogsActions
    
    init(state: Home.DataState<[Blog]>, section: HomeSection?, actions: BlogsActions) {
        self.state = state
        self.actions = actions
    }
    
    func buildItems() -> [Item] {
        switch state {
        case .loading:
            return (0..<3).map { Item(id: "shimmer.\($0)", blog: nil) }
        case .data(let blogs):
            return blogs.map { Item(id: String($0.blogPostId), blog: $0) }
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
            heightDimension: .absolute(BlogsLayout.estimatedCardHeight)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.85),
            heightDimension: .absolute(BlogsLayout.estimatedCardHeight)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.interGroupSpacing = 0
        section.contentInsets = NSDirectionalEdgeInsets(
            top: BlogsLayout.spacing,
            leading: 0,
            bottom: 0,
            trailing: 0
        )
        return section
    }
    
    func configureCell(in collectionView: UICollectionView, at indexPath: IndexPath, with item: Item) -> UICollectionViewCell {
        if case .loading = state {
            return collectionView.dequeueReusableCell(withReuseIdentifier: BlogsShimmerCell.reuseId, for: indexPath)
        }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BlogCell.reuseId, for: indexPath) as? BlogCell else { return UICollectionViewCell() }
        if let blog = item.blog {
            let vm = BlogsCellViewModel(blog: blog)
            cell.configure(with: vm)
        }
        return cell
    }
    
    func didSelectItem(at indexPath: IndexPath, with item: Item) {
        if case .data = state, let blog = item.blog {
            actions.delegate?.blogsDidTapCard(at: indexPath.item, with: blog.blogUrl, title: blog.title)
        }
    }
}

final class BlogsViewAllSection: SectionDescriptor {
    typealias Identifier = BlogsSectionId
    let identifier: BlogsSectionId = .viewAll
    
    struct Item: Hashable { let buttonTitle: String }
    private let buttonTitle: String
    private let actions: BlogsActions
    
    init(buttonTitle: String, section: HomeSection?, actions: BlogsActions) {
        self.buttonTitle = buttonTitle
        self.actions = actions
    }
    
    func buildItems() -> [Item] { [Item(buttonTitle: buttonTitle)] }
    
    func layoutSection(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        .fullWidthList(
            sectionInsets: NSDirectionalEdgeInsets(
                top: 0,
                leading: 0,
                bottom: BlogsLayout.spacing,
                trailing: 0
            )
        )
    }
    
    func configureCell(in collectionView: UICollectionView, at indexPath: IndexPath, with item: Item) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ViewMoreCell.reuseId, for: indexPath) as? ViewMoreCell else { return UICollectionViewCell() }
        cell.configure(buttonTitle: item.buttonTitle) { [weak self] in
            self?.actions.delegate?.blogsDidTapViewAll()
        }
        return cell
    }
}
