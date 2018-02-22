//
//  ResetPasswordViewController.swift
//  MariGold
//
//  Created by Devin Sova on 2/19/18.
//  Copyright © 2018 MariGold. All rights reserved.
//

import UIKit
import Pastel
import Alamofire

class ResetPasswordViewController: UIViewController {
	@IBOutlet var pastelView: PastelView!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var resetPasswordButton: UIButton!
    
	override func viewDidLoad() {
		super.viewDidLoad()
		
		//Setup PastelView
		pastelView.setColors([UIColor(red: 240/255, green: 138/255, blue: 1/255, alpha: 1.0),
							  UIColor(red: 249/255, green: 212/255, blue: 0/255, alpha: 1.0)])
		pastelView.startAnimation()
	}
    
    @IBAction func resetPasswordAction(_ sender: Any) {
        if(!Connectivity.isConnectedToInternet) {
            resetPasswordButton.isEnabled = true
            return createErrorAlert(title: "Connection Error", message: "There is a connection error. Please check your internet connection or try again later.")
        } else if(emailField.text == "") {
            return createErrorAlert(title: "Not Finished", message: "Please enter your email address.")
        } else if(!isValidEmail(email: emailField.text!)) {
            return createErrorAlert(title: "Invalid Email", message: "Please enter a valid email.")
        }
        Alamofire.request(api.rootURL + "/user/change-password/" + emailField.text!, headers: nil).responseJSON { response in
            if let JSON = response.result.value {
                let data = JSON as! NSDictionary
                print(data)
                if(data["error_code"] != nil) {
                    switch data["error_code"] as! Int {
                        case 20:
                            return self.createErrorAlert(title: "Account ", message: "This account does not exist. Please check you have entered your information correctly.")
                        default:
                            return self.createErrorAlert(title: "Server Error", message: "There is a connection error. Please check your internet connection or try again later.")
                    }
                } else if(data.object(forKey: "message") as! String == "ok") {
                    let alert = UIAlertController(title: "Success", message: "Please check your email for further instructions.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction!) in
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "AccountSetupId") as UIViewController
                        return self.present(vc, animated: true, completion: nil)
                    })
                    self.present(alert, animated: true)
                } else {
                    return self.createErrorAlert(title: "Server Error", message: "There is a connection error. Please check your internet connection or try again later")
                }
            }
        }
    }
    
    func createErrorAlert(title: String, message: String) {
        resetPasswordButton.isEnabled = false
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try Again", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let match = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return match.evaluate(with: email)
    }
    
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}
