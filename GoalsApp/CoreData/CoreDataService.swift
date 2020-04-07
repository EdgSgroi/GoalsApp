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
    
    private let context: NSManagedObjectContext?
    
    init(context: NSManagedObjectContext?) {
        self.context = context
    }
    
    private func fetch(_ completion: @escaping (CoreDataResponse) -> Void) {
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
    
//    func save(_ completion: @escaping (Result<Any, Error?>) -> Void) {
//        context.
//    }
    
    private func update(request:NSFetchRequest<NSFetchRequestResult>,objective: Objective, _ completion: @escaping (Result<Any, Error>) -> Void) {
        request.returnsObjectsAsFaults = false
        if let context = context{
            do{
                let result = try context.fetch(request)
                for data in result as! [NSManagedObject] {
                    if data.value(forKey: "id") as? UUID == objective.id{
                        data.setValue(objective.title, forKey: "title")
                        data.setValue(objective.rating, forKey: "rating")
                        data.setValue(objective.previsionDate, forKey: "previsionDate")
                        data.setValue(objective.details, forKey: "details")
                    }
                }
                DispatchQueue.main.async {
                    completion(.success("Objective \(String(describing: objective.title)) updated"))
                }
            }catch{
                completion(.failure(error))
            }
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

extension CoreDataService: ObjectiveManipulationViewDelegate {
    
//    func saveNewObjective(objective: Objective, completion: @escaping (Result<Any, Error>) -> Void) {
//        save({ response in
//            DispatchQueue.main.async {
//                completion(response)
//            }
//        })
//    }
    
//    func saveNewObjective(id: UUID, title: String, rating: Bool, previsionDate: Date, details: String, _ completion: @escaping (CoreDataResponse) -> Void) {
//        save({ response in
//            let objective = NSEntityDescription.insertNewObject(forEntityName: "Objective", into: self.context!) as! Objective
//            objective.id = id
//            objective.title = title
//            objective.rating = rating
//            objective.previsionDate = previsionDate as NSDate
//            objective.details = details
//            DispatchQueue.main.async {
//                completion(response.result)
//            }
//        })
//    }
    
    func updateObjective(objective: Objective, _ completion: @escaping (Result<Any, Error>) -> Void) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Objective")
        request.returnsObjectsAsFaults = false
        update(request: request, objective: objective) { (result) in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    
}
