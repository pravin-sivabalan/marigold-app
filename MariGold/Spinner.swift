//
//  Spinner.swift
//  MariGold
//
//  Created by Andrew Bass on 3/25/18.
//  Copyright © 2018 MariGold. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    class func displaySpinner(onView : UIView) -> UIView {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.0)
        
        let ai = UIActivityIndicatorView.init(activityIndicatorStyle: .whiteLarge)
        ai.color = UIColor.black
        ai.alpha = 0
        
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
            
            UIView.animate(withDuration: 0.25, animations: {
                ai.alpha = 1
            })
        }
        
        return spinnerView
    }
    
    class func removeSpinner(spinner: UIView) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.25, animations: {
                spinner.alpha = 0
            }, completion: { done in
                if done {
                    spinner.removeFromSuperview()
                }
            })
        }
    }
}
