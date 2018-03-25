//
//  RegisterViewController.swift
//  MariGold
//
//  Created by Devin Sova on 2/27/18.
//  Copyright © 2018 MariGold. All rights reserved.
//

import UIKit
import Pastel
import Alamofire

class RegisterViewController: UIViewController {
	@IBOutlet var pastelView: PastelView!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
	@IBOutlet var NFLSwitch: UISwitch!
	@IBOutlet var NBASwitch: UISwitch!
	@IBOutlet var NCAASwitch: UISwitch!
    @IBOutlet weak var allergiesField: UITextField!
    
	override func viewDidLoad() {
		super.viewDidLoad()
		
		//Setup PastelView
		pastelView.setColors([UIColor(red: 240/255, green: 138/255, blue: 1/255, alpha: 1.0),
							  UIColor(red: 249/255, green: 212/255, blue: 0/255, alpha: 1.0)])
		pastelView.startAnimation()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
    
    @IBAction func registerAction(_ sender: Any) {
        if(!Connectivity.isConnectedToInternet) {
            return createAlert(title: "Connection Error", message: "There is a connection error. Please check your internet connection or try again later")
        } else if(firstNameField.text == "" || lastNameField.text == "" || emailField.text == "" || passwordField.text == "" || confirmPasswordField.text == "") {
            return createAlert(title: "Not Finished", message: "Please finish filling out fields")
        } else if(!isValidEmail(email: emailField.text!)) {
            return createAlert(title: "Invalid Email", message: "Please enter a valid email")
        } else if(passwordField.text != confirmPasswordField.text) {
            return createAlert(title: "Password Do Not Match", message: "Please make sure your passwords match")
        } 
		
		var leagueArray = [String]()
		if(NFLSwitch.isOn) {
			leagueArray.append("NFL")
		}
		if(NBASwitch.isOn) {
			leagueArray.append("NBA")
		}
		if(NCAASwitch.isOn) {
			leagueArray.append("NCAA")
		}
		let leagues = leagueArray.joined(separator: ", ")
		
        let body: [String: Any] = [
            "first_name" : firstNameField.text!,
            "last_name" : lastNameField.text!,
            "email" : emailField.text!,
            "password" : passwordField.text!,
            "league" : leagues,
            "allergies" : allergiesField.text!
        ]
        
        Alamofire.request(api.rootURL + "/user/register", method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            if let JSON = response.result.value {
                let data = JSON as! NSDictionary
                if(data["error_code"] != nil) {
                    switch data["error_code"] as! Int {
                    case 23:
                        return self.createAlert(title: "Account ", message: "This account does not exist. Please check you have entered your information correctly.")
                    default:
                        return self.createAlert(title: "Server Error", message: "There is a connection error. Please check your internet connection or try again later")
                    }
                } else if(data.object(forKey: "jwt") != nil) {
                    UserDefaults.standard.set(data.object(forKey: "jwt"), forKey: "jwt");
                    let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "tabbarControllerID") as UIViewController
                    self.present(vc, animated: true, completion: nil)
                } else {
                    return self.createAlert(title: "Server Error", message: "There is a connection error. Please check your internet connection or try again later")
                }
            }
        }
    }
    
    func createAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try Again", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let match = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return match.evaluate(with: email)
    }
}


