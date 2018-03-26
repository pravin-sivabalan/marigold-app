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
	
	@IBAction func Done(_ sender: Any) {
		//Make API Call
		if(!Connectivity.isConnectedToInternet) {
			return self.createAlert(title: "Connection Error", message: "There is a connection error. Please check your internet connection or try again later.")
		}
			
		//Valid Input
		else {
			let body: [String: Any] = [
				"name" : Name,
				"cui" : Cui,
				"quantity" : Quantity.text!,
				"temporary" : Temporary.isOn,
				"notifications" : [String](),
				"alert_user" : 0
			]
			
			Alamofire.request(api.rootURL + "/meds/add", method: .post, parameters: body, encoding: JSONEncoding.default, headers: User.header).responseJSON { response in
				if let JSON = response.result.value {
					let data = JSON as! NSDictionary
					if(data["error_code"] != nil) {
						switch data["error_code"] as! Int {
						//Room for adding more detailed error messages
						default:
							return self.createAlert(title: "Server Error", message: "There is a connection error. Please check your internet connection or try again later.")
						}
					}
					else {
						let JSONconflicts = data["conflicts"] as! [[String: Any]]
                        
                        if JSONconflicts.count > 0 {
                            
                        }
                        
						for JSONconflict in JSONconflicts {
							let newConflict = CoreDataHelper.newConflict()
							newConflict.drug1id = JSONconflict["drug1"] as! Int64
							newConflict.drug2id = JSONconflict["drug2"] as! Int64
							let JSONconflictinfo = JSONconflict["info"] as! [[String : String]]
							
							newConflict.info = JSONconflictinfo[0]["desc"]
							newConflict.severity = JSONconflictinfo[0]["severity"]
						}
						//If Successful Pop View Controller
						self.navigationController?.popViewController(animated: true)
					}
				}
			}
		}
		
	}
	
	//Helper Methods
	func createAlert(title: String, message: String) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Try Again", style: .cancel, handler: nil))
		self.present(alert, animated: true)
	}
}
