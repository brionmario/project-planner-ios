//
//  DetailViewController.swift
//  project-planner-ipad
//
//  Created by Brion Silva on 23/05/2019.
//  Copyright © 2019 Brion Silva. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController, NSFetchedResultsControllerDelegate, UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var taskTable: UITableView!
    @IBOutlet weak var projectNameLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var priorityLabel: UILabel!
    @IBOutlet weak var projectProgressBar: CircularProgressBar!
    @IBOutlet weak var daysRemainingProgressBar: CircularProgressBar!
    
    let formatter: Formatter = Formatter()
    let calculations: Calculations = Calculations()
    let colours: Colours = Colours()
    
    var detailViewController: DetailViewController? = nil
    var managedObjectContext: NSManagedObjectContext? = nil
    
    let now = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure the view
        configureView()
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        self.managedObjectContext = appDelegate.persistentContainer.viewContext
        
        // initializing the custom cell
        let nibName = UINib(nibName: "TaskTableViewCell", bundle: nil)
        taskTable.register(nibName, forCellReuseIdentifier: "TaskCell")
    }
    
    @objc
    func insertNewObject(_ sender: Any) {
        let context = self.fetchedResultsController.managedObjectContext
        let newTask = Task(context: context)
        
        // If appropriate, configure the new managed object.
        // newTask.timestamp = Date()
        
        // Save the context.
        do {
            try context.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
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
                self.projectProgressBar?.customSubtitle = "Completed"
                self.projectProgressBar?.startGradientColor = colours[0]
                self.projectProgressBar?.endGradientColor = colours[1]
                self.projectProgressBar?.progress = CGFloat(projectProgress) / 100
            }
            
            DispatchQueue.main.async {
                let colours = self.colours.getProgressGradient(daysLeftProgress, negative: true)
                self.daysRemainingProgressBar?.customTitle = "\(daysRemaining)"
                self.daysRemainingProgressBar?.customSubtitle = "Days Left"
                self.daysRemainingProgressBar?.startGradientColor = colours[0]
                self.daysRemainingProgressBar?.endGradientColor = colours[1]
                self.daysRemainingProgressBar?.progress =  CGFloat(daysLeftProgress) / 100
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
            if let controller = segue.destination as? UIViewController {
                controller.popoverPresentationController!.delegate = self
                controller.preferredContentSize = CGSize(width: 320, height: 450)
            }
        }
    }
    
    // MARK: - Table View
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskTableViewCell
        let task = fetchedResultsController.object(at: indexPath)
        configureCell(cell, withTask: task, index: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let context = fetchedResultsController.managedObjectContext
            context.delete(fetchedResultsController.object(at: indexPath))
            
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func configureCell(_ cell: TaskTableViewCell, withTask task: Task, index: Int) {
        //print("Related Project", task.project)
        cell.commonInit(task.name, taskProgress: CGFloat(task.progress), startDate: task.startDate as Date, dueDate: task.dueDate as Date, taskNo: index + 1)
    }
    
    // MARK: - Fetched results controller
    
    var fetchedResultsController: NSFetchedResultsController<Task> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        if selectedProject != nil {
            // Setting a predicate
            let predicate = NSPredicate(format: "%K == %@", "project", selectedProject as! Project)
            print("Selected Project", selectedProject?.name)
            fetchRequest.predicate = predicate
        }

        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "startDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]

        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: "\(selectedProject)-project")
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return _fetchedResultsController!
    }
    
    var _fetchedResultsController: NSFetchedResultsController<Task>? = nil
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        taskTable.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            taskTable.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            taskTable.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        default:
            return
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            taskTable.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            taskTable.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            configureCell(taskTable.cellForRow(at: indexPath!)! as! TaskTableViewCell, withTask: anObject as! Task, index: indexPath!.row)
        case .move:
            configureCell(taskTable.cellForRow(at: indexPath!)! as! TaskTableViewCell, withTask: anObject as! Task, index: indexPath!.row)
            taskTable.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        taskTable.endUpdates()
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController<NSFetchRequestResult>) {
        // In the simplest, most efficient, case, reload the table view.
        taskTable.reloadData()
    }
}

