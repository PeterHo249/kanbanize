//
//  TaskTableViewCell.swift
//  kanbanize
//
//  Created by Peter Ho on 4/17/18.
//  Copyright © 2018 Peter Ho. All rights reserved.
//

import UIKit
import ChameleonFramework

class TaskTableViewCell: UITableViewCell {

    @IBOutlet weak var statusIndicator: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    
    func LoadContent(name: String, dueDate: Date, status: String) {
        nameLabel.text = name
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .short
        dueDateLabel.text = dateFormatter.string(from: dueDate)
        switch status {
        case "todo":
            statusIndicator.textColor = FlatBlue()
            break
        case "doing":
            statusIndicator.textColor = FlatYellow()
            break
        case "done":
            statusIndicator.textColor = FlatGreen()
            break
        default:
            statusIndicator.textColor = FlatRed()
        }
        
        accessoryType = .detailDisclosureButton
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
