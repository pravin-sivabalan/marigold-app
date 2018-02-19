//
//  LoginViewController.swift
//  
//
//  Created by Pravin Sivabalan on 2/17/18.
//

import UIKit
import Pastel

class LoginViewController: UIViewController {
    @IBOutlet weak var emailView: UITextField!
    @IBOutlet weak var passwordView: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = UIColor.white;
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        var border = CALayer()
        let width: CGFloat = 1
        border.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        border.frame = CGRect(x: 0, y: passwordView.frame.size.height - width, width: passwordView.frame.size.width, height: 1)
        border.borderWidth = width
        passwordView.layer.addSublayer(border)
        
        border = CALayer()
        border.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        border.frame = CGRect(x: 0, y: emailView.frame.size.height - width, width: emailView.frame.size.width, height: 1)
        border.borderWidth = width
        emailView.layer.addSublayer(border)

        let pastelView = PastelView(frame: view.bounds)
        pastelView.setColors([UIColor(red: 240/255, green: 138/255, blue: 1/255, alpha: 1.0),
                              UIColor(red: 249/255, green: 212/255, blue: 0/255, alpha: 1.0)])
        pastelView.startAnimation()
        view.insertSubview(pastelView, at: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
