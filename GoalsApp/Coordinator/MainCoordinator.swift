//
//  MainCoordinator.swift
//  GoalsApp
//
//  Created by Edgar Sgroi on 07/04/20.
//  Copyright © 2020 Edgar Sgroi. All rights reserved.
//

import Foundation
import UIKit

class MainCoordinator: Coordinator {
    var navController: UINavigationController
    
    init(navController: UINavigationController) {
        self.navController = navController
    }
    
    func start() {
        let vc = ObjectivesMenuViewController()
        navController.pushViewController(vc, animated: false)
    }
    
    
}
