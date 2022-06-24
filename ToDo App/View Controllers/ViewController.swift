//
//  ViewController.swift
//  ToDo App
//
//  Created by Ajaya Mati on 22/06/22.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet var tableView:UITableView!
    
    var tasks = [NSManagedObject]()
    
    var context:NSManagedObjectContext{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }

    // MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Tasks"
        tableView.delegate = self
        tableView.dataSource = self
        
        
        // Setting up Notification Observer
        NotificationCenter.default.addObserver(self, selector: #selector(saveTask(_:)), name: Notification.Name(rawValue:Constants.toDoNotificationKey), object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadTasks()
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // MARK: -Custom Functions
    
    func loadTasks() {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName:"ToDo")
        
        do{
            tasks = try context.fetch(fetchRequest)
        }catch let error as NSError{
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        tableView.reloadData()
    }
    
    func syncContext(errorMessage: String){
        do{
            try context.save()
            
            // Reload All the tasks
            DispatchQueue.main.async { [weak self] in
                self?.loadTasks()
            }
            
        }catch let error as NSError{
            print("\(errorMessage) \(error), \(error.userInfo)")
        }
    }
    
    @objc func saveTask(_ notification: NSNotification){
        
        _ = ToDoModel.createTodo(context,info: notification.userInfo as NSDictionary?)
        
        syncContext(errorMessage: "Couldn't save!")
    }
    
    @IBAction func didTapAdd(){
        let entryVC = storyboard?.instantiateViewController(withIdentifier: "EntryVC") as! EntryViewController
        entryVC.title = "New Task"

        navigationController?.pushViewController(entryVC, animated: true)
    }

}

extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let currentStatus = tasks[indexPath.row].value(forKeyPath:ToDoModel.isMarkedCompleted) as! Bool
        
        tasks[indexPath.row].setValue(!currentStatus, forKey: ToDoModel.isMarkedCompleted)
        
        syncContext(errorMessage: "Error while updating status")
    }
}

extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("ToDoIncompleteCell", owner: self.tableView, options: nil)?.first as! ToDoIncompleteCell
        let task = tasks[indexPath.row]
        
        cell.label.text = task.value(forKeyPath: ToDoModel.text) as? String
        cell.checkbox.isChecked = task.value(forKeyPath: ToDoModel.isMarkedCompleted) as! Bool
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        40
    }
}
