
//  ObjectiveViewController.swift
//  GoalsApp
//
//  Created by Edgar Sgroi on 19/07/19.
//  Copyright © 2019 Edgar Sgroi. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import UserNotifications

class ObjectiveViewController : UIViewController, UITableViewDataSource, UITableViewDelegate{

    var context : NSManagedObjectContext?
    let formatter = DateFormatter()
    
    @IBOutlet weak var lblPrevisionDate: UILabel!
    @IBOutlet weak var lblRemainingDays: UILabel!
    @IBOutlet weak var lblCompletedGoals: UILabel!
    @IBOutlet weak var swtchRating: UISwitch!
    @IBOutlet weak var progressCircle: ProgressCircleView!
    @IBOutlet weak var lblConclusionPercentage: UILabel!
    @IBOutlet weak var txtDetails: UITextView!
    
    var AlertViewConclusionDateTextField: UITextField!
    
    @IBOutlet weak var sgmtdCtrlGoals: UISegmentedControl!
    @IBAction func changeGoalsShown(_ sender: Any) {
        switch(sgmtdCtrlGoals.selectedSegmentIndex){
        case 0:
            goalsShown = "Not Concluded Goals"
            goals = notConcludedGoals
            goalTableView.reloadData()
        case 1:
            goalsShown = "Concluded Goals"
            goals = concludedGoals
            goalTableView.reloadData()
        default:
            goalsShown = "Not Concluded Goals"
            goals = notConcludedGoals
            goalTableView.reloadData()
        }
    }
    
    var objectiveID:UUID!
    var currentObjective:Objective!
    
