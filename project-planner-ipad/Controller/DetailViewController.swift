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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
        
        // initializing the custom cell
        let nibName = UINib(nibName: "TaskTableViewCell", bundle: nil)
        taskTable.register(nibName, forCellReuseIdentifier: "TaskCell")
    }
    
    func configureView() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm"
        
        // Update the user interface for the detail item.
        if let project = selectedProject {
            if let nameLabel = projectNameLabel {
                nameLabel.text = project.name ?? "Unavailable"
            }
            if let dueDateLabel = dueDateLabel {
                dueDateLabel.text = "Due Date: \(formatter.string(from: project.dueDate as Date))"
            }
            if let priorityLabel = priorityLabel {
                priorityLabel.text = "Priority: \(project.priority ?? "Unavailable")"
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
    
    // Helper to format date
    func formatDate(_ date: Date) -> String {
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy HH:mm"
        return dateFormatter.string(from: date)
    }
}

