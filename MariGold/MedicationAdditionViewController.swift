//
//  MedicationAdditionViewController.swift
//  MariGold
//
//  Created by Devin Sova on 3/4/18.
//  Copyright © 2018 MariGold. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class MedicationAdditionTableViewController: UITableViewController {
	
	//Outlets
	@IBOutlet var Quantity: UITextField!
	@IBOutlet var Done: UIBarButtonItem!
	@IBOutlet var Temporary: UISwitch!
    @IBOutlet weak var PhoneNotif: UISwitch!
    @IBOutlet weak var EmailNotif: UISwitch!
    
    var Name: String!
    var Cui: String!
    
    override func viewDidLoad() {
        print(Name)
        print(Cui)
    }
    
	//Check if Required Fields are filled out so Done can be pressed
	@IBAction func RequiredFieldsChanged(_ sender: Any) {
		if(Quantity.text != "") {
			Done.isEnabled = true
		}
		else {
			Done.isEnabled = false
		}
	}
	
	//Nav Bar
	@IBAction func Cancel(_ sender: Any) {
		self.navigationController?.popViewController(animated: true)
	}
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let body: [String: Any] = [
            "name" : Name,
            "cui" : Cui,
            "quantity" : Quantity.text!,
            "temporary" : Temporary.isOn,
            "phoneNotification": PhoneNotif.isOn,
            "emailNotification": EmailNotif.isOn
        ]
        
        // Create a new variable to store the instance of PlayerTableViewController
        let destinationVC = segue.destination as! AddNotificationTableViewController
        destinationVC.med = body
    }
	
	//Helper Methods
	func createAlert(title: String, message: String) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Try Again", style: .cancel, handler: nil))
		self.present(alert, animated: true)
	}
}
