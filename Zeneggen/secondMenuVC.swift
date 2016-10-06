//
//  secondMenuVC.swift
//  Zeneggen
//
//  Created by Benjamin Pfammatter on 06.04.16.
//  Copyright © 2016 Benjamin Pfammatter. All rights reserved.
//

import UIKit

class secondMenuVC: UITableViewController, UISplitViewControllerDelegate {
    
    var titles = [
    
        "Zeneggen": ["Anreise", "Maps", "Geschichte", "Gemeinde", "Pfarrei", "Transport"],
        "Dienstleistungen": ["Apotheken", "Einkaufen", "Transport", "Notfall", "Coiffeur", "Landhof Rohr", "Arzt"],
        "Erlebnis": ["Ausflüge", "Sommer", "Winter", "Kultur", "Gästekarte"],
        "Gastronomie": ["Hotel Alpenblick", "Bistro", "in der Nähe"],
        "Unterkunft": ["Chalet Waldesruh", "Hotel Alpenblick", "Pension Kastel", "Hotel Sonnenberg", "Skihütte"],
        "Kalender": ["Has to link to other VC"],
        "Multimedia": ["Test 1", "Test 2", "Test 3"],
        "Wetter/Webcams": ["Has to link to other VC"],
        "Orte": ["Has to link to other VC"],
    
    ]
    var icons = [
        
        "Zeneggen": ["Anreise", "Maps", "Geschichte", "Gemeinde", "Pfarrei", "Transport"],
        "Dienstleistungen": ["Apotheken", "Einkaufen", "Transport", "Notfall", "Coiffeur", "Landhof Rohr", "Arzt"],
        "Erlebnis": ["Ausflüge", "Sommer", "Winter", "Kultur", "Gästekarte"],
        "Gastronomie": ["Hotel Alpenblick", "Bistro", "in der Nähe"],
        "Unterkunft": ["Chalet Waldesruh", "Hotel Alpenblick", "Pension Kastel", "Hotel Sonnenberg", "Skihütte"],
        "Kalender": ["Has to link to other VC"],
        "Multimedia": ["Test 1", "Test 2", "Test 3"],
        "Wetter/Webcams": ["Has to link to other VC"],
        "Orte": ["Has to link to other VC"],
        
        ]
    
    var segues = [
        
        "Pension Kastel": ["goToWebView", "http://www.pension.ch"],
        
        ]
    
    var webVCLinks = [
    
        "Pension Kastel": "http://www.pension.ch"
    
    ]
    
    //recieve from previous view
    var seguedTitle = "Zeneggen"
    
    var segueLink = ""
    
    var tableData: [String] = []
    var iconData: [String] = []
    var segueData: [String] = []
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "goToWebView") {
            
            let passingLink = segue.destinationViewController as! webVC
            
            passingLink.URLPath = segueLink
            
        }
        
    }
    
    override func viewDidLoad() {
        self.navigationItem.title = seguedTitle
        //self.navigationController!.navigationBar.topItem!.title = ""
        
        tableData = titles[seguedTitle]! as [String]
        iconData = icons[seguedTitle]! as [String]
        //segueData = segues[seguedTitle]! as [String]
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("secondMenuCellUI")! as UITableViewCell
        
        //cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            
        cell.textLabel?.text = tableData[indexPath.row]
        
        if iconData[indexPath.row] != "" {
            
            cell.imageView?.image = UIImage(named: iconData[indexPath.row])
            
        }

        return cell
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)! as UITableViewCell
        
        var segueData = segues[(cell.textLabel?.text)!]
        
        segueLink = segueData![2]
        performSegueWithIdentifier(segueData![1], sender: self)
        
    }

}
