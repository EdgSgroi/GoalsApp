//
//  ObjectiveManipulationViewController.swift
//  GoalsApp
//
//  Created by Edgar Sgroi on 19/07/19.
//  Copyright © 2019 Edgar Sgroi. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ObjectiveManipulationViewController : UITableViewController, UITextFieldDelegate{
    
    var context: NSManagedObjectContext?
    var viewModel: ObjectiveManipulationViewModel!
    
    @IBOutlet weak var tfldTitle: UITextField!
    @IBOutlet weak var swtchRating: UISwitch!
    @IBOutlet weak var pckrPrevisionDate: UIDatePicker!
    @IBOutlet weak var txtDetails: UITextView!
    
    var objectiveForEditing: Objective?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        viewModel = ObjectiveManipulationViewModel(context: context, appDelegate: appDelegate)
        tfldTitle.delegate = self
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        pckrPrevisionDate.minimumDate = Date()
        if(objectiveForEditing != nil) {
            prepareForEditing()
        }
    }
    
    @IBAction func btnOK(_ sender: Any) {
        if tfldTitle.text == nil || tfldTitle.text == "" {
            print("num deu")
        }else if(objectiveForEditing == nil) {
            createObjective()
            navigationController?.popViewController(animated: true)
        }else{
            updateObjectiveInCoreData()
        }
    }
    
    func createObjective() {
        viewModel.title = tfldTitle.text ?? ""
        viewModel.rating = swtchRating.isOn
        viewModel.previsionDate = pckrPrevisionDate.date
        viewModel.details = txtDetails.text
        viewModel.createNewObjective()
    }
    
    func updateObjectiveInCoreData(){
        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Objective")
        request.returnsObjectsAsFaults = false
        if let context = context{
            do{
                let result = try context.fetch(request)
                for data in result as! [NSManagedObject]{
                    if data.value(forKey: "id") as? UUID == objectiveForEditing?.id{
                        data.setValue(tfldTitle.text, forKey: "title")
                        data.setValue(swtchRating.isOn, forKey: "rating")
                        data.setValue(pckrPrevisionDate.date, forKey: "previsionDate")
                        data.setValue(txtDetails.text, forKey: "details")
                    }
                }
                self.createNotification(title: tfldTitle.text!, body: "Hoje termina o prazo de conclusão do seu objetivo. Veja sua evolução!", time: pckrPrevisionDate.date, identifier: (objectiveForEditing?.id!.uuidString)!)
            }catch{
                fatalError("404 - Non Entity")
            }
        }
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.saveContext()
        navigationController?.popViewController(animated: true)
    }
    
    func prepareForEditing(){
        self.navigationItem.title = "Editar Objetivo"
        self.navigationItem.rightBarButtonItem?.title = "Salvar"
        guard let obj = objectiveForEditing else { return }
        tfldTitle.text = obj.title
        swtchRating.isOn = obj.rating
        pckrPrevisionDate.date = obj.previsionDate! as Date
        txtDetails.text = obj.details
        txtDetails.textColor = UIColor.black
    }
}

extension ObjectiveManipulationViewController {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //        textField.resignFirstResponder()
        self.view.endEditing(true)
        return false
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        switch section {
            case 2:
            guard let header = view as? UITableViewHeaderFooterView else { return }
            header.textLabel?.text = "DATA DE PREVISÃO"
            header.textLabel?.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2499197346)
            header.textLabel?.font = UIFont(name: header.textLabel!.font.fontName, size: 13)
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        switch section {
        case 0:
            guard let footer = view as? UITableViewHeaderFooterView else { return }
            footer.textLabel?.clipsToBounds = true
            footer.textLabel?.numberOfLines = 0
            footer.textLabel?.text = "Name your goal."
            footer.textLabel?.textColor = #colorLiteral(red: 0.5568627451, green: 0.5568627451, blue: 0.5764705882, alpha: 0.7451305651)
            footer.textLabel?.font = UIFont(name: footer.textLabel!.font.fontName, size: 13)
        case 1:
            guard let footer = view as? UITableViewHeaderFooterView else { return }
            footer.textLabel?.clipsToBounds = true
            footer.textLabel?.numberOfLines = 0
            footer.textLabel?.text = "Mark as a priority objective."
            footer.textLabel?.textColor = #colorLiteral(red: 0.5568627451, green: 0.5568627451, blue: 0.5764705882, alpha: 0.7504815925)
            footer.textLabel?.font = UIFont(name: footer.textLabel!.font.fontName, size: 13)
        case 2:
            guard let footer = view as? UITableViewHeaderFooterView else { return }
            footer.textLabel?.clipsToBounds = true
            footer.textLabel?.numberOfLines = 0
            footer.textLabel?.text = "Enter realistic forecast dates."
            footer.textLabel?.textColor = #colorLiteral(red: 0.5568627451, green: 0.5568627451, blue: 0.5764705882, alpha: 0.7539597603)
            footer.textLabel?.font = UIFont(name: footer.textLabel!.font.fontName, size: 13)
        case 3:
            guard let footer = view as? UITableViewHeaderFooterView else { return }
            footer.textLabel?.clipsToBounds = true
            footer.textLabel?.numberOfLines = 0
            footer.textLabel?.text = "Enter the details and the expected result."
            footer.textLabel?.textColor = #colorLiteral(red: 0.5568627451, green: 0.5568627451, blue: 0.5764705882, alpha: 0.7481806507)
            footer.textLabel?.font = UIFont(name: footer.textLabel!.font.fontName, size: 13)
        default:
            break
        }
    }
}
