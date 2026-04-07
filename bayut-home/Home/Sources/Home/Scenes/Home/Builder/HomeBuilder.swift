//
//  HomeBuilder.swift
//  Home
//
//  Created by Hammad Shahid on 07/04/2026.
//

import UIKit

public final class HomeBuilder {
    public static func build() -> UIViewController {
        let viewController = HomeViewController()
        let interactor = HomeInteractor()
        let presenter = HomePresenter()
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
        
        return viewController
    }
}
