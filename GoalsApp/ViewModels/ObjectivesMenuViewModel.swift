//
//  ObjectivesMenuViewModel.swift
//  GoalsApp
//
//  Created by Edgar Sgroi on 03/04/20.
//  Copyright © 2020 Edgar Sgroi. All rights reserved.
//

import Foundation
import CoreData

protocol ObjectivesMenuViewDelegate: class {
    func fetchData(_ completion: @escaping ([NSManagedObject]?, Error?) -> Void)
}

class ObjectivesMenuViewModel {
    
    var objectives: [Objective]
    var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
        objectives = []
    }
    
    func updateObjectives() {
        let service = CoreDataService(context: context)
        service.fetchData({ (result, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            if let result = result {
                self.objectives = result.compactMap({
                    $0 as? Objective
                })
                NotificationCenter.default.post(name: .updateObjectives, object: nil)
            }
        })
    }
    
    func rowsNumber() -> Int {
        return objectives.count
    }
    
    func getObjective(at indexPath: IndexPath) -> Objective {
        return objectives[indexPath.row]
    }
    
    func getTotalGoals(fromObjective indexPath: IndexPath) -> Int {
        return objectives[indexPath.row].relationshipObjectiveGoal?.allObjects.count ?? 0
    }
    
    func getConcludedGoalsNumber(fromObjectiveAt indexPath: IndexPath) -> Int {
        if let goals = objectives[indexPath.row].relationshipObjectiveGoal?.allObjects as? [Goal] {
            var concludedGoals = 0
            for g in goals {
                concludedGoals += g.concluded ? 1 : 0
            }
            return concludedGoals
        }
        return 0
    }
    
    func deleteObject(at indexPath: IndexPath) {
        self.context.delete(getObjective(at: indexPath))
        objectives.remove(at: indexPath.row)
    }
}
