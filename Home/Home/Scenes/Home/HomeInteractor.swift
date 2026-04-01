//
//  HomeInteractor.swift
//  Home
//
//  Created by Hammad Shahid on 01/04/2026.
//

import Foundation

protocol HomeBusinessLogic: AnyObject {
    func loadData()
}

final class HomeInteractor: HomeBusinessLogic {
    var presenter: HomePresentationLogic?
    
    // MARK: - HomeBusinessLogic
    func loadData() {
        presenter?.presentData()
    }
}
