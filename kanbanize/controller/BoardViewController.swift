//
//  ViewController.swift
//  kanbanize
//
//  Created by Peter Ho on 4/17/18.
//  Copyright © 2018 Peter Ho. All rights reserved.
//

import UIKit
import CoreData

class BoardViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK - Delegate
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            DB.MOC.delete(boards[indexPath.row])
            boards.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            DB.Save()
        }
    }
    
    func MoveItem(fromIndex from: Int, toIndex to: Int) {
        let item = boards[from]
        boards.remove(at: from)
        boards.insert(item, at: to)
        UpdateOrder()
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        MoveItem(fromIndex: sourceIndexPath.row, toIndex: destinationIndexPath.row)
    }
    
    // MARK - Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return boards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BoardTableViewCell", for: indexPath) as! BoardTableViewCell
        // TODO - Implement code for cell
        let boardInfo = boards[indexPath.row] as! Board
        cell.boardNameLabel.text = boardInfo.name
        
        return cell
    }
    
    
    // MARK - Variable
    var boards = [NSManagedObject]()
    
    
    // MARK - Outlet
     @IBOutlet weak var boardTableView: UITableView!
    
    // MARK - Action
    @objc func AddButtonPressed(sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Add New Board", message: "Enter name of new board!", preferredStyle: .alert)
        alertController.addTextField {
            (textfield) in textfield.placeholder = "Enter Name"
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: {alert -> Void in
            let nameTextField = alertController.textFields![0] as UITextField
            if (nameTextField.text != nil) {
                if (!self.AddNewBoard(name: nameTextField.text!)) {
                    let errorAlertController = UIAlertController(title: "Enter A New Namw", message: "\(nameTextField.text!) is already. Please enter a new name", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    errorAlertController.addAction(okAction)
                    self.present(errorAlertController, animated: true, completion: nil)
                }
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func EditButtonPressed(sender: UIBarButtonItem) {
        if (sender.title == "Done") {
            self.boardTableView.setEditing(false, animated: true)
            sender.title = "Edit"
            sender.style = .plain
        } else {
            self.boardTableView.setEditing(true, animated: true)
            sender.title = "Done"
            sender.style = .done
        }
    }
    
    // MARK - Helper
    func AddNewBoard(name: String) -> Bool {
        for board in boards {
            if ((board as! Board).name == name) {
                return false
            }
        }
        
        let newBoard = Board.Create()
        newBoard.setValue(name, forKey: "name")
        newBoard.setValue(boards.count, forKey: "nameOrder")
        boards.append(newBoard)
        boardTableView.reloadData()
        DB.Save()
        
        return true
    }
    
    func UpdateOrder() {
        var i = 0
        for board in boards {
            board.setValue(i, forKey: "nameOrder")
            i = i + 1
        }
        
        DB.Save()
    }
    
    // MARK - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let desVC = segue.destination as! BoardDetailViewController
        desVC.boardName = (boards[(boardTableView.indexPathForSelectedRow?.row)!] as! Board).name!
    }
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        boards = Board.All()
        
        let addButton = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(self.AddButtonPressed))
        let editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(self.EditButtonPressed))
        
        self.tabBarController?.navigationItem.rightBarButtonItems = [addButton, editButton]
        
        // Init data for testing
        if boards.count == 0 {
            print("start init data")
            let boardItem = Board.Create() as! Board
            boardItem.name = "todo"
            boardItem.nameOrder = 1
            DB.Save()
            
            var taskItem = Task.Create() as! Task
            taskItem.name = "Todo task"
            taskItem.dueDate = Date() as NSDate
            taskItem.status = "todo"
            taskItem.label = "label"
            taskItem.detail = "some detail"
            taskItem.board = "todo"
            taskItem.order = 1
            DB.Save()
            
            taskItem = Task.Create() as! Task
            taskItem.name = "Doing task"
            taskItem.dueDate = Date() as NSDate
            taskItem.status = "doing"
            taskItem.label = "label"
            taskItem.detail = "some detail"
            taskItem.board = "todo"
            taskItem.order = 2
            DB.Save()
            
            taskItem = Task.Create() as! Task
            taskItem.name = "Done task"
            taskItem.dueDate = Date() as NSDate
            taskItem.status = "done"
            taskItem.label = "label"
            taskItem.detail = "some detail"
            taskItem.board = "todo"
            taskItem.order = 3
            DB.Save()
            
            taskItem = Task.Create() as! Task
            taskItem.name = "overdue task"
            taskItem.dueDate = Date() as NSDate
            taskItem.status = "overdue"
            taskItem.label = "label"
            taskItem.detail = "some detail"
            taskItem.board = "todo"
            taskItem.order = 4
            DB.Save()
            
            boards = Board.All()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

