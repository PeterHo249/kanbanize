//
//  ToDoViewController.swift
//  kanbanize
//
//  Created by Peter Ho on 4/17/18.
//  Copyright © 2018 Peter Ho. All rights reserved.
//

import UIKit
import CoreData

class ToDoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

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
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let editVC = storyBoard.instantiateViewController(withIdentifier: "TaskDetailViewController") as! TaskDetailViewController
        editVC.taskInfo = tasks[indexPath.row] as! Task
        editVC.selectedIndex = indexPath.row
        editVC.modeFlag = false
        editVC.sourceViewController = self
        editVC.sourceStatus = id
        editVC.currentBoard = boardName
        self.tabBarController?.navigationController?.pushViewController(editVC, animated: true)
    }
    
    
    // MARK - Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath) as! TaskTableViewCell
        let taskInfo = tasks[indexPath.row] as! Task
        cell.nameLabel.text = taskInfo.name
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .short
        cell.dueDateLabel.text = dateFormatter.string(from: taskInfo.dueDate! as Date)
        switch taskInfo.status {
        case "todo":
            cell.statusIndicator.textColor = UIColor.blue
            break
        case "doing":
            cell.statusIndicator.textColor = UIColor.yellow
            break
        case "done":
            cell.statusIndicator.textColor = UIColor.green
            break
        default:
            cell.statusIndicator.textColor = UIColor.red
        }
        
        return cell
    }
    
    // MARK - Outlet
    @IBOutlet weak var tableView: UITableView!
    
    // MARK - Variable
    var boardName = ""
    let id = "todo"
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
            print(self.tableView.isEditing)
            sender.title = "Edit"
            sender.style = .plain
        } else {
            self.tableView.setEditing(true, animated: true)
            print(self.tableView.isEditing)
            sender.title = "Done"
            sender.style = .done
        }
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
        self.title = "To-do"
        self.tabBarController?.navigationItem.title = "To-do"
        tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: "TaskTableViewCell")
        let xib = UINib(nibName: "TaskTableCell", bundle: nil)
        tableView.register(xib, forCellReuseIdentifier: "TaskTableViewCell")
        tableView.rowHeight = 70
        
        tasks = Task.FetchData(sort: true, board: boardName, status: id)
        
        let addButton = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(self.AddButtonPressed))
        let editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(self.EditButtonPressed))
        
        
        self.tabBarController?.navigationItem.rightBarButtonItems = [addButton, editButton]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "To-do"
        self.tabBarController?.navigationItem.title = "To-do"
        tasks = Task.FetchData(sort: true, board: boardName, status: id)
        tableView.reloadData()
        let addButton = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(self.AddButtonPressed))
        let editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(self.EditButtonPressed))
        self.tabBarController?.navigationItem.rightBarButtonItems = [addButton, editButton]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
