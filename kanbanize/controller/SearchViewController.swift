//
//  SearchViewController.swift
//  kanbanize
//
//  Created by Peter Ho on 5/14/18.
//  Copyright © 2018 Peter Ho. All rights reserved.
//

import UIKit
import CoreData

class SearchViewController: UIViewController {

    // MARK - Variable
    var boardName = ""
    @IBOutlet weak var tableView: UITableView!
    var searchController: UISearchController!
    var tasks: [NSManagedObject] = []
    var filteredTasks: [NSManagedObject] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tabBarController?.navigationItem.rightBarButtonItems = []
        self.title = "Search"
        self.tabBarController?.navigationItem.title = "Search"
        
        tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: "TaskTableViewCell")
        let xib = UINib(nibName: "TaskTableCell", bundle: nil)
        tableView.register(xib, forCellReuseIdentifier: "TaskTableViewCell")
        tableView.rowHeight = 70
        
        tasks = Task.FetchData(sort: false, board: boardName)
        
        searchController = UISearchController(searchResultsController: nil)
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search Tasks"
        searchController.searchBar.sizeToFit()
        searchController.searchBar.scopeButtonTitles = ["Name", "Label"]
        tableView.tableHeaderView = searchController.searchBar
        tableView.contentInset = UIEdgeInsets(top: 70, left: 0, bottom: 0, right: 0)
        definesPresentationContext = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.rightBarButtonItems = []
        self.title = "Search"
        self.tabBarController?.navigationItem.title = "Search"
        
        tasks = Task.FetchData(sort: false, board: boardName)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func ViewDetailAction(index: Int) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let editVC = storyBoard.instantiateViewController(withIdentifier: "TaskDetailViewController") as! TaskDetailViewController
        editVC.taskInfo = filteredTasks[index] as! Task
        editVC.selectedIndex = index
        editVC.modeFlag = false
        editVC.sourceViewController = self
        editVC.sourceStatus = (filteredTasks[index] as! Task).status
        editVC.currentBoard = (filteredTasks[index] as! Task).board
        self.tabBarController?.navigationController?.pushViewController(editVC, animated: true)
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

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath) as! TaskTableViewCell
        let taskInfo = filteredTasks[indexPath.row] as! Task
        
        cell.LoadContent(name: taskInfo.name!, dueDate: taskInfo.dueDate! as Date, status: taskInfo.status!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredTasks.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ViewDetailAction(index: indexPath.row)
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchString = searchController.searchBar.text {
            let buttonIndex = searchController.searchBar.selectedScopeButtonIndex
            filteredTasks.removeAll(keepingCapacity: true)
            
            if buttonIndex == 0 {
                for task in tasks {
                    if (((task as! Task).name?.range(of: searchString, options: .caseInsensitive, range: nil, locale: nil)) != nil) {
                        filteredTasks.append(task)
                    }
                }
            } else {
                for task in tasks {
                    if (((task as! Task).label?.range(of: searchString, options: .caseInsensitive, range: nil, locale: nil)) != nil) {
                        filteredTasks.append(task)
                    }
                }
            }
        }
        tableView.reloadData()
    }
    
    
}
