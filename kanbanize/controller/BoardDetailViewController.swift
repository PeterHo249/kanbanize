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
        print("boardName of tab bar controller \(boardName)")
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
