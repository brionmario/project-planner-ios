//
//  Formatters.swift
//  project-planner-ipad
//
//  Created by Brion Silva on 26/05/2019.
//  Copyright © 2019 Brion Silva. All rights reserved.
//

import Foundation

class Formatter {
    // Helper to format date
    func formatDate(_ date: Date) -> String {
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy HH:mm"
        return dateFormatter.string(from: date)
    }
}
