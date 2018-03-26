//
//  ConflictsViewController.swift
//  MariGold
//
//  Created by Devin Sova on 3/25/18.
//  Copyright © 2018 MariGold. All rights reserved.
//

import UIKit

class ConflictsViewController: UIViewController {
	@IBOutlet var ConflictTableView: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	
	
}
class conflictTableViewCell: UITableViewCell {
	
}

extension ConflictsViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		//let conflicts = CoreDataHelper.retrieveMeds()
		//return conflicts.count
		return 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Plain Cell", for: indexPath) as! conflictTableViewCell
		return cell
	}
}
