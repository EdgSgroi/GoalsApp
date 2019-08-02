//
//  ObjectiveCardCell.swift
//  GoalsApp
//
//  Created by Edgar Sgroi on 18/07/19.
//  Copyright © 2019 Edgar Sgroi. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class ObjectiveCardCell: UICollectionViewCell {
    
    var objective: Objective?
    var objectiveIndexPath: IndexPath!
    var id: UUID?
    var rating: Bool = false
    @IBOutlet weak var imgRatingMark: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblConclusionPercentage: UILabel!
    @IBOutlet weak var lblGoalsInfo: UILabel!
    @IBOutlet weak var progressCircle: ProgressCircleView!
 
    
}
