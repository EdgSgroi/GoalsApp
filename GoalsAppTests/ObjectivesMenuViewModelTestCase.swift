//
//  ObjectivesMenuViewModelTestCase.swift
//  GoalsAppTests
//
//  Created by Edgar Sgroi on 18/09/20.
//  Copyright © 2020 Edgar Sgroi. All rights reserved.
//

import XCTest
import CoreData
@testable import GoalsApp

class ObjectivesMenuViewModelTestCase: XCTestCase {
    
    var sut: ObjectivesMenuViewModel!
    var coreDataServiceFake: CoreDataServiceFake!
    var context: NSManagedObjectContext!
    var appDelegate: AppDelegate!
    
    override func setUp() {
        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        sut = ObjectivesMenuViewModel(context: context, appDelegate: appDelegate)
        coreDataServiceFake = CoreDataServiceFake(context: context)
    }

    override func tearDown() {
        context = nil
        appDelegate = nil
        sut = nil
        coreDataServiceFake = nil
    }
    
    func testUpdateObjectives() {
        expectation(forNotification: .updateObjectives, object: nil, handler: nil)
        sut.updateObjectives(service: coreDataServiceFake)
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testGetConcludedGoalsNumber() {
        let objective = NSEntityDescription.insertNewObject(forEntityName: "Objective", into: context) as! Objective
        let firstGoal = NSEntityDescription.insertNewObject(forEntityName: "Goal", into: context) as! Goal
        let secondGoal = NSEntityDescription.insertNewObject(forEntityName: "Goal", into: context) as! Goal
        firstGoal.concluded = true
        secondGoal.concluded = false
        objective.addToRelationshipObjectiveGoal(firstGoal)
        objective.addToRelationshipObjectiveGoal(secondGoal)
        sut.objectives = [objective]
        let result = sut.getConcludedGoalsNumber(fromObjectiveAt: IndexPath(row: 0, section: 0))
        XCTAssertEqual(result, 1)
    }
}
