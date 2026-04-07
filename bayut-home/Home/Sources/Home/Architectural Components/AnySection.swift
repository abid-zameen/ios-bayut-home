//
//  AnySection.swift
//  TruEstimate
//
//  Created by Muhammad Hammad on 24/12/2025.
//

import UIKit

// MARK: - Any Section
struct AnySection: SectionIdentifier, Hashable {
    let identifierString: String
    var rawValue: String { identifierString }
    let displayName: String?
    let section: HomeSection?
    let isCustomizable: Bool
    
    private let identifier: AnyHashable
    private let _layoutSection: (NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection
    private let _buildItems: () -> [AnyHashable]
    private let _configureCell: (UICollectionView, IndexPath, AnyHashable) -> UICollectionViewCell
    private let _configureSupplementaryView: (UICollectionView, String, IndexPath) -> UICollectionReusableView?
    private let _didSelectItem: (IndexPath, AnyHashable) -> Void
    
    init<S: SectionDescriptor>(_ descriptor: S, isCustomizable: Bool = true) {
        self.identifier = AnyHashable(descriptor.identifier)
        self.identifierString = descriptor.identifier.rawValue
        self.displayName = descriptor.identifier.displayName
        self.section = descriptor.identifier.section
        self.isCustomizable = isCustomizable
        
        self._layoutSection = descriptor.layoutSection
        self._buildItems = { descriptor.buildItems().map { AnyHashable($0) } }
        self._configureCell = { collectionView, indexPath, anyItem in
            guard let item = anyItem.base as? S.Item else { return UICollectionViewCell() }
            return descriptor.configureCell(in: collectionView, at: indexPath, with: item)
        }
        self._configureSupplementaryView = descriptor.configureSupplementaryView
        self._didSelectItem = { indexPath, anyItem in
            guard let item = anyItem.base as? S.Item else { return }
            descriptor.didSelectItem(at: indexPath, with: item)
        }
    }
    
    func layoutSection(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        _layoutSection(environment)
    }
    
    func buildItems() -> [AnyHashable] {
        _buildItems()
    }
    
    func configureCell(in collectionView: UICollectionView, at indexPath: IndexPath, with item: AnyHashable) -> UICollectionViewCell {
        _configureCell(collectionView, indexPath, item)
    }
    
    func configureSupplementaryView(in collectionView: UICollectionView, kind: String, at indexPath: IndexPath) -> UICollectionReusableView? {
        _configureSupplementaryView(collectionView, kind, indexPath) ?? UICollectionReusableView()
    }
    
    func didSelectItem(at indexPath: IndexPath, with item: AnyHashable) {
        _didSelectItem(indexPath, item)
    }
    
    func hash(into hasher: inout Hasher) { hasher.combine(identifier) }
    static func == (lhs: AnySection, rhs: AnySection) -> Bool { lhs.identifier == rhs.identifier }
}
