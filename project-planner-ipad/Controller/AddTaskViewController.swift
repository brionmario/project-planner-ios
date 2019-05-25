//
//  AddTaskViewController.swift
//  project-planner-ipad
//
//  Created by Brion Silva on 25/05/2019.
//  Copyright © 2019 Brion Silva. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class AddTaskViewController: UITableViewController, UIPopoverPresentationControllerDelegate, UITextViewDelegate {
    
    var tasks: [NSManagedObject] = []
    var startDate : Date!
    var dueDate : Date!
    let dateFormatter : DateFormatter = DateFormatter()
    var startDatePickerVisible = false
    var dueDatePickerVisible = false
    var taskProgressPickerVisible = false
    var selectedProject: Project?
    
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var taskNameTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var addTaskButton: UIBarButtonItem!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var progressSlider: UISlider!
    @IBOutlet weak var progressSliderLabel: UILabel!
    @IBOutlet var addNotificationSwitch: UISwitch!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var now = Date()
        
        // Disable past dates on datepickers
        startDatePicker.minimumDate = now
        endDatePicker.minimumDate = now
        
        dateFormatter.dateFormat = "dd MMM yyyy HH:mm"
        
        // Set start date to current
        startDate = now // Set the raw end date field variable
        startDateLabel.text = dateFormatter.string(from: now)
        
        // Set end date to one hour ahead of current time
        now.addTimeInterval(TimeInterval(60.00 * 60.00))
        dueDate = now // Set the raw end date field variable
        dueDateLabel.text = dateFormatter.string(from: now)
        
        // Settings the placeholder for notes UITextView
        notesTextView.delegate = self
        notesTextView.text = "Notes"
        notesTextView.textColor = UIColor.lightGray
        
        // Setting the initial task progress
        progressSlider.value = 0
        progressLabel.text = "0%"
        progressSliderLabel.text = "0% Completed"
        
        // Disable add button
        toggleAddButtonEnability()
    }
    
    @IBAction func handleStartDateChange(_ sender: UIDatePicker) {
        startDate = sender.date // Set the raw end date field variable
        dateFormatter.dateFormat = "dd MMM yyyy HH:mm"
        startDateLabel.text = dateFormatter.string(from: sender.date)
    }
    
    @IBAction func handleEndDateChange(_ sender: UIDatePicker) {
        dueDate = sender.date // Set the raw end date field variable
        dateFormatter.dateFormat = "dd MMM yyyy HH:mm"
        dueDateLabel.text = dateFormatter.string(from: sender.date)
    }
    
    @IBAction func handleCancelButtonClick(_ sender: UIBarButtonItem) {
        dismissAddTaskPopOver()
    }
    
    @IBAction func handleAddButtonClick(_ sender: UIBarButtonItem) {
        if validate() {
            guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
                    return
            }
            
            let managedContext = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "Task", in: managedContext)!
            let task = NSManagedObject(entity: entity, insertInto: managedContext)
            
            task.setValue(taskNameTextField.text, forKeyPath: "name")
            task.setValue(notesTextView.text, forKeyPath: "notes")
            task.setValue(startDate, forKeyPath: "startDate")
            task.setValue(dueDate, forKeyPath: "dueDate")
            task.setValue(Bool(addNotificationSwitch.isOn), forKeyPath: "addNotification")
            task.setValue(Float(progressSlider.value * 100), forKey: "progress")
            
            selectedProject?.addToTasks((task as? Task)!)
            
            do {
                try managedContext.save()
                tasks.append(task)
            } catch _ as NSError {
                let alert = UIAlertController(title: "Error", message: "An error occured while saving the task.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            let alert = UIAlertController(title: "Error", message: "Please fill the required fields.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        // Dismiss PopOver
        dismissAddTaskPopOver()
    }
    
    @IBAction func handleTaskNameChange(_ sender: Any) {
        toggleAddButtonEnability()
    }
    
    @IBAction func handleProgressChange(_ sender: UISlider) {
        let progress = Int(sender.value * 100)
        progressLabel.text = "\(progress)%"
        progressSliderLabel.text = "\(progress)% Completed"
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
        toggleAddButtonEnability()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        toggleAddButtonEnability()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Notes"
            textView.textColor = UIColor.lightGray
        }
        toggleAddButtonEnability()
    }
    
    // Handles the add button enable state
    func toggleAddButtonEnability() {
        if validate() {
            addTaskButton.isEnabled = true;
        } else {
            addTaskButton.isEnabled = false;
        }
    }
    
    // Dismiss Popover
    func dismissAddTaskPopOver() {
        dismiss(animated: true, completion: nil)
        popoverPresentationController?.delegate?.popoverPresentationControllerDidDismissPopover?(popoverPresentationController!)
    }
    
    // Check if the required fields are empty or not
    func validate() -> Bool {
        if !(taskNameTextField.text?.isEmpty)! && !(notesTextView.text == "Notes") && !(notesTextView.text?.isEmpty)! {
            return true
        }
        return false
    }
}

// MARK: - UITableViewDelegate
extension AddTaskViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            taskNameTextField.becomeFirstResponder()
        }
        
        if indexPath.section == 0 && indexPath.row == 1 {
            notesTextView.becomeFirstResponder()
        }
        
        // Section 1 contains start date(index: 0), end date(index: 1) and add to callender(inddex: 1) rows
        if(indexPath.section == 1 && indexPath.row == 0) {
            startDatePickerVisible = !startDatePickerVisible
            tableView.reloadData()
        }
        if(indexPath.section == 1 && indexPath.row == 2) {
            dueDatePickerVisible = !dueDatePickerVisible
            tableView.reloadData()
        }
        
        // Section 2 contains task progress
        if(indexPath.section == 2 && indexPath.row == 0) {
            taskProgressPickerVisible = !taskProgressPickerVisible
            tableView.reloadData()
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 && indexPath.row == 1 {
            if startDatePickerVisible == false {
                return 0.0
            }
            return 200.0
        }
        if indexPath.section == 1 && indexPath.row == 3 {
            if dueDatePickerVisible == false {
                return 0.0
            }
            return 200.0
        }
        if indexPath.section == 2 && indexPath.row == 1 {
            if taskProgressPickerVisible == false {
                return 0.0
            }
            return 100.0
        }
        
        // Make Notes text view bigger: 80
        if indexPath.section == 0 && indexPath.row == 1 {
            return 80.0
        }
        
        return 50.0
    }
}
