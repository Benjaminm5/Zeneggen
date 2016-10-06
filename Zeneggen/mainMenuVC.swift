//
//  mainMenuVC.swift
//  Zeneggen
//
//  Created by Benjamin Pfammatter on 05.04.16.
//  Copyright © 2016 Benjamin Pfammatter. All rights reserved.
//

import UIKit

class mainMenuVC: UITableViewController, UISplitViewControllerDelegate {

    //Firebase
    var ref = Firebase(url: "zeneggen.firebaseio.com/menu")
    
    var titles = ["Zeneggen", "Dienstleistungen", "Erlebnis", "Gastronomie", "Unterkunft", "Kalender", "Multimedia", "Wetter/Webcams", "Orte"]
    var titlesSection2 = ["Einstellungen", "App"]
    var titlesSection3 = ["Home", "Aktuelles"]
    
    var segueTitle = ""
    
    //var splitAboutVC = aboutVC()
    //var splitSecondMenuVC = secondMenuVC()
    
    //var splitViewObjects = ["secondMenu", "About"]
    
    override func awakeFromNib() {
        self.clearsSelectionOnViewWillAppear = false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "secondMenuSegue") {
            
            let passingTitle = segue.destinationViewController as! secondMenuVC
            
            passingTitle.seguedTitle = segueTitle
            /*
            let index = self.tableView.indexPathForSelectedRow! as NSIndexPath
            
            let nav = segue.destinationViewController as! UINavigationController
            
            let vc = nav.viewControllers[0] as! secondMenuVC
            
            vc.navigationItem.title = segueTitle
            
            self.tableView.deselectRowAtIndexPath(index, animated: true)
            
        } else if (segue.identifier == "dashboardSegue") {
            
            //let passingTitle = segue.destinationViewController as!
            */
        }
        
    }
    
    override func viewDidLoad() {
        
        //self.splitViewController?.delegate = self
        //self.splitViewController?.preferredDisplayMode = UISplitViewControllerDisplayMode.AllVisible
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rowsPerSection = [titlesSection3.count, titles.count, titlesSection2.count]
        return rowsPerSection[section]
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("mainMenuCellUI")! as UITableViewCell
        
        //cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        if indexPath.section == 0 {
            
            cell.textLabel?.text = titlesSection3[indexPath.row]
            
        } else if indexPath.section == 1 {
            
            cell.textLabel?.text = titles[indexPath.row]
            
        } else {
            
            cell.textLabel?.text = titlesSection2[indexPath.row]
            
        }
        
        return cell
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)! as UITableViewCell
        
        if indexPath.section == 0 {
            
            if indexPath.row == 0 {
                
                self.segueTitle = (cell.textLabel?.text)!
                performSegueWithIdentifier("dashboardSegue", sender: self)
                
            }
        
        } else if indexPath.section == 1 {
            
            self.segueTitle = (cell.textLabel?.text)!
            performSegueWithIdentifier("secondMenuSegue", sender: self)
            
        } else {
            
            if indexPath.row == titlesSection2.count - 1 {
                
                self.segueTitle = (cell.textLabel?.text)!
                performSegueWithIdentifier("aboutSegue", sender: self)
                
            }
            
        }
        
    }
    /*
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController, ontoPrimaryViewController primaryViewController: UIViewController) -> Bool {
        return true
    }
    */
}
