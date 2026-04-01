//
//  CellRegistry.swift
//  Home
//
//  Created by Hammad Shahid on 01/04/2026.
//

import UIKit

final class CellRegistry {
    static func registerCells(in collectionView: UICollectionView) {
        
        // Programmatic Cells
        collectionView.register(TitleCell.self, forCellWithReuseIdentifier: TitleCell.reuseId)
        collectionView.register(ViewMoreCell.self, forCellWithReuseIdentifier: ViewMoreCell.reuseId)
        
        // NIB-based Cells
        let locationNib = UINib(nibName: LocationChipsCollectionViewCell.reuseId, bundle: nil)
        collectionView.register(locationNib, forCellWithReuseIdentifier: LocationChipsCollectionViewCell.reuseId)
        
        let projectNib = UINib(nibName: ProjectsCollectionViewCell.reuseId, bundle: nil)
        collectionView.register(projectNib, forCellWithReuseIdentifier: ProjectsCollectionViewCell.reuseId)
        
        // Add more cells to register here
    }
}
