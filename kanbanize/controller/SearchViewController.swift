//
//  SearchViewController.swift
//  kanbanize
//
//  Created by Peter Ho on 5/14/18.
//  Copyright © 2018 Peter Ho. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    // MARK - Variable
    var boardName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tabBarController?.navigationItem.rightBarButtonItems = []
        self.title = "Search"
        self.tabBarController?.navigationItem.title = "Search"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.rightBarButtonItems = []
        self.title = "Search"
        self.tabBarController?.navigationItem.title = "Search"
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
