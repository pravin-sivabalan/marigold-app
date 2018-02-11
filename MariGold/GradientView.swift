//
//  GradientView.swift
//  MariGold
//
//  Created by Devin Sova on 2/9/18.
//  Copyright © 2018 MariGold. All rights reserved.
//

import UIKit

class GradientView: UIView {
	override open class var layerClass: AnyClass {
		return CAGradientLayer.classForCoder()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		let gradientLayer = self.layer as! CAGradientLayer
		gradientLayer.colors = [UIColor.yellow.cgColor, UIColor.orange.cgColor]
		gradientLayer.startPoint = CGPoint(x: 0, y: 0)
		gradientLayer.endPoint = CGPoint(x: 1, y: 1)
	}
}
