//
//  AddProjectViewController.swift
//  project-planner-ipad
//
//  Created by Brion Silva on 24/05/2019.
//  Copyright © 2019 Brion Silva. All rights reserved.
//

import Foundation
import UIKit

class AddProjectViewController: UIViewController {
    
    var tableViewController : AddProjectTableViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // .children is a list of container view controller of the parent view controller
        // since you only have one container view,
        // safe to grab the first one ([0]), and cast it to table VC class
        tableViewController = self.children[0] as? AddProjectTableViewController
        tableViewController?.delegate = self
    }
}

extension AddProjectViewController : AddProjectTableViewControllerDelegate {
    // do stuff here
    func logoutTapped() {
        print("logout tapped")
    }
}
