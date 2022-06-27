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
    
    var tasks = ToDoModel()

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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadTasks()
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // MARK: -Custom Functions
    
    func loadTasks() {
        tasks.loadToDo {
            tableView.reloadData()
        }
    }
    
    @objc func saveTask(_ notification: NSNotification){

        tasks.createOrUpdateTodo(info: notification.userInfo as NSDictionary?)
        
        tasks.syncContext(errorMessage: "Couldn't save or Update!",onCompletion: loadTasks)
    }
    

    @IBAction func didTapAdd(){
        let entryVC = storyboard?.instantiateViewController(withIdentifier: "EntryVC") as! EntryViewController
        entryVC.title = "New Task"

        navigationController?.pushViewController(entryVC, animated: true)
    }

}

extension ViewController: UITableViewDelegate{
    
    func handleDelete(_ indexPath:IndexPath){
        
        let currentTask = tasks[indexPath.section,indexPath.row]
        
        tasks.removeToDo(currentTask){
            tasks.loadToDo {
                
            }
        }
        
        tableView.deleteRows(at: [indexPath], with: .fade)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let entryVC = storyboard?.instantiateViewController(withIdentifier: "EntryVC") as! EntryViewController
        entryVC.title = "Update Task"
        entryVC.task = tasks[indexPath.section,indexPath.row]
        navigationController?.pushViewController(entryVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .normal,
                                        title: "Delete") { [weak self] (action, view, completionHandler) in
                                            self?.handleDelete(indexPath)
                                            completionHandler(true)
        }
        action.backgroundColor = .systemRed
        
        return UISwipeActionsConfiguration(actions: [action])
    }
}

extension ViewController: UITableViewDataSource{
    
    @objc func toggleStatus(_ sender: UIButton){
        let touchPoint: CGPoint = sender.convert(.zero, to: tableView)
        let clickedButtonIndexPath = tableView.indexPathForRow(at: touchPoint)
        
        guard let indexPath = clickedButtonIndexPath else{
            return
        }
        
        let section =  Int(indexPath.section)
        let row = Int(indexPath.row)
        
        let currentTask = tasks[section, row]
        let currentStatus = currentTask.value(forKeyPath:ToDoModel.isMarkedCompleted) as! Bool

        currentTask.setValue(!currentStatus, forKey: ToDoModel.isMarkedCompleted)
        
        tasks.syncContext(errorMessage: "Error while updating status",onCompletion: loadTasks)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        ToDoModel.sections.count
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//
//    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = Bundle.main.loadNibNamed("TableHeaderView", owner: self.tableView, options: nil)?.first as! TableHeaderView
            
        header.label.text = ToDoModel.sections[section]
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return tasks.incompleteTasks.count
        }
        else{
            return tasks.completedTasks.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let task = tasks[indexPath.section,indexPath.row]
        
        let text = task.value(forKeyPath: ToDoModel.text) as? String
        let isChecked = task.value(forKeyPath: ToDoModel.isMarkedCompleted) as! Bool
        
        if isChecked == true {
            let cell = Bundle.main.loadNibNamed("ToDoCompleteCell", owner: self.tableView, options: nil)?.first as! ToDoCompleteCell
            
            cell.checkbox.isChecked = isChecked
            cell.label.text = text
        
            cell.checkbox.button.addTarget(self, action: #selector(toggleStatus(_:)), for: .touchUpInside)
            
            return cell
        }
        
        let cell = Bundle.main.loadNibNamed("ToDoIncompleteCell", owner: self.tableView, options: nil)?.first as! ToDoIncompleteCell
        
        cell.checkbox.isChecked = isChecked
        cell.label.text = text
        
        cell.checkbox.button.addTarget(self, action: #selector(toggleStatus(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        40
    }
    
    @objc func someAction(){
        print("Clicked")
    }
}
