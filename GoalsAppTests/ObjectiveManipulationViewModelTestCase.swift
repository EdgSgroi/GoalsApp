//
//  ObjectiveManipulationViewModelTestCase.swift
//  GoalsAppTests
//
//  Created by Edgar Sgroi on 18/09/20.
//  Copyright © 2020 Edgar Sgroi. All rights reserved.
//

import XCTest
import CoreData
@testable import GoalsApp

class ObjectiveManipulationViewModelTestCase: XCTestCase {
    
    var sut: ObjectiveManipulationViewModel!
    var coreDataService: CoreDataService!
    var context: NSManagedObjectContext!
    var appDelegate: AppDelegate!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        sut = ObjectiveManipulationViewModel(context: context, appDelegate: appDelegate)
        
        sut.id = UUID()
        sut.title = "Titulo teste"
        sut.rating = true
        sut.previsionDate = Date()
        sut.details = "Detalhes teste"
        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        context = nil
        appDelegate = nil
        sut = nil
    }
    
    func testCreateNewObjective() {
        sut.createNewObjective()
    }

}
