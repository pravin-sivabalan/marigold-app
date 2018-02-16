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
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        
////        let border = CALayer()
////        let width = CGFloat(2.0)
////        border.borderColor = UIColor.darkGray.cgColor
////        border.frame = CGRect(x: 0, y: emailView.frame.size.height - width, width:  emailView.frame.size.width, height: emailView.frame.size.height)
//
//        border.borderWidth = width;
//        emailView.layer.addSublayer(border);
//        emailView.layer.masksToBounds = true;

        // Make navigation bar transparent
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear

        // Add Pastel Gradient 
        let pastelView = PastelView(frame: view.bounds)
        pastelView.setColors([UIColor(red: 165/255, green: 165/255, blue: 165/255, alpha: 1.0),
                              UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1.0)])
        
        pastelView.startAnimation()
        view.insertSubview(pastelView, at: 0)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

