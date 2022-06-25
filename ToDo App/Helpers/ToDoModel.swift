//
//  ToDoModel.swift
//  ToDo App
//
//  Created by Ajaya Mati on 24/06/22.
//

import UIKit
import CoreData

class ToDoModel {
    
    // MARK: Static Methods & Properties
    
    static let entityName = "ToDo"
    static let text = "text"
    static let isMarkedCompleted = "isMarkedCompleted"
    static var sections = ["Incomplete", "Completed"]
    
    static var context : NSManagedObjectContext{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    // MARK: - Instance methods & properties
    
    var completedTasks = [NSManagedObject]()
    var incompleteTasks = [NSManagedObject]()
    
    func createOrUpdateTodo(info : NSDictionary?){
        guard let dict = info else{
            return
        }
        if (dict["isNew"] as? Bool)! {
            
            if let text = dict[ToDoModel.text] as? String, let isMarkedCompleted = dict[ToDoModel.isMarkedCompleted] as? Bool{
            
            //create a new task if exists
            let entity = NSEntityDescription.entity(forEntityName: "ToDo", in: ToDoModel.context)!
            
            let toDo = NSManagedObject(entity: entity, insertInto: ToDoModel.context)
            
            toDo.setValue(text, forKey: ToDoModel.text)
            toDo.setValue(isMarkedCompleted, forKey: ToDoModel.isMarkedCompleted)
            
            }
        }
        
    }
    
    func removeToDo(_ task:NSManagedObject,onCompletion:()->()){
        ToDoModel.context.delete(task)
        syncContext(errorMessage: "Error while deleting", onCompletion: onCompletion)
    }
    
    func loadToDo(onCompletion:()->()){
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName:ToDoModel.entityName)
        
        do{
            let tasks = try ToDoModel.context.fetch(fetchRequest)
            
            completedTasks.removeAll()
            incompleteTasks.removeAll()
            
            for task in tasks{
                let isChecked = task.value(forKeyPath: ToDoModel.isMarkedCompleted) as! Bool
                if isChecked{
                    completedTasks.append(task)
                }
                else{
                    incompleteTasks.append(task)
                }
                
                onCompletion()
            }
        }catch let error as NSError{
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func syncContext(errorMessage: String,onCompletion: ()->()){
        
        do{
            try ToDoModel.context.save()
            onCompletion()
        }catch let error as NSError{
            print("\(errorMessage) \(error), \(error.userInfo)")
        }
    }

    subscript(section:Int,row:Int)->NSManagedObject{
        get{
            if section == 0{
                return incompleteTasks[row]
            }
            else {
                return completedTasks[row]
            }
        }
        set{
            if section == 0{
                incompleteTasks[row] = newValue
            }
            else {
                completedTasks[row] = newValue
            }
        }
    }
}
