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
    
    let colours: Colours = Colours()
    let formatter: Formatter = Formatter()
    let calculations: Calculations = Calculations()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func commonInit(_ taskName: String, taskProgress: CGFloat, startDate: Date, dueDate: Date, taskNo: Int) {
        let (daysLeft, hoursLeft) = calculations.getDaysAndHoursLeft(end: dueDate)
        let remainingDaysPercentage = calculations.getRemainingDaysPercentage(startDate, end: dueDate)
        
        taskNameLabel.text = taskName
        dueDateLabel.text = "Due: \(formatter.formatDate(dueDate))"
        daysLeftLabel.text = "\(daysLeft) Days and \(hoursLeft) Hours Remaining"
        
        DispatchQueue.main.async {
            let colours = self.colours.getProgressGradient(Int(taskProgress))
            self.taskProgressBar.startGradientColor = colours[0]
            self.taskProgressBar.endGradientColor = colours[1]
            self.taskProgressBar.progress = taskProgress / 100
        }
        
        DispatchQueue.main.async {
            let colours = self.colours.getProgressGradient(remainingDaysPercentage, negative: true)
            self.daysRemainingProgressBar.startGradientColor = colours[0]
            self.daysRemainingProgressBar.endGradientColor = colours[1]
            self.daysRemainingProgressBar.progress = CGFloat(remainingDaysPercentage) / 100
        }
        
        taskNoLabel.text = "Task \(taskNo)"
    }
}
