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
    
    var context : NSManagedObjectContext?
    
    
    @IBOutlet weak var tfldTitle: UITextField!
    @IBOutlet weak var swtchRating: UISwitch!
    @IBOutlet weak var pckrPrevisionDate: UIDatePicker!
    @IBOutlet weak var tfldDetails: UITextField!
    
    var objectiveForEditing: Objective?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tfldTitle.delegate = self
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        pckrPrevisionDate.minimumDate = Date()
        if(objectiveForEditing != nil){
            prepareForEditing()
        }
    }
    
    @IBAction func btnOK(_ sender: Any) {
        if tfldTitle.text == nil || tfldTitle.text == "" {
            print("num deu")
        }else if(objectiveForEditing == nil){
            createObjective()
            navigationController?.popViewController(animated: true)
        }else{
            updateObjectiveInCoreData()
        }
    }
    
    func createObjective(){
        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let objective = NSEntityDescription.insertNewObject(forEntityName: "Objective", into: context!) as! Objective
        objective.id = UUID()
        objective.title = tfldTitle.text
        objective.rating = swtchRating.isOn
        objective.previsionDate = pckrPrevisionDate.date as NSDate
        objective.details = tfldDetails.text
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.saveContext()
        createNotification(title: objective.title!, body: "Hoje termina o prazo de conclusão do seu objetivo. Veja sua evolução!", time: objective.previsionDate! as Date, identifier: objective.id!.uuidString)
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
                        data.setValue(tfldDetails.text, forKey: "details")
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
        tfldDetails.text = obj.details
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
    
    override func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        switch section {
        case 0:
            guard let footer = view as? UITableViewHeaderFooterView else { return }
            footer.textLabel?.text = "O título do objetivo deve ser sucinto e direto. Não dê títulos muito logos, apenas vá direto ao ponto com 1 ou 2 palavras."
            footer.textLabel?.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2499197346)
            footer.textLabel?.font = UIFont(name: footer.textLabel!.font.fontName, size: 13)
            footer.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
            footer.textLabel?.numberOfLines = 0
            footer.textLabel?.sizeToFit()
        case 1:
            guard let footer = view as? UITableViewHeaderFooterView else { return }
            footer.textLabel?.text = "Seu objetivo pode ter máxima prioridade em sua vida ou apenas ser algo que você deseja alcançar mas que não seja prioritário."
            footer.textLabel?.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2499197346)
        case 2:
            guard let footer = view as? UITableViewHeaderFooterView else { return }
            footer.textLabel?.text = "A data de previsão deve ser realista e deve fazer sentido com o tempo que levará para dar cada passo em direção a ele."
            footer.textLabel?.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2499197346)
        case 3:
            guard let footer = view as? UITableViewHeaderFooterView else { return }
            footer.textLabel?.text = "Escreva o resultado desejado em seu objetivo. Detalhe com precisão e diretamente o que você deseja alcançar e em quanto tempo."
            footer.textLabel?.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2499197346)
        default:
            break
        }
    }
    
//    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        switch section {
//        case 0:
//            let footer = UITableViewHeaderFooterView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 28))
//            footer.textLabel?.text = "sadfadfadadg"
//            return footer
//        default:
//            break
//        }
//        return UIView()
//    }
}
