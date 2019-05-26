//
//  DetailViewController.swift
//  project-planner-ipad
//
//  Created by Brion Silva on 23/05/2019.
//  Copyright © 2019 Brion Silva. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDelegate,UITableViewDataSource, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var taskTable: UITableView!
    @IBOutlet weak var projectNameLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var priorityLabel: UILabel!
    @IBOutlet weak var projectProgressBar: CircularProgressBar!
    @IBOutlet weak var daysRemainingProgressBar: CircularProgressBar!
    
    let formatter: Formatter = Formatter()
    let calculations: Calculations = Calculations()
    let colours: Colours = Colours()
    
    
    let now = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure the view
        configureView()
        
        // initializing the custom cell
        let nibName = UINib(nibName: "TaskTableViewCell", bundle: nil)
        taskTable.register(nibName, forCellReuseIdentifier: "TaskCell")
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        if let project = selectedProject {
            if let nameLabel = projectNameLabel {
                nameLabel.text = project.name
            }
            if let dueDateLabel = dueDateLabel {
                dueDateLabel.text = "Due Date: \(formatter.formatDate(project.dueDate as Date))"
            }
            if let priorityLabel = priorityLabel {
                priorityLabel.text = "Priority: \(project.priority)"
            }
            
            let tasks = (project.tasks!.allObjects as! [Task])
            let projectProgress = calculations.getProjectProgress(tasks)
            let daysLeftProgress = calculations.getRemainingTimePercentage(project.startDate as Date, end: project.dueDate as Date)
            var daysRemaining = self.calculations.getDateDiff(self.now, end: project.dueDate as Date)
            
            if daysRemaining < 0 {
                daysRemaining = 0
            }
            
            DispatchQueue.main.async {
                let colours = self.colours.getProgressGradient(projectProgress)
                self.projectProgressBar.customSubtitle = "Completed"
                self.projectProgressBar.startGradientColor = colours[0]
                self.projectProgressBar.endGradientColor = colours[1]
                self.projectProgressBar.progress = CGFloat(projectProgress) / 100
            }
            
            DispatchQueue.main.async {
                let colours = self.colours.getProgressGradient(daysLeftProgress, negative: true)
                self.daysRemainingProgressBar.customTitle = "\(daysRemaining)"
                self.daysRemainingProgressBar.customSubtitle = "Days Left"
                self.daysRemainingProgressBar.startGradientColor = colours[0]
                self.daysRemainingProgressBar.endGradientColor = colours[1]
                self.daysRemainingProgressBar.progress =  CGFloat(daysLeftProgress) / 100
            }
        }
    }

    var selectedProject: Project? {
        didSet {
            // Update the view.
            configureView()
        }
    }

    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addTask" {
            let controller = (segue.destination as! UINavigationController).topViewController as! AddTaskViewController
            controller.selectedProject = selectedProject
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedProject?.tasks?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskTableViewCell
        let tasks = (selectedProject?.tasks!.allObjects as! [Task])
        configureCell(cell, withTask: tasks[indexPath.row], index: indexPath.row)
        return cell
    }
    
    func configureCell(_ cell: TaskTableViewCell, withTask task: Task, index: Int) {
        print(task)
        cell.commonInit(task.name, taskProgress: CGFloat(task.progress), startDate: task.startDate as Date, dueDate: task.dueDate as Date, taskNo: index + 1)
    }
}

