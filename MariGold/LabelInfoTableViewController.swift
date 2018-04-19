//
//  LabelInfoTableViewController.swift
//  MariGold
//
//  Created by Pravin Sivabalan on 4/19/18.
//  Copyright © 2018 MariGold. All rights reserved.
//

import UIKit

class LabelInfoTableViewController: UITableViewController {
    var medication: Medication!

    @IBOutlet weak var questionText: UITextView!
    @IBOutlet weak var usageText: UITextView!
    @IBOutlet weak var inactiveText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionText.text = "Questions:\n" + (medication.questions ?? "None")
        usageText.text = "Usage:\n" + (medication.indications_and_usage ?? "None")
        inactiveText.text = "Inactive Ingredients:\n" + (medication.inactive_ingredient ?? "None")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
