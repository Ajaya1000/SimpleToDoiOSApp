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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Save button
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveTask))
        
         field.delegate = self
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
        info[ToDoModel.text] = text
        info[ToDoModel.isMarkedCompleted] = false
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.toDoNotificationKey), object: nil,userInfo: info)
        
        navigationController?.popViewController(animated: true)
    }

}
