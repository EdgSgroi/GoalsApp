//
//  ViewController.swift
//  GoalsApp
//
//  Created by Edgar Sgroi on 16/07/19.
//  Copyright © 2019 Edgar Sgroi. All rights reserved.
//

import UIKit
import UserNotifications

class ObjectivesMenuViewController: UICollectionViewController {
    
    let messageContainer = UIView()
    
    var viewModel: ObjectivesMenuViewModel!
    
    init(viewModel: ObjectivesMenuViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "ObjectivesMenuViewController", bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        viewModel = ObjectivesMenuViewModel(context: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext, appDelegate: appDelegate)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        NotificationCenter.default.addObserver(self,
        selector: #selector(reloadUI),
        name: .updateObjectives,
        object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.createCells()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ShowObjective", sender: viewModel.getObjective(at: indexPath))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "ShowObjective") {
            let objective = sender as! Objective
            let displayViewController = segue.destination as! ObjectiveViewController
            displayViewController.objectiveID = objective.id
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //MUDAR
//        print(viewModel.rowsNumber())
        if(viewModel.rowsNumber() <= 0){
            self.setEmptyMessage()
        } else {
            messageContainer.removeFromSuperview()
        }
        return viewModel.rowsNumber()
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ObjectiveCell", for: indexPath) as? ObjectiveCardCell {
            return makeCell(cell: cell, indexPath: indexPath)
        }
        return UICollectionViewCell()
    }
    
    func makeCell(cell:ObjectiveCardCell, indexPath:IndexPath) -> UICollectionViewCell {
        cell.layer.cornerRadius = 22
        cell.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2493846318)
        cell.layer.shadowOffset = CGSize(width: 2.5, height: 5.0)
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOpacity = 0.5
        cell.layer.masksToBounds = false
        // APENAS PARA TESTE - REMOVER TODOS OS OBJ
        let obj = viewModel.getObjective(at: indexPath)
        //----------------------------------------------
        let totalGoals: Int = viewModel.getTotalGoals(fromObjective: indexPath)
        let concludedGoals: Int = viewModel.getConcludedGoalsNumber(fromObjectiveAt: indexPath)
        cell.objectiveIndexPath = indexPath
        cell.id = viewModel.getObjective(at: indexPath).id
        cell.rating = obj.rating
        cell.imgRatingMark.image = obj.rating == false ? #imageLiteral(resourceName: "UnmarkedRelevancyPoint") : #imageLiteral(resourceName: "MarkedRatePoint")
        cell.lblTitle.text = obj.title
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
    
    //Refatorar Alert
    func showSimpleAlert(cell:ObjectiveCardCell) {
        let alert = UIAlertController(title: "Apagar objetivo", message: "Você deseja mesmo apagar esse objetivo e todos os seus dados?", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Apagar", style: .destructive, handler: { (action) in
            self.deleteNotification(identifier: self.viewModel.getObjective(at: cell.objectiveIndexPath).id!.uuidString)
            self.viewModel.deleteObject(at: cell.objectiveIndexPath)
            self.collectionView.reloadData()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: UIAlertAction.Style.default, handler: { _ in }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func createCells() {
        viewModel.updateObjectives(service: CoreDataService(context: viewModel.context))
//        collectionView.reloadData()
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
    
    @objc func reloadUI() {
        collectionView.reloadData()
    }
}

