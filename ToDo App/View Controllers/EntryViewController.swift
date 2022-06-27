//
//  EntryViewController.swift
//  ToDo App
//
//  Created by Ajaya Mati on 22/06/22.
//

import UIKit
import CoreData

class EntryViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet var field: UITextField!
    var task: NSManagedObject?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Save button
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveTask))
        
         field.delegate = self
        
        guard let text = task?.value(forKeyPath: ToDoModel.text) as? String,let isChecked = task?.value(forKeyPath: ToDoModel.isMarkedCompleted) as? Bool else {
            return
        }
        
        field.text = text
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        saveTask()
        return true
    }
    
    @objc func saveTask(){

        guard let text = field.text,!text.isEmpty else{
            return
        }
        
        var info = [String:Any]()
        
        if(task != nil){
            info["isNew"] = false
            task!.setValue(text, forKeyPath: ToDoModel.text)
        }
        else{
            info["isNew"] = true
            info[ToDoModel.text] = text
            info[ToDoModel.isMarkedCompleted] = false
        }
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.toDoNotificationKey), object: nil,userInfo: info)
        
        navigationController?.popViewController(animated: true)
    }

}
