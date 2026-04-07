//
//  MapCellViewModel.swift
//  Home
//
//  Created by Hammad Shahid on 02/04/2026.
//

import Foundation

protocol MapCellViewModelType {
    var onAllowLocationAccessTapped: (() -> Void)? { get }
}

final class MapCellViewModel: MapCellViewModelType {
    let onAllowLocationAccessTapped: (() -> Void)?
    
    init(onAllowLocationAccessTapped: (() -> Void)?) {
        self.onAllowLocationAccessTapped = onAllowLocationAccessTapped
    }
}
