//
//  TaskDetailViewController.swift
//  kanbanize
//
//  Created by Peter Ho on 4/17/18.
//  Copyright © 2018 Peter Ho. All rights reserved.
//

import UIKit

class TaskDetailViewController: UIViewController {

    // MARK - Delegate
    
    
    // MARK - Datasource
    
    
    // MARK - Outlet
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var statusTextField: UITextField!
    @IBOutlet weak var dueDateTextField: UITextField!
    @IBOutlet weak var labelTextField: UITextField!
    @IBOutlet weak var descriptionTextArea: UITextView!
    @IBOutlet weak var statusIndicator: UILabel!
    
    
    // MARK - Action
    
    
    // MARK - Segue
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
