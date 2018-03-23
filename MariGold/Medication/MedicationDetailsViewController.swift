//
//  MedicationDetailsViewController.swift
//  MariGold
//
//  Created by Devin Sova on 3/22/18.
//  Copyright © 2018 MariGold. All rights reserved.
//

import UIKit

class MedicationDetailsViewController: UITableViewController{
	@IBOutlet var Name: UILabel!
	@IBOutlet var Dosage: UILabel!
	@IBOutlet var Quantity: UILabel!
	@IBOutlet var RunOutDate: UILabel!
	@IBOutlet var Temporary: UILabel!
	
	var medication: Medication!
	var isEditingMedication = false
	
	//Hidden Nav Edit Buttons
	var DoneButton: UIBarButtonItem!
	var CancelButton: UIBarButtonItem!
	var EditButton: UIBarButtonItem!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.navigationItem.title = medication.name
		Name.text = medication.name ?? "Undefined"
		//Dosage.text = medication.
		Quantity.text = String(medication.quantity)
		RunOutDate.text = medication.run_out_date ?? "Undefined"
		Temporary.text = String(medication.temporary)
		
		DoneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(setEditingMedication))
		CancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(setEditingMedication))
		EditButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(setEditingMedication))
		
		self.navigationItem.setRightBarButton(EditButton, animated: false)
		
		self.tableView.reloadData()
	}
	
	@objc func setEditingMedication() {
		//Check for Done Button Pressed
		if self.navigationItem.rightBarButtonItem == DoneButton {
			//Make API call
			NSLog("Done Pressed!")
		}
		
		if(!isEditingMedication) {
			self.navigationItem.setHidesBackButton(true, animated: true)
			self.navigationItem.setLeftBarButton(CancelButton, animated: true)
			self.navigationItem.setRightBarButton(DoneButton, animated: true)
		}
		else {
			self.navigationItem.setRightBarButton(EditButton, animated: true)
			self.navigationItem.setLeftBarButton(nil, animated: true)
			self.navigationItem.setHidesBackButton(false, animated: true)
		}
		isEditingMedication = !isEditingMedication
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
}