    var concludedGoals:[Goal] = [Goal]()
    var notConcludedGoals:[Goal] = [Goal]()
    var goals:[Goal]!
    var goalsShown: String! = "Not Concluded Goals"
    @IBOutlet weak var goalTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        goalTableView.delegate = self
        goalTableView.dataSource = self
        formatter.dateFormat = "dd/MM/yyyy"
        txtDetails.layer.cornerRadius = 12
//        goalTableView.dragDelegate = self
//        goalTableView.dropDelegate = self
//        goalTableView.dragInteractionEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadObjective()
//        goalTableView.reloadData()
    }
    
    func loadObjective(){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Objective")
        request.returnsObjectsAsFaults = false
        if let context = context{
            do{
                let result = try context.fetch(request)
                for data in result as! [NSManagedObject]{
                    if data.value(forKey: "id") as? UUID == objectiveID{
                        currentObjective = data as? Objective
                    }
                }
            }catch{
                fatalError("404 - Non Entity")
            }
        }
        createTableCells()
        updateData()
    }
    
    func updateData(){
        self.navigationItem.title = currentObjective.title
        let totalGoals = notConcludedGoals.count + concludedGoals.count
        lblCompletedGoals.text = String(concludedGoals.count) + "/" + String(totalGoals)
        lblPrevisionDate.text = formatter.string(for: currentObjective.previsionDate! as Date)
        lblRemainingDays.text = String(calculateRemainingDays(date: currentObjective.previsionDate!)) + " dias"
        swtchRating.isOn = currentObjective.rating
        swtchRating.isEnabled = false
        progressCircle.progressValue = CGFloat(((Float(concludedGoals.count) * 100) / Float(totalGoals <= 0 ? 1 : totalGoals)) / 100)
        lblConclusionPercentage.text = String(Int(((concludedGoals.count * 100) / (totalGoals <= 0 ? 1 : totalGoals)))) + "%"
        txtDetails.text = currentObjective.details
    }
    
    func calculateRemainingDays(date:NSDate) -> Int{
        let currentDate = Date()
        let finalDate = date as Date
        let daysRemaining = Calendar.current.dateComponents([.day], from: currentDate, to: finalDate)
        if let days = daysRemaining.day {
            return days
        }
        fatalError("Error: Remaining days equal nil!")
    }
    
    @IBAction func editObjective(_ sender: Any) {
        self.performSegue(withIdentifier: "EditObjective", sender: currentObjective)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditObjective"{
            let displayViewController = segue.destination as! ObjectiveManipulationViewController
//            print(currentObjective)
            displayViewController.objectiveForEditing = currentObjective
//            displayViewController.prepareForEditing()
        }
    }
    
    @IBAction func btnAddGoal(_ sender: Any) {
        let alert = UIAlertController(title: "Nova Meta", message: "Sua meta deve ter título e número de dias que a representem na realidade.", preferredStyle: .alert)
        alert.addTextField(configurationHandler: { (titleTextField) in
            titleTextField.placeholder = "Título"
        })
        alert.addTextField(configurationHandler: { (conclusionDateTextFiled) in
            conclusionDateTextFiled.placeholder = "Data de conclusão"
            conclusionDateTextFiled.text = self.formatter.string(from: Date())
//            conclusionDateTextFiled.delegate = self
            conclusionDateTextFiled.addTarget(self, action: #selector(self.datePickerAsKeyboard), for: .touchDown)
        })
        alert.addAction(UIAlertAction(title: "Cancelar", style: .destructive, handler: { _ in }))
        alert.addAction(UIAlertAction(title: "Criar", style: .default, handler: { (action) in
            if(alert.textFields![0].text != "" && alert.textFields![1].text != ""){
                self.createGoal(goalName: alert.textFields![0].text!, goalPrevisionDate: alert.textFields![1].text!)
                self.createTableCells()
            }else{
                let errorAlert = UIAlertController(title: "Erro", message: "Não foi possivel criar a meta. Por favor, crie novamente e verifique se todos os campos estão preenchidos antes de apertar o botão para criar a meta." , preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in }))
                self.present(errorAlert, animated: true, completion: nil)
            }
        }))
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    @objc func datePickerAsKeyboard(sender: UITextField){
        let datePickerView:UIDatePicker = UIDatePicker()
//        datePickerView.datePickerMode = UIDatePicker
        datePickerView.datePickerMode = .date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        AlertViewConclusionDateTextField = sender
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker){
//        dateFormatter.string(from: sender.date)
        AlertViewConclusionDateTextField.text = formatter.string(from: sender.date)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "GoalCell", for: indexPath) as? GoalTableViewCell{
            return makeTableCell(cell: cell, indexPath: indexPath)
        }
        return UITableViewCell()
    }
    
    func makeTableCell(cell:GoalTableViewCell, indexPath: IndexPath) -> UITableViewCell{
        cell.id = goals[indexPath.row].id
        cell.conclueded = goals[indexPath.row].concluded
        cell.lblTitulo.text = goals[indexPath.row].title
        cell.lblPrevisionDate.text = formatter.string(from: goals[indexPath.row].previsionDate! as Date)
        cell.lblInfo.text = goalsShown == "Not Concluded Goals" ? String(calculateRemainingDays(date: goals[indexPath.row].previsionDate!)) + " dias" : formatter.string(from: goals[indexPath.row].conclusionDate! as Date)
        if goalsShown == "Concluded Goals" {
            let prevision = goals[indexPath.row].previsionDate! as Date
            let conclusion = goals[indexPath.row].conclusionDate! as Date
            print(prevision)
            print(conclusion)
            if (prevision >= conclusion) {
                cell.lblInfo.textColor = UIColor.green
            }else{
                cell.lblInfo.textColor = UIColor.red
            }
        }else{
            cell.lblInfo.textColor = UIColor.black
        }
        return cell
    }
    
    func createTableCells(){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Goal")
        request.returnsObjectsAsFaults = false
        if let context = context{
            do{
                let result = try context.fetch(request)
                notConcludedGoals.removeAll()
                concludedGoals.removeAll()
                for data in result as! [NSManagedObject]{
                    let aux = data as! Goal
                    if(aux.relationshipGoalObjective == currentObjective){
                        if(!aux.concluded){
                            notConcludedGoals.append(data as! Goal)
                        }else{
                            concludedGoals.append(data as! Goal)
                        }
                    }
                }
            }catch{
                fatalError("404 - Non Entity")
            }
        }
        goals = goalsShown == "Not Concluded Goals" ? notConcludedGoals.reversed() : concludedGoals
        goalTableView.reloadData()
        self.updateData()
    }
    
    // Cria uma meta apartir dos dados inseridos no alert
    func createGoal(goalName: String, goalPrevisionDate: String){
        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let goal = NSEntityDescription.insertNewObject(forEntityName: "Goal", into: context!) as! Goal
        goal.id = UUID()
        goal.title = goalName
        goal.concluded = false
        goal.previsionDate = formatter.date(from: goalPrevisionDate)! as NSDate
        goal.conclusionDate = Date() as NSDate
        goal.relationshipGoalObjective = currentObjective
        currentObjective.addToRelationshipObjectiveGoal(goal)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.saveContext()
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Deletar", handler: { (action, view, success) in
            self.currentObjective.removeFromRelationshipObjectiveGoal(self.goals[indexPath.row])
            self.context?.delete(self.goals[indexPath.row])
            self.goals.remove(at: indexPath.row)
            
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            appDelegate.saveContext()
            self.createTableCells()
            self.goalTableView.reloadData()
            self.updateData()
            success(true)
        })
        
        let conclude = UIContextualAction(style: .normal, title: "Concluir", handler: {(action, view, sucess) in
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Goal")
            request.returnsObjectsAsFaults = false
            if let context = self.context{
                do{
                    let result = try context.fetch(request)
                    for data in result as! [NSManagedObject]{
                        if data.value(forKey: "id") as? UUID == self.goals[indexPath.row].id{
                            data.setValue(true, forKey: "concluded")
                        }
                    }
                }catch{
                    fatalError("404 - Non Entity")
                }
            }
//            self.goalTableView.deleteRows(at: [indexPath], with: .fade)
            self.createTableCells()
            self.goalTableView.reloadData()
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            appDelegate.saveContext()
            self.updateData()
            sucess(true)
        })
        conclude.backgroundColor = #colorLiteral(red: 0.2511413097, green: 0.7204080224, blue: 0.8421624303, alpha: 1)
        
        let restore = UIContextualAction(style: .normal, title: "Restaurar", handler: {(action, view, sucess) in
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Goal")
            request.returnsObjectsAsFaults = false
            if let context = self.context{
                do{
                    let result = try context.fetch(request)
                    for data in result as! [NSManagedObject]{
                        if data.value(forKey: "id") as? UUID == self.goals[indexPath.row].id{
                            data.setValue(false, forKey: "concluded")
                        }
                    }
                }catch{
                    fatalError("404 - Non Entity")
                }
            }
            //            self.goalTableView.deleteRows(at: [indexPath], with: .fade)
            self.createTableCells()
            self.goalTableView.reloadData()
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            appDelegate.saveContext()
            self.updateData()
            sucess(true)
        })
        restore.backgroundColor = #colorLiteral(red: 0.345752418, green: 0.317552954, blue: 0.3172644079, alpha: 1)
        
        if(goalsShown == "Not Concluded Goals"){
            return UISwipeActionsConfiguration(actions: [conclude, deleteAction])
        }
        return UISwipeActionsConfiguration(actions: [restore, deleteAction])
    }
}
