//
//  MedicationAdditionViewController.swift
//  MariGold
//
//  Created by Devin Sova on 3/4/18.
//  Copyright © 2018 MariGold. All rights reserved.
//

import Foundation
import UIKit

class MedicationAdditionTableViewController: UITableViewController {
	//Fields
	@IBOutlet var name: UITextField!
	@IBOutlet var dosage: UITextField!
	@IBOutlet var brandName: UITextField!
	@IBOutlet var NDCNumber: UITextField!
	
	//Nav Bar
	@IBAction func Cancel(_ sender: Any) {
		self.navigationController?.popViewController(animated: true)
	}
	@IBAction func Done(_ sender: Any) {
		//Display Spinning Swirly Thingy
		
		//Make API Call
		
		//If Successful Pop View Controller
		self.navigationController?.popViewController(animated: true)
		
	}
}
