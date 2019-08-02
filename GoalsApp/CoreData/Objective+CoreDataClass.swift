//
//  Objective+CoreDataClass.swift
//  GoalsApp
//
//  Created by Edgar Sgroi on 18/07/19.
//  Copyright © 2019 Edgar Sgroi. All rights reserved.
//
//

import Foundation
import CoreData


public class Objective: NSManagedObject {
    
    var goals:[Goal] = [Goal]()
    var qntdGoalsConcluded = 0
    
    func calculatePercentage() -> Float{
        qntdGoalsConcluded = 0
        for goal in goals{
            if goal.concluded{
                qntdGoalsConcluded += 1
            }
        }
        var percent = (Float(qntdGoalsConcluded) * 100) / Float(goals.count <= 0 ? 1 : goals.count)
        
        return percent
    }
}
