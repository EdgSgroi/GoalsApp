//
//  ObjectiveManipulationViewModel.swift
//  GoalsApp
//
//  Created by Edgar Sgroi on 03/04/20.
//  Copyright © 2020 Edgar Sgroi. All rights reserved.
//

import Foundation
import CoreData
import UserNotifications

protocol ObjectiveManipulationViewDelegate {
    func saveNewObjective(_ completion: @escaping () -> Void)
}

class ObjectiveManipulationViewModel {
    
    private var context: NSManagedObjectContext
    private var appDelegate: AppDelegate
    
    public var id: UUID = UUID()
    public var title: String = ""
    public var rating: Bool = true
    public var previsionDate: Date = Date()
    public var details: String = ""

    
    init(context: NSManagedObjectContext, appDelegate: AppDelegate) {
        self.context = context
        self.appDelegate = appDelegate
    }
    
    func createNewObjective() {
        let objective = NSEntityDescription.insertNewObject(forEntityName: "Objective", into: context) as! Objective
        objective.id = id
        objective.title = title
        objective.rating = rating
        objective.previsionDate = previsionDate as NSDate
        objective.details = details

        appDelegate.saveContext()
        createNewNotification(title: title, body: "Hoje termina o prazo de conclusão do seu objetivo. Veja sua evolução!", time: previsionDate as Date, identifier: id.uuidString)
    }
    
    func createNewNotification(title: String, body: String, time: Date, identifier: String) {
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
