//
//  MedicationDetailsViewController.swift
//  MariGold
//
//  Created by Devin Sova on 3/22/18.
//  Copyright © 2018 MariGold. All rights reserved.
//

import UIKit

class MedicationDetailsViewController: UITableViewController{
	@IBOutlet var Name: UITextField!
	@IBOutlet var Dosage: UITextField!
	@IBOutlet var Quantity: UITextField!
	@IBOutlet var RunOutDate: UITextField!
	@IBOutlet var Temporary: UILabel!
	@IBOutlet var TemporarySwitch: UISwitch!
	
	var medication: Medication!
	var isEditingMedication = false
	
	//Hidden Nav Edit Buttons
	var DoneButton: UIBarButtonItem!
	var CancelButton: UIBarButtonItem!
	var EditButton: UIBarButtonItem!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		populateFieldsWithOGMedication()
		self.navigationItem.title = medication.name
		
		DoneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(setEditingMedication(sender:)))
		CancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(setEditingMedication(sender:)))
		EditButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(setEditingMedication(sender:)))
		
		self.navigationItem.setRightBarButton(EditButton, animated: false)
		self.tableView.reloadData()
	}
	@IBAction func temporaryOnOffSwitch() {
		Temporary.text = String(TemporarySwitch.isOn)
	}
	
	func populateFieldsWithOGMedication() {
		Name.text = medication.name ?? "Undefined"
		//Dosage.text = medication.
		Quantity.text = String(medication.quantity)
		RunOutDate.text = medication.run_out_date ?? "Undefined"
		Temporary.text = String(medication.temporary)
		TemporarySwitch.isOn = medication.temporary
	}
	
	@objc func setEditingMedication(sender: UIBarButtonItem) {
		//Check for Done Button Pressed
		if sender == DoneButton {
			//Make API call and update fields
			NSLog("Done Pressed!")
		}
		
		if sender == CancelButton {
			//Fix all fields
			populateFieldsWithOGMedication()
		}
		
		if(!isEditingMedication) {
			self.navigationItem.setHidesBackButton(true, animated: true)
			self.navigationItem.setLeftBarButton(CancelButton, animated: true)
			self.navigationItem.setRightBarButton(DoneButton, animated: true)
			
			Name.isEnabled = true
			Name.textAlignment = .left
			Dosage.isEnabled = true
			Dosage.textAlignment = .left
			Quantity.isEnabled = true
			Quantity.textAlignment = .left
			TemporarySwitch.isHidden = false
			Temporary.textAlignment = .left
		}
		else {
			self.navigationItem.setRightBarButton(EditButton, animated: true)
			self.navigationItem.setLeftBarButton(nil, animated: true)
			self.navigationItem.setHidesBackButton(false, animated: true)
			
			Name.isEnabled = false
			Name.textAlignment = .right
			Dosage.isEnabled = false
			Dosage.textAlignment = .right
			Quantity.isEnabled = false
			Quantity.textAlignment = .right
			TemporarySwitch.isHidden = true
			Temporary.textAlignment = .right
		}
		isEditingMedication = !isEditingMedication
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
}
