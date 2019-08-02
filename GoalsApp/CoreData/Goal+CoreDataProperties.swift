//
//  Goal+CoreDataProperties.swift
//  GoalsApp
//
//  Created by Edgar Sgroi on 18/07/19.
//  Copyright © 2019 Edgar Sgroi. All rights reserved.
//
//

import Foundation
import CoreData


extension Goal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Goal> {
        return NSFetchRequest<Goal>(entityName: "Goal")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var previsionDate: NSDate?
    @NSManaged public var conclusionDate: NSDate?
    @NSManaged public var concluded: Bool
    @NSManaged public var relationshipGoalObjective: Objective?

}
