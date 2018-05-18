//
//  StatisticsViewController.swift
//  kanbanize
//
//  Created by Peter Ho on 4/17/18.
//  Copyright © 2018 Peter Ho. All rights reserved.
//

import UIKit

class StatisticsViewController: UIViewController {
 
    // MARK - Delegate
    
    // MARK - Varible
    var boardName = ""
    var currentController: UIViewController?
    // MARK - Datasource
    
    
    // MARK - Outlet
    
    
    // MARK - Action
    
    
    // MARK - Segue
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let ChartView:DoughnutDemo? = DoughnutDemo()
        ChartView?.boardName = boardName
        showController(ChartView!)


        // Do any additional setup after loading the view.
        self.tabBarController?.navigationItem.rightBarButtonItems = []

    }

    fileprivate func showController(_ controller: UIViewController) {
        if let currentController = currentController {
            currentController.removeFromParentViewController()
            currentController.view.removeFromSuperview()
        }
        addChildViewController(controller)
        controller.view.frame = view.bounds
        view.addSubview(controller.view)
        currentController = controller
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Statistics"
        self.tabBarController?.navigationItem.title = "Statistics"
        
        self.tabBarController?.navigationItem.rightBarButtonItems = []
        
        let ChartView:DoughnutDemo? = DoughnutDemo()
        ChartView?.boardName = boardName
        showController(ChartView!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
