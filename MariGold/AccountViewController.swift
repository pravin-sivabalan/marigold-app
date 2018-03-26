//
//  AccountViewController.swift
//  MariGold
//
//  Created by Pravin Sivabalan on 2/21/18.
//  Copyright © 2018 MariGold. All rights reserved.
//

import UIKit
import Alamofire
import UserNotifications

class AccountViewController: UIViewController {
    @IBOutlet weak var leaguesLabel: UILabel!
    @IBOutlet weak var displayName: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var allergiesLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Alamofire.request(api.rootURL + "/user", encoding: JSONEncoding.default, headers: User.header).responseJSON { response in
            if let JSON = response.result.value {
                let data = JSON as! NSDictionary
                if(data.object(forKey: "message") as! String == "ok") {
                    let profile = data["profile"] as! NSDictionary
                    self.displayName.text = (profile["first_name"] as! String) + " " + (profile["last_name"] as! String)
                    self.emailLabel.text = profile["email"] as? String
                    if(profile["league"] != nil) {
                        let league: String = profile["league"] as! String
                        if(league != "") {
                            self.leaguesLabel.text = league
                        } 
                    }
                    if !(profile["allergies"] is NSNull) {
                        let allergies = profile["allergies"] as! String
                        if(allergies != "") {
                            self.allergiesLabel.text = allergies
                        } 
                    }
                } else {
                    self.createAlert(title: "Server Error", message: "There is a connection error. Please check your internet connection or try again later")
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutAction(_ sender: Any) {
        let alert = UIAlertController(title: "Logout", message: "Are you sure you would like to logout?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive) { (action:UIAlertAction!) in
            UserDefaults.standard.removeObject(forKey: "jwt")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "AccountSetupId") as UIViewController
            self.present(vc, animated: true, completion: nil)
        })

        self.present(alert, animated: true)
        
    }
    
    @IBAction func deleteAccountAction(_ sender: Any) {
        if(!Connectivity.isConnectedToInternet) {
            return createAlert(title: "Connection Error", message: "There is a connection error. Please check your internet connection or try again later.")
        }
        let alert = UIAlertController(title: "Delete Account", message: "Are you sure you would like delete your account FOREVER?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in
            return
        })
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { (action:UIAlertAction!) in
            Alamofire.request(api.rootURL + "/user/delete", method: .post, encoding: JSONEncoding.default, headers: User.header).responseJSON { response in
                if let JSON = response.result.value {
                    let data = JSON as! NSDictionary
                    if(data.object(forKey: "message") as! String == "ok") {
                        UserDefaults.standard.removeObject(forKey: "jwt")
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "AccountSetupId") as UIViewController
                        self.present(vc, animated: true, completion: nil)
                    } else {
                        self.createAlert(title: "Server Error", message: "There is a connection error. Please check your internet connection or try again later")
                    }
                }
            }
        })
        self.present(alert, animated: true)
    }
    
    func createAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try Again", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }

}
