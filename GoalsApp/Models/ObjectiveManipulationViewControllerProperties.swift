//
//  GoalTableViewModel.swift
//  GoalsApp
//
//  Created by Edgar Sgroi on 25/07/19.
//  Copyright © 2019 Edgar Sgroi. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import UserNotifications

extension ObjectiveManipulationViewController{
    
    func createNotification(title: String, body: String, time: Date, identifier: String){
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                let content = UNMutableNotificationContent()
                
                content.title = title
                content.body = body
                content.sound = UNNotificationSound.default
                content.badge = 1
                print(time.timeIntervalSinceNow)
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: time.timeIntervalSinceNow + 5000, repeats: false)
//                let trigger = UNCalendarNotificationTrigger(dateMatching: makeDate(year: time.da, month: <#T##Int#>, day: <#T##Int#>, hr: <#T##Int#>), repeats: false)
                let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                
                let center = UNUserNotificationCenter.current()
                center.add(request){ (error:Error?) in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                }
            } else {
                fatalError("Impossível mandar notificação - permissão negada")
            }
        }
    }
    
    
}
