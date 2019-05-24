//
//  AddProjectTableViewController.swift
//  project-planner-ipad
//
//  Created by Brion Silva on 24/05/2019.
//  Copyright © 2019 Brion Silva. All rights reserved.
//

import Foundation
import UIKit

class AddProjectTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate, UITextViewDelegate {
    
    let dateFormatter : DateFormatter = DateFormatter()
    var datePickerVisible = false
    
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var projectNameTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var priorityLabel: UILabel!
    
    var priority: String = "Low" {
        didSet {
            priorityLabel.text = priority
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set initial end date to one hour ahead of current time
        dateFormatter.dateFormat = "dd MMM yyyy HH:mm"
        var date = Date()
        date.addTimeInterval(TimeInterval(60.00 * 60.00))
        endDateLabel.text = dateFormatter.string(from: date)
        
        // Settings the placeholder for notes UITextView
        notesTextView
            .delegate = self
        notesTextView.text = "Notes"
        notesTextView.textColor = UIColor.lightGray
    }
    
    @IBAction func handleDateChange(_ sender: UIDatePicker) {
        dateFormatter.dateFormat = "dd MMM yyyy HH:mm"
        endDateLabel.text = dateFormatter.string(from: sender.date)
    }
    
    @IBAction func handleCancelClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        popoverPresentationController?.delegate?.popoverPresentationControllerDidDismissPopover?(popoverPresentationController!)
    }
    
    @IBAction func handleSaveClick(_ sender: Any) {
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Notes"
            textView.textColor = UIColor.lightGray
        }
    }
    
    // Setting the selected priority back on the selection view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "setPriority",
            let prioritySelectionViewController = segue.destination as? PrioritySelectionTableViewController {
            prioritySelectionViewController.selectedPriority = priority
        }
    }
}

// MARK: - UITableViewDelegate
extension AddProjectTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            projectNameTextField.becomeFirstResponder()
        }
        
        if indexPath.section == 0 && indexPath.row == 1 {
            notesTextView.becomeFirstResponder()
        }
        
        // Section 1 contains end date(inddex: 0) and add to callender(inddex: 1) rows
        if(indexPath.section == 1 && indexPath.row == 0) {
            datePickerVisible = !datePickerVisible
            tableView.reloadData()
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 && indexPath.row == 1 {
            if datePickerVisible == false {
                return 0.0
            }
            return 200.0
        }
        // Make Notes text view bigger: 80
        if indexPath.section == 0 && indexPath.row == 1 {
            return 80.0
        }
        
        return 50.0
    }
}

// MARK: - IBActions
extension AddProjectTableViewController {
    
    @IBAction func unwindWithSelectedGame(segue: UIStoryboardSegue) {
        if let prioritySelectionViewController = segue.source as? PrioritySelectionTableViewController,
            let selectedPriority = prioritySelectionViewController.selectedPriority {
            priority = selectedPriority
        }
    }
}
