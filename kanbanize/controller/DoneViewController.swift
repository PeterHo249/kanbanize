//
//  DoneViewController.swift
//  kanbanize
//
//  Created by Peter Ho on 4/17/18.
//  Copyright © 2018 Peter Ho. All rights reserved.
//

import UIKit
import CoreData

class DoneViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK - Delegate
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            DB.MOC.delete(tasks[indexPath.row])
            tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            DB.Save()
        }
    }
    
    func MoveItem(fromIndex from: Int, toIndex to: Int) {
        let item = tasks[from]
        tasks.remove(at: from)
        tasks.insert(item, at: to)
        UpdateOrder()
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        MoveItem(fromIndex: sourceIndexPath.row, toIndex: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ViewDetailAction(index: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let actionSheet = UIAlertController(title: "Task Action", message: "Please choose one action!", preferredStyle: .actionSheet)
        
        let moveDoingAction = UIAlertAction(title: "Move to To-Do", style: .default, handler: {alert -> Void in
            self.MoveTaskAction(index: indexPath.row, status: "todo")
        })
        let moveDoneAction = UIAlertAction(title: "Move to Doing", style: .default, handler: {alert -> Void in
            self.MoveTaskAction(index: indexPath.row, status: "doing")
        })
        let viewDetailAction = UIAlertAction(title: "View Detail", style: .default, handler: {alert -> Void in
            self.ViewDetailAction(index: indexPath.row)
        })
        let shareAction = UIAlertAction(title: "Share Task", style: .default, handler: {alert -> Void in
            self.ShareAction(task: self.tasks[indexPath.row] as! Task)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionSheet.addAction(moveDoingAction)
        actionSheet.addAction(moveDoneAction)
        actionSheet.addAction(viewDetailAction)
        actionSheet.addAction(shareAction)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let moveDoingAction = UIContextualAction(style: .normal, title: "Move to Doing") {
            (action, view, handler) in
            self.MoveTaskAction(index: indexPath.row, status: "doing")
        }
        
        moveDoingAction.backgroundColor = .yellow
        let configuration = UISwipeActionsConfiguration(actions: [moveDoingAction])
        return configuration
    }
    
    // MARK - Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath) as! TaskTableViewCell
        let taskInfo = tasks[indexPath.row] as! Task
        
        cell.LoadContent(name: taskInfo.name!, dueDate: taskInfo.dueDate! as Date, status: taskInfo.status!)
        
        return cell
    }
    
    // MARK - Outlet
    @IBOutlet weak var tableView: UITableView!
    
    // MARK - Variable
    var boardName = ""
    let id = "done"
    var tasks = [NSManagedObject]()
    
    
    // MARK - Action
    @objc func AddButtonPressed() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let editVC = storyBoard.instantiateViewController(withIdentifier: "TaskDetailViewController") as! TaskDetailViewController
        editVC.modeFlag = true
        editVC.sourceViewController = self
        editVC.sourceStatus = id
        editVC.currentBoard = boardName
        self.tabBarController?.navigationController?.pushViewController(editVC, animated: true)
    }
    
    @objc func EditButtonPressed(sender: UIBarButtonItem) {
        if (sender.title == "Done") {
            self.tableView.setEditing(false, animated: true)
            sender.title = "Edit"
            sender.style = .plain
        } else {
            self.tableView.setEditing(true, animated: true)
            sender.title = "Done"
            sender.style = .done
        }
    }
    
    func MoveTaskAction(index: Int, status: String) {
        (tasks[index] as! Task).ChangeStatus(status: status)
        
        tasks.remove(at: index)
        tableView.reloadData()
    }
    
    func ViewDetailAction(index: Int) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let editVC = storyBoard.instantiateViewController(withIdentifier: "TaskDetailViewController") as! TaskDetailViewController
        editVC.taskInfo = tasks[index] as! Task
        editVC.selectedIndex = index
        editVC.modeFlag = false
        editVC.sourceViewController = self
        editVC.sourceStatus = id
        editVC.currentBoard = boardName
        self.tabBarController?.navigationController?.pushViewController(editVC, animated: true)
    }
    
    func ShareAction(task: Task) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        let text = "I have a task: \(task.name!), due at \(dateFormatter.string(from: task.dueDate! as Date))."
        
        let textToShare = [text]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        present(activityViewController, animated: true, completion: nil)
    }
    
    // MARK - Helper
    func UpdateOrder() {
        var i = 0
        for task in tasks {
            task.setValue(i, forKey: "order")
            i = i + 1
        }
        DB.Save()
    }
    
    
    // MARK - Segue
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.title = "Done"
        self.tabBarController?.navigationItem.title = "Done"
        tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: "TaskTableViewCell")
        let xib = UINib(nibName: "TaskTableCell", bundle: nil)
        tableView.register(xib, forCellReuseIdentifier: "TaskTableViewCell")
        tableView.rowHeight = 70
        
        tasks = Task.FetchData(sort: true, board: boardName, status: id) + Task.FetchData(sort: true, board: boardName, status: "overdue")
        
        let addButton = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(self.AddButtonPressed))
        let editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(self.EditButtonPressed))
        
        
        self.tabBarController?.navigationItem.rightBarButtonItems = [addButton, editButton]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Done"
        self.tabBarController?.navigationItem.title = "Done"
        
        tasks = Task.FetchData(sort: true, board: boardName, status: id) + Task.FetchData(sort: true, board: boardName, status: "overdue")
        tableView.reloadData()
        
        let addButton = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(self.AddButtonPressed))
        let editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(self.EditButtonPressed))
        self.tabBarController?.navigationItem.rightBarButtonItems = [addButton, editButton]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if (tableView.isEditing) {
            tableView.setEditing(false, animated: true)
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
