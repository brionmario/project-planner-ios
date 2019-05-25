//
//  DetailViewController.swift
//  project-planner-ipad
//
//  Created by Brion Silva on 23/05/2019.
//  Copyright © 2019 Brion Silva. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    

    @IBOutlet weak var projectNameLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var priorityLabel: UILabel!
    
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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
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
}

extension DetailViewController: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (selectedProject?.tasks!.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell")!
        let tasks = (selectedProject?.tasks!.allObjects as! [Task])
        cell.textLabel?.text = tasks[indexPath.row].name
        return cell
    }
}
