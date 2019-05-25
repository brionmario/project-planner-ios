//
//  TaskTableViewCell.swift
//  project-planner-ipad
//
//  Created by Brion Silva on 25/05/2019.
//  Copyright © 2019 Brion Silva. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    @IBOutlet weak var daysLeftLabel: UILabel!
    @IBOutlet weak var taskNoLabel: UILabel!
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var taskProgressBar: CircularProgressBar!
    @IBOutlet weak var daysRemainingProgressBar: LinearProgressBar!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func commonInit(_ taskName: String, taskProgress: CGFloat, startDate: Date, dueDate: Date, taskNo: Int) {
        let formatter: Formatter = Formatter()
        let calculations: Calculations = Calculations()
        
        let (daysLeft, hoursLeft) = calculations.getDaysAndHoursLeft(end: dueDate)
        
        taskNameLabel.text = taskName
        dueDateLabel.text = "Due: \(formatter.formatDate(dueDate))"
        daysLeftLabel.text = "\(daysLeft) Days and \(hoursLeft) Hours Remaining"
        DispatchQueue.main.async {
            self.taskProgressBar.progress = taskProgress / 100
        }
        DispatchQueue.main.async {
            self.daysRemainingProgressBar.progress = CGFloat(calculations.getRemainingDaysPercentage(startDate, end: dueDate)) / 100
        }
        taskNoLabel.text = "Task \(taskNo)"
    }
}
