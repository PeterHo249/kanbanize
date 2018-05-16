//
//  TodayViewController.swift
//  upcomingWidget
//
//  Created by Peter Ho on 5/16/18.
//  Copyright © 2018 Peter Ho. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet weak var statusIndicator: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var boardLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        extensionContext?.widgetLargestAvailableDisplayMode = .compact
        let task = Task.FetchUpcomingTask()
        if (task != nil) {
            DisplayInfo(task: task as! Task)
        } else {
            nameLabel.text = ""
            dueDateLabel.text = ""
            boardLabel.text = ""
        }
    }
    
    func DisplayInfo(task: Task) {
        nameLabel.text = task.name
        boardLabel.text = "Board: \(task.board ?? "")"
        let dateFormatter =  DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        dueDateLabel.text = "Due at: \(dateFormatter.string(from: task.dueDate! as Date))"
        switch task.status {
        case "todo":
            statusIndicator.textColor = .blue
            break
        case "doing":
            statusIndicator.textColor = .yellow
            break
        default:
            statusIndicator.textColor = .black
            break
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let task = Task.FetchUpcomingTask()
        if (task != nil) {
            DisplayInfo(task: task as! Task)
        } else {
            nameLabel.text = ""
            dueDateLabel.text = ""
            boardLabel.text = ""
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}
