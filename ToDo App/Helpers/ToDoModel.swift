//
//  ToDoModel.swift
//  ToDo App
//
//  Created by Ajaya Mati on 24/06/22.
//

import Foundation
import CoreData

struct ToDoModel {
    static let text = "text"
    static let isMarkedCompleted = "isMarkedCompleted"
    
    static func createTodo(_ context: NSManagedObjectContext,info : NSDictionary?) -> NSManagedObject?{
        
        guard let dict = info, let text = dict[ToDoModel.text] as? String, let isMarkedCompleted = dict[ToDoModel.isMarkedCompleted] as? Bool else{
            return nil
        }
        
        let entity = NSEntityDescription.entity(forEntityName: "ToDo", in: context)!
        
        let toDo = NSManagedObject(entity: entity, insertInto: context)
        
        toDo.setValue(text, forKey: ToDoModel.text)
        toDo.setValue(isMarkedCompleted, forKey: ToDoModel.isMarkedCompleted)
        
        return toDo
    }
}
