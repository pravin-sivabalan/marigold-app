//
//  DashboardViewController.swift
//  MariGold
//
//  Created by Pravin Sivabalan on 3/24/18.
//  Copyright © 2018 MariGold. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {
    @IBOutlet weak var incrementButton: UIButton!
    @IBOutlet weak var decrementButton: UIButton!
    @IBOutlet weak var currentDateLabel: UILabel!
    let today = Date()
    let dateFormatter = DateFormatter()
    var currentDate = Date()
    var daysAdded = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        decrementButton.isEnabled = false
        
        currentDateLabel.text = dateFormatter.string(from: today)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func incrementDateAction(_ sender: UIButton) {
        if(daysAdded < 6) {
            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
            
            currentDateLabel.text = dateFormatter.string(from: currentDate)
            
            daysAdded += 1
        }
        if(daysAdded > 0) {
            decrementButton.isEnabled = true
        }
        if(daysAdded >= 6) {
            incrementButton.isEnabled = false
        }
    }
    
    @IBAction func decrementDateAction(_ sender: UIButton) {
        if(daysAdded > 0) {
            currentDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate)!
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            
            currentDateLabel.text = dateFormatter.string(from: currentDate)
            
            daysAdded -= 1
        }
        if(daysAdded < 6) {
            incrementButton.isEnabled = true
        }
        if(daysAdded == 0) {
            decrementButton.isEnabled = false
        }
    }
}
