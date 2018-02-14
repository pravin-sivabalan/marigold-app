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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Make navigation bar transprent
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear


        // Add Pastel Gradient
        let pastelView = PastelView(frame: view.bounds)
        pastelView.startAnimation()
        view.insertSubview(pastelView, at: 0)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

