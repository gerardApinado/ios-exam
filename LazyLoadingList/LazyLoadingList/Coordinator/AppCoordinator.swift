//
//  AppCoordinator.swift
//  LazyLoadingList
//
//  Created by Gerard on 8/23/24.
//

import Foundation
import UIKit

class AppCoordinator {
    private let window : UIWindow
    private let navigationController : UINavigationController
    
    init(window: UIWindow) {
        self.window = window
        navigationController = UINavigationController()
        navigationController.navigationBar.tintColor = .black
    }
    
    func start() {
        let rootVC = PersonListVC()
        rootVC.coordinator = self
        navigationController.viewControllers = [rootVC]
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func routeToPersonDetails(data: Person) {
        let personDetailsVC = PersonDetailsVC(data: data)
        navigationController.pushViewController(personDetailsVC, animated: true)
    }
    
    
}
