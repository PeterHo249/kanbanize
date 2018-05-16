//
//  SearchViewController.swift
//  kanbanize
//
//  Created by Peter Ho on 5/14/18.
//  Copyright © 2018 Peter Ho. All rights reserved.
//

import UIKit
import CoreData

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK - Variable
    var boardName = ""
    @IBOutlet weak var tableView: UITableView!
    var searchController: UISearchController!
    var tasks: [NSManagedObject] = []
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath) as! TaskTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tabBarController?.navigationItem.rightBarButtonItems = []
        self.title = "Search"
        self.tabBarController?.navigationItem.title = "Search"
        
        tasks = Task.All()
        
        let resultsController = SearchResultController()
        resultsController.tasks = tasks
        searchController = UISearchController(searchResultsController: resultsController)
        
        let searchBar = searchController.searchBar
        searchBar.scopeButtonTitles = ["Name", "Label"]
        searchBar.placeholder = "Enter a search term"
        searchBar.sizeToFit()
        tableView.tableHeaderView = searchBar
        searchController.searchResultsUpdater = resultsController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.rightBarButtonItems = []
        self.title = "Search"
        self.tabBarController?.navigationItem.title = "Search"
        
        tasks = Task.All()
        
        let resultsController = SearchResultController()
        resultsController.tasks = tasks
        searchController = UISearchController(searchResultsController: resultsController)
        
        let searchBar = searchController.searchBar
        searchBar.scopeButtonTitles = ["Name", "Label"]
        searchBar.placeholder = "Enter a search term"
        searchBar.sizeToFit()
        tableView.tableHeaderView = searchBar
        searchController.searchResultsUpdater = resultsController
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
