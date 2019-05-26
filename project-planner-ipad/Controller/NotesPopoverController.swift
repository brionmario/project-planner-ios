//
//  NotesPopoverController.swift
//  project-planner-ipad
//
//  Created by Brion Silva on 26/05/2019.
//  Copyright © 2019 Brion Silva. All rights reserved.
//

import Foundation
import UIKit

class NotesPopoverController: UIViewController {
    
    @IBOutlet weak var notesTextView: UITextView!
    
    var notes: String? {
        didSet {
            configureView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    func configureView() {
        if let notes = notes {
            if let notesTextView = notesTextView {
                notesTextView.text = notes
            }
        }
    }
}
