//
//  ProjectTableViewCell.swift
//  project-planner-ipad
//
//  Created by Brion Silva on 24/05/2019.
//  Copyright © 2019 Brion Silva. All rights reserved.
//

import UIKit

class ProjectTableViewCell: UITableViewCell {

    @IBOutlet weak var projectNameLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var priorityIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func commonInit(_ projectName: String, priority: String, dueDate: Date) {
        var iconName = "ic-flag-green"
        if priority == "Low" {
            iconName = "ic-flag-green"
        } else if priority == "Medium" {
            iconName = "ic-flag-blue"
        } else if priority == "High" {
            iconName = "ic-flag-red"
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm"
        
        priorityIcon.image = UIImage(named: iconName)
        projectNameLabel.text = projectName
        dueDateLabel.text = "Due: \(formatter.string(from: dueDate))"
    }
}
