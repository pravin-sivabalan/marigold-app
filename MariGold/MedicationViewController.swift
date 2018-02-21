//
//  MedicationViewController.swift
//  MariGold
//
//  Created by Devin Sova on 2/21/18.
//  Copyright © 2018 MariGold. All rights reserved.
//

import UIKit

class MedicationViewController: UIViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	//Medication Add Navigation Menu Item
	@IBAction func medicationAdd(_ sender: Any) {
		let alert = UIAlertController(title: "Add Medication", message: "Enter the name of the Medication:", preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: NSLocalizedString("Add", comment: "Default action"), style: .default, handler: { _ in
			NSLog("The \"Add\" action occured.")
		}))
		alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel Action"), style: .cancel, handler: { _ in
			NSLog("The \"Cancel\" action occured.")
		}))
		alert.addTextField { (inputTextField) in
			inputTextField.placeholder = "Medication Name";
		}
		self.present(alert, animated: true, completion: nil)
	}
}

