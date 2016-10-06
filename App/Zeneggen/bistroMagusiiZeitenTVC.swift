//
//  bistroMagusiiZeitenTVC.swift
//  Zeneggen
//
//  Created by Benjamin Pfammatter on 15.07.16.
//  Copyright © 2016 Benjamin Pfammatter. All rights reserved.
//

import UIKit

class bistroMagusiiZeitenTVC: UITableViewController {
    
    let tageTitel = ["Montag", "Dienstag", "Mittwoch", "Donnerstag", "Freitag", "Samstag", "Sonntag"]
    
    override func viewDidLoad() {
        
        configureTableView()
        
    }
    
    func configureTableView() {
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 280.0
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: bistroZeitenCell = self.tableView.dequeueReusableCell(withIdentifier: "bistroZeitenCellUI")! as! bistroZeitenCell
        
        cell.wochentagLabel.text = tageTitel[(indexPath as NSIndexPath).row]
        
        return cell
        
    }

}
