//
//  BoardDetailViewController.swift
//  kanbanize
//
//  Created by Peter Ho on 4/23/18.
//  Copyright © 2018 Peter Ho. All rights reserved.
//

import UIKit
import CoreData

class BoardDetailViewController: UITabBarController {

    var boardName = ""
    
    func UpdateStatus() {
        let tasks = Task.FetchData(sort: false, board: boardName, status: "todo") + Task.FetchData(sort: false, board: boardName, status: "doing")
        let currentDate = Date()
        for task in tasks {
            if (((task as! Task).dueDate! as Date) < currentDate) {
                task.setValue("overdue", forKey: "status")
            }
        }
        DB.Save()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let viewControllers = self.viewControllers
        (viewControllers![0] as! ToDoViewController).boardName = boardName
        (viewControllers![1] as! DoingViewController).boardName = boardName
        (viewControllers![2] as! DoneViewController).boardName = boardName
        (viewControllers![3] as! StatisticsViewController).boardName = boardName
        (viewControllers![4] as! SearchViewController).boardName = boardName
        
        UpdateStatus()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
