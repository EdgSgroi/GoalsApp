//
//  Objective+CoreDataProperties.swift
//  GoalsApp
//
//  Created by Edgar Sgroi on 18/07/19.
//  Copyright © 2019 Edgar Sgroi. All rights reserved.
//
//

import Foundation
import CoreData


extension Objective {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Objective> {
        return NSFetchRequest<Objective>(entityName: "Objective")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var previsionDate: NSDate?
    @NSManaged public var rating: Bool
    @NSManaged public var details: String?
    @NSManaged public var relationshipObjectiveGoal: NSSet?

}

// MARK: Generated accessors for relationshipObjectiveGoal
extension Objective {

    @objc(addRelationshipObjectiveGoalObject:)
    @NSManaged public func addToRelationshipObjectiveGoal(_ value: Goal)

    @objc(removeRelationshipObjectiveGoalObject:)
    @NSManaged public func removeFromRelationshipObjectiveGoal(_ value: Goal)

    @objc(addRelationshipObjectiveGoal:)
    @NSManaged public func addToRelationshipObjectiveGoal(_ values: NSSet)

    @objc(removeRelationshipObjectiveGoal:)
    @NSManaged public func removeFromRelationshipObjectiveGoal(_ values: NSSet)

}
