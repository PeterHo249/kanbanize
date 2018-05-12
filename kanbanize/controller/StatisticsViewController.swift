//
//  StatisticsViewController.swift
//  kanbanize
//
//  Created by Peter Ho on 4/17/18.
//  Copyright © 2018 Peter Ho. All rights reserved.
//

import UIKit

class StatisticsViewController: UIViewController {
 var currentDemoController: UIViewController?
    // MARK - Delegate
    
    // MARK - Varible
    var boardName = ""
    // MARK - Datasource
    
    
    // MARK - Outlet
    
    
    // MARK - Action
    
    
    // MARK - Segue
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let ChartView = ChartViewController()
        ChartView.boardName=boardName
       showExampleController(ChartView)
        print("vao statict")
        print(boardName)
    }
    fileprivate func showExampleController(_ controller: UIViewController) {
        if let currentDemoController = currentDemoController {
            currentDemoController.removeFromParentViewController()
            currentDemoController.view.removeFromSuperview()
        }
        addChildViewController(controller)
        controller.view.frame = view.bounds
        view.addSubview(controller.view)
        currentDemoController = controller
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Statistics"
        self.tabBarController?.navigationItem.title = "Statistics"
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
