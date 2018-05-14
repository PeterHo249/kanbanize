//
//  TaskDetailViewController.swift
//  kanbanize
//
//  Created by Peter Ho on 4/17/18.
//  Copyright © 2018 Peter Ho. All rights reserved.
//

import UIKit
import Foundation

class TaskDetailViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    // MARK - Delegate
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        statusTextField.text = statusRef[row]
        ColorIndicator(status: statusRef[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return statusRef[row]
    }
    
    // MARK - Datasource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return statusRef.count
    }
    
    
    // MARK - Outlet
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var statusTextField: UITextField!
    @IBOutlet weak var dueDateTextField: UITextField!
    @IBOutlet weak var labelTextField: UITextField!
    @IBOutlet weak var descriptionTextArea: UITextField!
    @IBOutlet weak var statusIndicator: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    let statusRef = ["todo", "doing", "done", "overdue"]
    
    var dueDatePicker:UIDatePicker!
    var statusPicker:UIPickerView!
    var dueDatePickerInputView:UIView!
    var statusPickerInputView:UIView!
    
    // If this flag is true, it is Add new task, else it is Edit task
    var modeFlag = true
    var sourceViewController:UIViewController!
    let defaultDate = Date()
    var taskInfo:Task!
    var selectedIndex = 0
    var sourceStatus:String!
    var currentBoard:String!
    
    
    // MARK - Action
    // *************** Scroll view handle ************************
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func keyboardWillShow(notification:Notification) {
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height + 50
        scrollView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification:Notification) {
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = 0
        scrollView.contentInset = contentInset
    }
    // *************** End scroll view handle ************************
    @IBAction func onTapGestureRegconized(_ sender: UITapGestureRecognizer) {
        nameTextField.resignFirstResponder()
        statusTextField.resignFirstResponder()
        dueDateTextField.resignFirstResponder()
        labelTextField.resignFirstResponder()
        descriptionTextArea.resignFirstResponder()
    }
    
    @objc func SaveButtonPushed(sender: UIBarButtonItem) {
        if (nameTextField.text == "") {
            let errorAlert = UIAlertController(title: "Opps!", message: "Please enter a name for your task!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            errorAlert.addAction(okAction)
            present(errorAlert, animated: true, completion: nil)
        } else {
            if modeFlag {
                // Add new
                taskInfo = Task.Create() as! Task
                taskInfo.name = nameTextField.text!
                taskInfo.board = currentBoard
                taskInfo.status = statusTextField.text!
                taskInfo.label = labelTextField.text!
                taskInfo.detail = descriptionTextArea.text
                let dateFormatter = DateFormatter()
                dateFormatter.locale = .current
                dateFormatter.timeStyle = .short
                dateFormatter.dateStyle = .short
                taskInfo.dueDate = dateFormatter.date(from: dueDateTextField.text!)! as NSDate
                taskInfo.order = 0
            } else {
                // Edit the exist
                taskInfo.setValue(nameTextField.text!, forKey: "name")
                if sourceStatus != statusTextField.text! {
                    taskInfo.setValue(statusTextField.text!, forKey: "status")
                    taskInfo.setValue(0, forKey: "order")
                }
                taskInfo.setValue(labelTextField.text!, forKey: "label")
                taskInfo.setValue(descriptionTextArea.text!, forKey: "detail")
                let dateFormatter = DateFormatter()
                dateFormatter.locale = .current
                dateFormatter.timeStyle = .short
                dateFormatter.dateStyle = .short
                taskInfo.setValue(dateFormatter.date(from: dueDateTextField.text!)! as NSDate, forKey: "dueDate")
            }
            
            if ((taskInfo.dueDate! as Date) < defaultDate && taskInfo.status != "done") {
                taskInfo.setValue("overdue", forKey: "status")
            }
            
            DB.Save()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func DueDatePickerValueChanged(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .short
        dueDateTextField.text = dateFormatter.string(from: dueDatePicker.date)
    }
    
    @IBAction func onTextFieldDoneEdit(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    // MARK - Helper
    func ColorIndicator(status:String) {
        switch status {
        case "todo":
            statusIndicator.textColor = UIColor.blue
            break
        case "doing":
            statusIndicator.textColor = UIColor.yellow
            break
        case "done":
            statusIndicator.textColor = UIColor.green
            break
        default:
            statusIndicator.textColor = UIColor.red
        }
    }
    
    // MARK - Segue
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view
        
        if modeFlag {
            self.title = "Add New Task"
            let dateFormatter = DateFormatter()
            dateFormatter.locale = .current
            dateFormatter.timeStyle = .short
            dateFormatter.dateStyle = .short
            dueDateTextField.text = dateFormatter.string(from: defaultDate)
            statusTextField.text = sourceStatus
            ColorIndicator(status: sourceStatus)
        } else {
            self.title = "Edit Task"
            nameTextField.text = taskInfo.name
            statusTextField.text = taskInfo.status
            labelTextField.text = taskInfo.label
            descriptionTextArea.text = taskInfo.detail
            let dateFormatter = DateFormatter()
            dateFormatter.locale = .current
            dateFormatter.timeStyle = .short
            dateFormatter.dateStyle = .short
            dueDateTextField.text = dateFormatter.string(from: taskInfo.dueDate! as Date)
            ColorIndicator(status: taskInfo.status!)
        }
        
        // Adjust scroll view when keyboard show
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow), name: Notification.Name.UIKeyboardWillShow, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide), name: Notification.Name.UIKeyboardWillHide, object: nil)
        
        // Add save button
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(self.SaveButtonPushed))
        
        // Create due date picker
        dueDatePickerInputView = UIView(frame: CGRect(x: 0, y: 100, width: 320, height: 160))
        dueDatePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: 320, height: 160))
        dueDatePicker.datePickerMode = .dateAndTime
        dueDatePickerInputView.addSubview(dueDatePicker)
        dueDateTextField.inputView = dueDatePickerInputView
        dueDatePicker.addTarget(self, action: #selector(self.DueDatePickerValueChanged), for: .valueChanged)
        
        // Create status picker
        statusPickerInputView = UIView(frame: CGRect(x: 0, y: 100, width: 320, height: 130))
        statusPicker = UIPickerView(frame: CGRect(x: 0, y: 0, width: 320, height: 130))
        statusPicker.delegate = self
        statusPicker.dataSource = self
        statusPickerInputView.addSubview(statusPicker)
        statusTextField.inputView = statusPickerInputView
        
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
