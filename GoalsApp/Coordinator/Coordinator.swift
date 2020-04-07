//
//  Coordinator.swift
//  GoalsApp
//
//  Created by Edgar Sgroi on 07/04/20.
//  Copyright © 2020 Edgar Sgroi. All rights reserved.
//

import Foundation
import UIKit

protocol Coordinator {
    var navController: UINavigationController { get set }

    func start()
}
