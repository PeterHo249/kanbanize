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
    
    
    // MARK - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let desVC = segue.destination as! BoardDetailViewController
        desVC.boardName = (boards[(boardTableView.indexPathForSelectedRow?.row)!] as! Board).name!
    }
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        boards = Board.All()
        
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

