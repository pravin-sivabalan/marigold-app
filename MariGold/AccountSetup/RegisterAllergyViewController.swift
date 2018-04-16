//
//  RegisterAllergyViewController.swift
//  MariGold
//
//  Created by Pravin Sivabalan on 4/15/18.
//  Copyright © 2018 MariGold. All rights reserved.
//

import UIKit
import Alamofire
import Pastel

class RegisterAllergyViewController: UIViewController {
    @IBOutlet weak var allergiesField: UITextField!
    var userInfo: [String: Any] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        let pastelView = PastelView(frame: view.bounds)
        pastelView.setColors([UIColor(red: 240/255, green: 138/255, blue: 1/255, alpha: 1.0),
                              UIColor(red: 249/255, green: 212/255, blue: 0/255, alpha: 1.0)])
        pastelView.startAnimation()
        view.insertSubview(pastelView, at: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func registerButtonAction(_ sender: Any) {
        print(userInfo)
        if let allergies = allergiesField?.text {
            userInfo["allergies"] = allergies
        }

        Alamofire.request(api.rootURL + "/user/register", method: .post, parameters: userInfo, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
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
                    UserDefaults.standard.set(self.userInfo["first_name"] as! String, forKey: "first_name")
                    UserDefaults.standard.set(self.userInfo["last_name"] as! String, forKey: "last_name")
                    UserDefaults.standard.set(self.userInfo["email"] as? String ?? "", forKey: "email")
                    UserDefaults.standard.set(self.userInfo["league"] as? String ?? "", forKey: "league")
                    UserDefaults.standard.set(self.userInfo["allergies"] as? String ?? "", forKey: "allergies")
                    
                    let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "tabbarControllerID") as UIViewController
                    
//                    // Save password for new user
//                    try! KeychainPasswordItem.deleteItems()
//                    let keychainPassword = KeychainPasswordItem(account: self.emailField.text!)
//                    
//                    do {
//                        try keychainPassword.savePassword(self.passwordField.text!)
//                    } catch {
//                        print("Keychain saving error: \(error)")
//                    }
                    
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
    
}
