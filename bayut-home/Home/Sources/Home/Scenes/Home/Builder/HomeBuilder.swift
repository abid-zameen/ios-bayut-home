//
//  HomeBuilder.swift
//  Home
//
//  Created by Hammad Shahid on 07/04/2026.
//

import UIKit

public final class HomeBuilder {
    public static func build() -> UIViewController {
        let adapter = HomeModule.shared
        let viewController = HomeViewController()
        let worker = HomeWorker(networking: adapter.networking)
        let interactor = HomeInteractor(adapter: adapter, worker: worker)
        let presenter = HomePresenter(adapter: adapter)
        let router = HomeRouter(navigation: adapter.navigation)
        
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        
        return viewController
    }
}
