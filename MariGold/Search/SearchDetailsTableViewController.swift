//
//  SearchDetailsTableViewController.swift
//  MariGold
//
//  Created by Pravin Sivabalan on 4/18/18.
//  Copyright © 2018 MariGold. All rights reserved.
//

import UIKit
import Alamofire

class SearchDetailsTableViewController: UITableViewController {
    var Cui: String = ""
    var MedName: String = ""
    var mayTreat: [String] = []
    var ciWith: [String] = []
    var spinner: UIView!
    
    @IBOutlet weak var headerNameLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UITextField!
    @IBOutlet weak var typeLabel: UITextField!
    @IBOutlet weak var rxCuiLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadProperties()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func loadProperties() {
        self.spinner = UIViewController.displaySpinner(onView: self.tableView)
        let req = Alamofire.request(api.rootURL + "/meds/details/" + self.Cui, encoding: JSONEncoding.default, headers: User.header)
        req.responseJSON { resp in
            print(resp)
            UIViewController.removeSpinner(spinner: self.spinner)
    
            guard let data = resp.result.value else {
                return
            }
    
            guard let json = data as? NSDictionary else {
                print("Could not read in data as JSON")
                return
            }
    
            guard let message = json["message"] as? String else {
                print("Could not get message")
                return
            }
    
            if (message != "ok") {
                print(resp)
                self.createAlert(title: "Lookup", message: "Could not find drugs to help with your symptom")
            }
    
            let details = json["details"] as! [String: Any]
            let props = details["props"] as! [String: Any]
            
            self.headerNameLabel.text = self.MedName
            
            let name = props["name"] as! String
            self.fullNameLabel.text = name
            
            let type = props["tty"] as! String
            if(type == "SCD" || type == "SCDF") {
                self.typeLabel.text = "Generic"
            } else if(type == "SBD" || type == "SBDF") {
                self.typeLabel.text = "Brand Name"
            }
            
            let rxCui = props["rxcui"] as! String
            self.rxCuiLabel.text = rxCui
            
            let classes = details["classes"] as! [[String: Any]]

            self.ciWith.removeAll()
            self.mayTreat.removeAll()
            for item in classes {
                let relation: String
                if item["relation"] is NSNull {
                    relation = ""
                } else {
                    relation = item["relation"] as! String
                }
                let name = item["name"] as! String
                if(relation == "may_treat") {
                    self.mayTreat.append(name)
                } else if(relation == "CI_with") {
                    self.ciWith.append(name)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        if identifier == "showMayTreat" {
            let nextVC = segue.destination as! SearchRelationsTableViewController
            nextVC.relations = self.mayTreat
        } else if identifier == "showCannotTakeWith" {
            let nextVC = segue.destination as! SearchRelationsTableViewController
            nextVC.relations = self.ciWith
        }
    }

    func createAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }


}
