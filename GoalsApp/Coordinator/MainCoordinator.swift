//
//  MainCoordinator.swift
//  GoalsApp
//
//  Created by Edgar Sgroi on 07/04/20.
//  Copyright © 2020 Edgar Sgroi. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class MainCoordinator: Coordinator {
    var navController: UINavigationController
    let context: NSManagedObjectContext
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    init(navController: UINavigationController) {
        self.navController = navController
        self.context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
//        self.appDelegate = appDelegate
    }
    
    func start() {
        let vc = ObjectivesMenuViewController(viewModel: ObjectivesMenuViewModel(context: context, appDelegate: appDelegate))
        navController.pushViewController(vc, animated: false)
    }
    
    
}
