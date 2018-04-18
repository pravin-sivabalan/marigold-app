//
//  DashboardTabViewController.swift
//  MariGold
//
//  Created by Andrew Bass on 4/18/18.
//  Copyright © 2018 MariGold. All rights reserved.
//

import UIKit

class DashboardTabViewController: UIViewController {
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBOutlet weak var scheduleView: UIView!
    @IBOutlet weak var sideEffectsView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentControl.selectedSegmentIndex = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func show(_ view: UIView) {
        scheduleView.isHidden = true
        sideEffectsView.isHidden = true
        
        view.isHidden = false
    }
    
    @IBAction func selectedTab(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            show(scheduleView)
        } else if sender.selectedSegmentIndex == 1 {
            show(sideEffectsView)
        }
    }
}
