//
//  GoalsTableViewCell.swift
//  GoalsApp
//
//  Created by Edgar Sgroi on 24/07/19.
//  Copyright © 2019 Edgar Sgroi. All rights reserved.
//

import Foundation
import UIKit

class GoalTableViewCell: UITableViewCell{
    
    var id: UUID!
    var conclueded: Bool!
    
    @IBOutlet weak var lblTitulo: UILabel!
    @IBOutlet weak var lblPrevisionDate: UILabel!
    @IBOutlet weak var lblInfo: UILabel!
    
}
