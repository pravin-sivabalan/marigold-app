//
//  MedicationAdditionViewController.swift
//  MariGold
//
//  Created by Devin Sova on 3/4/18.
//  Copyright © 2018 MariGold. All rights reserved.
//

import Foundation
import UIKit

class MedicationAdditionViewController: UIViewController {
	
}

class MedicationAdditionTableViewController: UITableViewController {
	//Fields
	@IBOutlet var name: UITextField!
	@IBOutlet var dosage: UITextField!
	@IBOutlet var brandName: UITextField!
	@IBOutlet var NDCNumber: UITextField!
	
	//Nav Bar
	@IBOutlet var cancel: UIBarButtonItem!
	@IBOutlet var done: UIBarButtonItem!
}
