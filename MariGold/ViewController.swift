//
//  ViewController.swift
//  MariGold
//
//  Created by Pravin Sivabalan on 1/23/18.
//  Copyright © 2018 MariGold. All rights reserved.
//

import UIKit
import Pastel

class ViewController: UIViewController {

    @IBOutlet weak var getStartedButton: UIButton!
    @IBOutlet weak var emailView: UITextField!
    @IBOutlet weak var passwordView: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let border = CALayer()
//        let width = CGFloat(2.0)
//        border.borderColor = UIColor.darkGray.cgColor
//        border.frame = CGRect(x: 0, y: passwordView.frame.size.height - width, width:  passwordView.frame.size.width, height: passwordView.frame.size.height);
//        border.borderWidth = width;
//        passwordView.layer.addSublayer(border);
//        passwordView.layer.masksToBounds = true;

        // Customize navigation controller
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        self.navigationController?.navigationBar.tintColor = UIColor.white;

        // Add Pastel Gradient 
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


}

