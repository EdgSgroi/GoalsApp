//
//  ViewController.swift
//  GoalsApp
//
//  Created by Edgar Sgroi on 16/07/19.
//  Copyright © 2019 Edgar Sgroi. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class ObjectivesMenuViewController: UICollectionViewController {
    
    var context: NSManagedObjectContext?
    
    var objectives = [Objective]()
    
    let messageContainer = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.createCells()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ShowObjective", sender: objectives[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "ShowObjective"){
            let objective = sender as! Objective
            let displayViewController = segue.destination as! ObjectiveViewController
            displayViewController.objectiveID = objective.id
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(objectives.count)
        if(objectives.count <= 0){
            self.setEmptyMessage()
        } else {
            messageContainer.removeFromSuperview()
        }
        return objectives.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ObjectiveCell", for: indexPath) as? ObjectiveCardCell {
            return makeCell(cell: cell, indexPath: indexPath)
        }
        
        return UICollectionViewCell()
    }
    
    func makeCell(cell:ObjectiveCardCell, indexPath:IndexPath) -> UICollectionViewCell{
        cell.layer.cornerRadius = 22
        cell.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2493846318)
        cell.layer.shadowOffset = CGSize(width: 2.5, height: 5.0)
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOpacity = 0.5
        cell.layer.masksToBounds = false
        let totalGoals = objectives[indexPath.row].relationshipObjectiveGoal?.allObjects.count ?? 0
        var concludedGoals: Int! = 0
        var notConcludedGoals: Int! = 0
        if let goals = objectives[indexPath.row].relationshipObjectiveGoal?.allObjects as? [Goal]{
            for g in goals{
                concludedGoals += g.concluded ? 1 : 0
                notConcludedGoals += g.concluded ? 0 : 1
            }
        }
        cell.objectiveIndexPath = indexPath
        cell.id = objectives[indexPath.row].id
        cell.rating = objectives[indexPath.row].rating
        cell.imgRatingMark.image = objectives[indexPath.row].rating == false ? #imageLiteral(resourceName: "UnmarkedRelevancyPoint") : #imageLiteral(resourceName: "MarkedRatePoint")
        cell.lblTitle.text = objectives[indexPath.row].title
        cell.lblConclusionPercentage.text = String(Int(((concludedGoals * 100) / (totalGoals <= 0 ? 1 : totalGoals)))) + "%"
        cell.progressCircle.progressValue = CGFloat(((Float(concludedGoals) * 100) / Float(totalGoals <= 0 ? 1 : totalGoals)) / 100)
        cell.lblGoalsInfo.text = String(concludedGoals) + "/" + String(totalGoals) + " metas"
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.longTap(_:)))
        cell.addGestureRecognizer(longPressGesture)
        return cell
    }
    
    @objc func longTap (_ sender: UILongPressGestureRecognizer) {
        if let celula = sender.view as? ObjectiveCardCell{
            if sender.state == .began{
                showSimpleAlert(cell: celula)
            }
        }
    }
    
    func showSimpleAlert(cell:ObjectiveCardCell) {
        let alert = UIAlertController(title: "Apagar objetivo", message: "Você deseja mesmo apagar esse objetivo e todos os seus dados?", preferredStyle: .actionSheet)
        
        
        alert.addAction(UIAlertAction(title: "Apagar", style: .destructive, handler: { (action) in
//            let centerNotification = UNUserNotificationCenter.current()
            self.deleteNotification(identifier: self.objectives[cell.objectiveIndexPath.row].id!.uuidString)
//            centerNotification.removeDeliveredNotifications(withIdentifiers: [self.objectives[cell.objectiveIndexPath.row].id!.uuidString])
            self.context?.delete(self.objectives[cell.objectiveIndexPath.row])
            self.objectives.remove(at: cell.objectiveIndexPath.row)
            self.collectionView.reloadData()
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            appDelegate.saveContext()
            
        }))
        
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: UIAlertAction.Style.default, handler: { _ in }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func createCells(){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Objective")
        request.returnsObjectsAsFaults = false
        if let context = context{
            do{
                let result = try context.fetch(request)
                objectives = []
                for data in result as! [NSManagedObject]{
                    objectives.append(data as! Objective)
                }
            }catch{
                fatalError("404 - Non Entity")
            }
        }
        collectionView.reloadData()
    }
    
    func deleteNotification(identifier: String){
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
    func setEmptyMessage() {
        let messageImage = UIImageView(image: #imageLiteral(resourceName: "EmptyMessage"))
        messageContainer.addSubview(messageImage)
        self.view.addSubview(messageContainer)
        messageContainer.translatesAutoresizingMaskIntoConstraints = false
        messageContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        messageContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        messageContainer.widthAnchor.constraint(equalToConstant: messageImage.frame.width).isActive = true
        messageContainer.heightAnchor.constraint(equalToConstant: messageImage.frame.height).isActive = true
        
        let buttonAdd = UIButton(frame: .zero)
        buttonAdd.imageView?.image = #imageLiteral(resourceName: "EmptyAddButton")
        self.messageContainer.addSubview(buttonAdd)
    }
}

