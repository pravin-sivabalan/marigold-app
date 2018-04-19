//
//  SearchRelationsTableViewController.swift
//  MariGold
//
//  Created by Pravin Sivabalan on 4/19/18.
//  Copyright © 2018 MariGold. All rights reserved.
//

import UIKit

class SearchRelationsTableViewController: UITableViewController {
    var relations: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return relations.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "relationsCell", for: indexPath)
        cell.textLabel?.text = relations[indexPath.row]
        return cell
    }

}
