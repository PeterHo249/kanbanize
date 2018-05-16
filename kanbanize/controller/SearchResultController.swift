//
//  SearchResultController.swift
//  kanbanize
//
//  Created by Peter Ho on 5/16/18.
//  Copyright © 2018 Peter Ho. All rights reserved.
//

import UIKit
import CoreData

class SearchResultController: UITableViewController, UISearchResultsUpdating {

    private static let nameButtonIndex = 0
    private static let labelButtonIndex = 1
    var filteredTasks: [NSManagedObject] = []
    var tasks: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TaskTableViewCell")
        let xib = UINib(nibName: "TaskTableCell", bundle: nil)
        tableView.register(xib, forCellReuseIdentifier: "TaskTableViewCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredTasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath) as! TaskTableViewCell
        let taskInfo = filteredTasks[indexPath.row] as! Task
        
        cell.LoadContent(name: taskInfo.name!, dueDate: taskInfo.dueDate! as Date, status: taskInfo.status!)
        
        return cell
    }
    
    // MARK - UISearchResultUpdating Conformance
    func updateSearchResults(for searchController: UISearchController) {
        if let searchString = searchController.searchBar.text {
            let buttonIndex = searchController.searchBar.selectedScopeButtonIndex
            filteredTasks.removeAll(keepingCapacity: true)
            
            if buttonIndex == SearchResultController.nameButtonIndex {
                for task in tasks {
                    if (((task as! Task).name?.range(of: searchString, options: .caseInsensitive, range: nil, locale: nil)) != nil) {
                        filteredTasks.append(task)
                    }
                }
            } else {
                for task in tasks {
                    if (((task as! Task).name?.range(of: searchString, options: .caseInsensitive, range: nil, locale: nil)) != nil) {
                        filteredTasks.append(task)
                    }
                }
            }
        }
        tableView.reloadData()
    }
   

}
