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
    @IBOutlet weak var RefillNotif: UISwitch!
    @IBOutlet weak var leagueConflictsField: UILabel!
    @IBOutlet weak var allergyConflictsLabel: UILabel!
    
    var Name: String!
    var Cui: String!
    var spinner: UIView!
    
    var allergyConflicts: [AllergyConflictObject] = []
    
    override func viewDidLoad() {
        getConflicts()
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
        guard let identifier = segue.identifier else { return }
        
        if identifier == "displayAddNotifications" {
            let body: [String: Any] = [
                "name" : Name,
                "cui" : Cui,
                "quantity" : Quantity.text!,
                "temporary" : Temporary.isOn,
                "phoneNotification": PhoneNotif.isOn,
                "emailNotification": EmailNotif.isOn,
                "refillNotification": RefillNotif.isOn
            ]
            
            // Create a new variable to store the instance of PlayerTableViewController
            let destinationVC = segue.destination as! AddNotificationTableViewController
            destinationVC.med = body
            return
        } else if identifier == "displayAllergiesAddMed" {
            let nextVC = segue.destination as! AllergyConflictsViewController
            nextVC.useAllergyConflictsArr = true
            nextVC.allergyConflicts = self.allergyConflicts
            nextVC.medicationName = Name
            return
        }
        
        if let nextVc = segue.destination as? MedicationViewController {
            nextVc.Refresh(self)
        }
    }
    
    func getConflicts() {
        
        self.spinner = UIViewController.displaySpinner(onView: self.tableView)
        let medNameArr = self.Name.components(separatedBy: " ")

        let req = Alamofire.request(api.rootURL + "/meds/conflicts-with/" + self.Cui + "/" + medNameArr[0], encoding: JSONEncoding.default, headers: User.header)
        req.responseJSON { resp in

            UIViewController.removeSpinner(spinner: self.spinner)
            
            guard let data = resp.result.value else {
                return
            }
            
            guard let json = data as? NSDictionary else {
                return print("Could not read in data as JSON")
            }
            
            guard let message = json["message"] as? String else {
                return print("Could not get message")
            }
            
            if (message != "ok") {
                return self.createAlert(title: "Conflicts", message: "Error retrieving conflicts")
            }
            
            print(json)
            
            guard let allergyConflicts = json["allergy_conflicts"] as? [Any] else {
                print("Could not read in matches")
                return
            }
            self.readAllergies(jsonAllergies: allergyConflicts)
            self.allergyConflictsLabel.text = "Allergy Conflicts (" + String(allergyConflicts.count) + ")"

            let leagueConflicts = json["leagues"] as? String
            if(leagueConflicts != "") {
                self.leagueConflictsField.text = leagueConflicts
            }
        }
    }
    
    func readAllergies(jsonAllergies: [Any]) {
        allergyConflicts.removeAll()
        for allergy in jsonAllergies {
            let obj = allergy as! NSDictionary
            let allergy = obj["allergy"] as! String
            let desc = obj["desc"] as! String
            let type = obj["type"] as! String
            allergyConflicts.append(AllergyConflictObject(allergy: allergy, desc: desc, type: type))
        }
    }
	
	//Helper Methods
	func createAlert(title: String, message: String) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Try Again", style: .cancel, handler: nil))
		self.present(alert, animated: true)
	}
}
