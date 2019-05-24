//
//  AddProjectTableViewController.swift
//  project-planner-ipad
//
//  Created by Brion Silva on 24/05/2019.
//  Copyright © 2019 Brion Silva. All rights reserved.
//

import Foundation
import UIKit

class AddProjectTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate {
    
    var delegate : AddProjectTableViewControllerDelegate?
    let dateFormatter : DateFormatter = DateFormatter()
    var datePickerVisible = false
    
    @IBOutlet weak var endDate: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set initial end date to one hour ahead of current time
        dateFormatter.dateFormat = "dd MMM yyyy HH:mm"
        var date = Date()
        date.addTimeInterval(TimeInterval(60.00 * 60.00))
        endDate.text = dateFormatter.string(from: date)
    }
    
    @IBAction func handleDateChange(_ sender: UIDatePicker) {
        dateFormatter.dateFormat = "dd MMM yyyy HH:mm"
        endDate.text = dateFormatter.string(from: sender.date)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if(indexPath.row == 1){
//            // tell the delegate (view controller) to perform logoutTapped() function
//            if let delegate = delegate {
//                delegate.logoutTapped()
//            }
//        }
        
        // Section 1 contains end date(inddex: 0) and add to callender(inddex: 1) rows
        if(indexPath.section == 1 && indexPath.row == 0) {
            datePickerVisible = !datePickerVisible
            tableView.reloadData()
        }
        
        // Section 2 contains priority selection(inddex: 0) row
        if(indexPath.section == 2 && indexPath.row == 0) {
            performSegue(withIdentifier: "setPriority", sender: self)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.section == 1 && indexPath.row == 1) {
            if datePickerVisible == false {
                return 0.0
            }
            return 200.0
        }
        return 50.0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "setPriority" {
            let vc = segue.destination
            
            vc.preferredContentSize = CGSize(width: 200, height: 100)
            vc.popoverPresentationController?.delegate = self
            if let anchorView = sender as? UIView {
                vc.popoverPresentationController?.sourceView = anchorView
            } else if let anchorView = sender as? UIBarButtonItem {
                vc.popoverPresentationController?.barButtonItem = anchorView
            }
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
}

protocol AddProjectTableViewControllerDelegate {
    func logoutTapped()
}
