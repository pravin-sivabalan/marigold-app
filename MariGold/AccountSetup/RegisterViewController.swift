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
    @IBOutlet weak var allergiesField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    
	@IBOutlet var NFLSwitch: UISwitch!
	@IBOutlet var NBASwitch: UISwitch!
	@IBOutlet var NCAASwitch: UISwitch!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		pastelView.setColors([UIColor(red: 240/255, green: 138/255, blue: 1/255, alpha: 1.0),
							  UIColor(red: 249/255, green: 212/255, blue: 0/255, alpha: 1.0)])
		pastelView.startAnimation()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
    
    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {
        if(!Connectivity.isConnectedToInternet) {
            createAlert(title: "Connection Error", message: "There is a connection error. Please check your internet connection or try again later")
            return false
        } else if(firstNameField.text == "" || lastNameField.text == "" || emailField.text == "" || passwordField.text == "" || confirmPasswordField.text == "") {
            createAlert(title: "Not Finished", message: "Please finish filling out fields")
            return false
        } else if(!isValidEmail(email: emailField.text!)) {
            createAlert(title: "Invalid Email", message: "Please enter a valid email")
            return false
        } else if(passwordField.text != confirmPasswordField.text) {
            createAlert(title: "Password Do Not Match", message: "Please make sure your passwords match")
            return false
        }
        
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var userInfo: [String: Any] = [
            "first_name" : firstNameField.text!,
            "last_name" : lastNameField.text!,
            "email" : emailField.text!,
            "password" : passwordField.text!,
        ]
        
        if let allergies = allergiesField?.text {
            userInfo["allergies"] = allergies
        }
        
        let vc = segue.destination as! RegisterLeagueViewController
        vc.userInfo = userInfo
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


