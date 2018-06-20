//
//  StatisticsViewController.swift
//  kanbanize
//
//  Created by Peter Ho on 4/17/18.
//  Copyright © 2018 Peter Ho. All rights reserved.
//

import UIKit
import CoreData
import Charts
import ChameleonFramework

class StatisticsViewController: UIViewController {
 
    // MARK - Delegate
    
    // MARK - Varible
    var boardName = ""
    var currentController: UIViewController?
    // MARK - Datasource
    
    
    // MARK - Outlet
    @IBOutlet weak var pieChart: PieChartView!
    
    
    // MARK - Action
    func pieChartUpdate() {
        var tasks = Task.FetchData(sort: false, board: boardName, status: "todo")
        let todoEntry = PieChartDataEntry(value: Double(tasks.count), label: "Todo")
        var entrys:[PieChartDataEntry] = []
        var colors:[UIColor] = []
        if (tasks.count != 0) {
            entrys.append(todoEntry)
            colors.append(FlatBlue())
        }
        
        tasks = Task.FetchData(sort: false, board: boardName, status: "doing")
        let doingEntry = PieChartDataEntry(value: Double(tasks.count), label: "Doing")
        if (tasks.count != 0) {
            entrys.append(doingEntry)
            colors.append(FlatYellow())
        }
        
        tasks = Task.FetchData(sort: false, board: boardName, status: "done")
        let doneEntry = PieChartDataEntry(value: Double(tasks.count), label: "Done")
        if (tasks.count != 0) {
            entrys.append(doneEntry)
            colors.append(FlatGreen())
        }
        
        tasks = Task.FetchData(sort: false, board: boardName, status: "overdue")
        let overdueEntry = PieChartDataEntry(value: Double(tasks.count), label: "Overdue")
        if (tasks.count != 0) {
            entrys.append(overdueEntry)
            colors.append(FlatRed())
        }
        
        let dataSet = PieChartDataSet(values: entrys, label: "Status")
        let data = PieChartData(dataSet: dataSet)
        pieChart.data = data
        pieChart.chartDescription?.text = "Process Statictics"
        
        dataSet.colors = colors
        pieChart.legend.enabled = false
        pieChart.animate(xAxisDuration: 1.5, easingOption: .easeInOutQuint)
        
        pieChart.notifyDataSetChanged()
    }
    
    // MARK - Segue
    
    override func viewDidLoad() {
        super.viewDidLoad()


        // Do any additional setup after loading the view.
        self.tabBarController?.navigationItem.rightBarButtonItems = []
        
        pieChartUpdate()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Statistics"
        self.tabBarController?.navigationItem.title = "Statistics"
        
        self.tabBarController?.navigationItem.rightBarButtonItems = []
        
        pieChartUpdate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
