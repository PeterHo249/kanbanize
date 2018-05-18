//
//  BoardDetailViewController.swift
//  kanbanize
//
//  Created by Peter Ho on 4/23/18.
//  Copyright © 2018 Peter Ho. All rights reserved.
//

import UIKit

class BoardDetailViewController: UITabBarController {

    var boardName = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let viewControllers = self.viewControllers
        (viewControllers![0] as! ToDoViewController).boardName = boardName
        (viewControllers![1] as! DoingViewController).boardName = boardName
        (viewControllers![2] as! DoneViewController).boardName = boardName
        (viewControllers![3] as! StatisticsViewController).boardName = boardName
        (viewControllers![4] as! SearchViewController).boardName = boardName

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
