//
//  CoreDataService.swift
//  GoalsApp
//
//  Created by Edgar Sgroi on 03/04/20.
//  Copyright © 2020 Edgar Sgroi. All rights reserved.
//

import Foundation
import CoreData

struct CoreDataResponse {
    var error: Error?
    var result: [NSManagedObject]?
}

class CoreDataService {
    
    var context: NSManagedObjectContext?
    
    init(context: NSManagedObjectContext?) {
        self.context = context
    }
    
    func fetch(_ completion: @escaping (CoreDataResponse) -> Void) {
        var result: [NSManagedObject] = []
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Objective")
        request.returnsObjectsAsFaults = false
        if let context = context {
            do{
                let reponse = try context.fetch(request)
                for data in reponse as! [NSManagedObject] {
                    result.append(data)
                }
            } catch {
                fatalError("404 - Non Entity")
            }
        }
        DispatchQueue.main.async {
            completion(CoreDataResponse(error: nil, result: result))
        }
    }
}

extension CoreDataService: ObjectivesMenuViewDelegate {
    func fetchData(_ completion: @escaping ([NSManagedObject]?, Error?) -> Void) {
        fetch({ response in
            DispatchQueue.main.async {
                completion(response.result, response.error)
            }
        })
    }
}
