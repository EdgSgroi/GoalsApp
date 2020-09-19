//
//  CoreDataServiceFake.swift
//  GoalsAppTests
//
//  Created by Edgar Sgroi on 19/09/20.
//  Copyright © 2020 Edgar Sgroi. All rights reserved.
//

import Foundation
import CoreData
@testable import GoalsApp

class CoreDataServiceFake: CoreDataService {
    override func fetchData(_ completion: @escaping ([NSManagedObject]?, Error?) -> Void) {
        DispatchQueue.main.async {
            completion(nil, nil)
        }
    }
}
