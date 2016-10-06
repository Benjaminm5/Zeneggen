//
//  MasterViewController.swift
//  Zeneggen
//
//  Created by Benjamin Pfammatter on 08.06.16.
//  Copyright © 2016 Benjamin Pfammatter. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {
    
    // MARK: - Variables
    var titlesSection0 = ["Home", "Aktuelles"]
    var titlesSection1 = ["Zeneggen", "Dienstleistungen", "Erlebnis", "Gastronomie", "Unterkunft", "Kalender", "Multimedia", "Wetter/Webcams", "Orte"]
    var titlesSection2 = ["Einstellungen", "Über diese App"]
    
    var iconsSection0 = ["icon-home", "icon-news"]
    var iconsSection1 = ["icon-zeneggen", "icon-services", "icon-activity", "icon-eat", "icon-bed", "icon-calendar", "icon-multimedia", "icon-weather", "icon-pin"]
    var iconsSection2 = ["icon-settings", "icon-appstore"]
    
    var selectedRow = ""
    var webUrl: URL = URL(string: "http://weather.com")!
    
    var detailViewController: DetailViewController? = nil
    var aktuellesVC: aktuellesTVC? = nil
    //var kalenderVC: kalenderTVC? = nil
    var webVC: webStandardVC? = nil
    //var aktuellesTVC: aktuellesTVC? = nil
    //var objects = [AnyObject]()
    
    //settings vars
    //let navigationBarColor = NSUserDefaults.standardUserDefaults().valueForKey("navigationBarColor") as! UIColor
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //settings
        self.navigationController?.navigationBar.barTintColor = mainColor
        self.navigationController?.navigationBar.tintColor = secondaryBlackOnWhiteBackground
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: blackOnWhiteBackground]
        
        if let split = self.splitViewController {
            
            if selectedRow == "" {
                
                let controllers = split.viewControllers
                self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
                
            } else if selectedRow == "Aktuelles" {
                
                
                //let controllers = split.viewControllers
                //self.aktuellesTVC = (controllers[controllers.count-1] as! UINavigationController).topViewController as? aktuellesTVC
                
            }
            
        }
        
        self.navigationController?.navigationBar.topItem?.title = ""
        
        self.navigationItem.title = "Wilkommen"
        /*
        let backgroundImage = UIImage(named: "testImage")
        let imageView = UIImageView(image: backgroundImage)
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        self.tableView.backgroundView = imageView
        
        //Blur Effect
        let blur: UIBlurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blurView: UIVisualEffectView = UIVisualEffectView(effect: blur)
        blurView.frame = self.view.frame
        blurView.alpha = 1
        imageView.addSubview(blurView)
        */
    }

    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
    func insertNewObject(sender: AnyObject) {
        objects.insert(NSDate(), atIndex: 0)
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
    */
    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "directDetailSegue" {
            
            let object = selectedRow
            let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
            controller.viewCategory = object
            //controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
            //controller.navigationItem.leftItemsSupplementBackButton = true
            
        } else if segue.identifier == "goTo2ndMenu" {
            
            let controller = segue.destination as! secondMasterVC
            controller.category = selectedRow
            
        } else if segue.identifier == "aktuellesSegue" {
            
            let object = selectedRow
            let controller = (segue.destination as! UINavigationController).topViewController as! aktuellesTVC
            controller.viewCategory = object
            //controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
            //controller.navigationItem.leftItemsSupplementBackButton = true
 
        } else if segue.identifier == "kalenderSegue" {
            
            let object = selectedRow
            let controller = (segue.destination as! UINavigationController).topViewController as! kalenderTVC
            controller.viewCategory = object
            //controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
            //controller.navigationItem.leftItemsSupplementBackButton = true
            
        } else if segue.identifier == "webSegue" {
            
            let object = selectedRow
            let object2 = webUrl
            let controller = (segue.destination as! UINavigationController).topViewController as! webStandardVC
            controller.viewCategory = object
            controller.urlReceived = object2
            //controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
            //controller.navigationItem.leftItemsSupplementBackButton = true
            
        }
        
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var rowsPerSection = [titlesSection0.count, titlesSection1.count, titlesSection2.count]
        return rowsPerSection[section]
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let cell = tableView.dequeueReusableCellWithIdentifier("mainMenuCellUI", forIndexPath: indexPath)
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "mainMenuCellUI")! as UITableViewCell
        
        //cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        
        if (indexPath as NSIndexPath).section == 0 {
            
            cell.textLabel?.text = titlesSection0[(indexPath as NSIndexPath).row]
            cell.imageView?.image = UIImage(named: iconsSection0[(indexPath as NSIndexPath).row])
            //cell.imageView?.image? = (cell.imageView?.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate))!
            //cell.imageView?.tintColor = secondaryColor
            
        } else if (indexPath as NSIndexPath).section == 1 {
            
            cell.textLabel?.text = titlesSection1[(indexPath as NSIndexPath).row]
            cell.imageView?.image = UIImage(named: iconsSection1[(indexPath as NSIndexPath).row])
            
            if (indexPath as NSIndexPath).row != 0 {
                
                //cell.imageView?.tintColor = secondarySecondaryColorLight
                //cell.imageView?.image? = (cell.imageView?.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate))!
                //cell.imageView?.tintColor = secondaryColor
                
            }
            
        } else {
            
            cell.textLabel?.text = titlesSection2[(indexPath as NSIndexPath).row]
            cell.imageView?.image = UIImage(named: iconsSection2[(indexPath as NSIndexPath).row])
            //cell.imageView?.image? = (cell.imageView?.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate))!
            //cell.imageView?.tintColor = secondaryColor
            
        }
        
        return cell
        
        
        //let object = objects[indexPath.row] as! NSDate
        //cell.textLabel!.text = object.description
        //return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)! as UITableViewCell
        
        if (indexPath as NSIndexPath).section == 0 {
            
            if (indexPath as NSIndexPath).row == 0 {
                
                self.selectedRow = (cell.textLabel?.text)!
                performSegue(withIdentifier: "directDetailSegue", sender: self)
                
            } else if (indexPath as NSIndexPath).row == 1 {
                
                self.selectedRow = (cell.textLabel?.text)!
                performSegue(withIdentifier: "aktuellesSegue", sender: self)
                
            }
            
        } else if (indexPath as NSIndexPath).section == 1 {
            
            if (indexPath as NSIndexPath).row != 5 {
                
                if (indexPath as NSIndexPath).row == 7 {
                    
                    self.selectedRow = (cell.textLabel?.text)!
                    self.webUrl = URL(string: "https://ch.wetter.com/schweiz/zeneggen/CH0CH4464.html")!
                    performSegue(withIdentifier: "webSegue", sender: self)
                    
                } else {
                    
                    self.selectedRow = (cell.textLabel?.text)!
                    performSegue(withIdentifier: "goTo2ndMenu", sender: self)
                    
                }
                
            } else {
                
                self.selectedRow = (cell.textLabel?.text)!
                performSegue(withIdentifier: "kalenderSegue", sender: self)
                
            }
            
            //self.selectedRow = (cell.textLabel?.text)!
            //performSegueWithIdentifier("secondMenuSegue", sender: self)
            
        } else {
            
            self.selectedRow = (cell.textLabel?.text)!
            performSegue(withIdentifier: "goTo2ndMenu", sender: self)
            
            if (indexPath as NSIndexPath).row == 0 {
                
                //
                
            }
            
        }
        
    }
    

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //objects.removeAtIndex(indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }


}

