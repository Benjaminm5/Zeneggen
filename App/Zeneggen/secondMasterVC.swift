//
//  secondMasterVC.swift
//  Zeneggen
//
//  Created by Benjamin Pfammatter on 10.06.16.
//  Copyright © 2016 Benjamin Pfammatter. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class secondMasterVC: UITableViewController {

    var selectedRow = ""
    var category = ""
    
    var activityIndicator = activityIndicatorV()
    
    var ref: FIRDatabaseReference!
    
    var zeneggenTitles = ["Anreise", "Karten", "Geschichte", "Gemeinde", "Pfarrei", "Transport"]
    var dienstleistungenTitles = ["Apotheken", "Einkaufen", "Transport", "Notfall", "Coiffeur", "Landhof Rohr", "Arzt"]
    var erlebnisTitles = ["Ausflüge", "Sommer", "Winter", "Kultur", "? Gästekarte ?"]
    var gastronomieTitles = ["Hotel Alpenblick", "Bistro", "in der Nähe"]
    var unterkunftTitles = ["Chalet Waldesruh", "Hotel Alpenblick", "Pension Kastel", "Hotel Sonnenberg", "Skihütte"]
    var multimediaTitles = ["Fotos", "Videos", "Werbevideos"]
    var orteTitles = ["Dorf", "Hellela", "Sisetsch", "Esch", "Gstei", "Kastel", "Diepja", "Klettergarten", "etc."]
    var einstellungenTitles = ["Login"]
    var aboutTitles = ["Entwickler", "Webseite", "Versions-Details"]
    
    var titles = [String]()
    var segues = [String]()
    
    var detailViewController: DetailViewController? = nil
    var multimediaVC: multimediaGallery? = nil
    var bistroController: bistroMagusiiVC? = nil
    
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = mainColor
        self.navigationController?.navigationBar.tintColor = secondaryBlackOnWhiteBackground
        
        startActivityIndicator()
        
        headerView.alpha = 0
        headerView.backgroundColor = secondaryColor
        headerLabel.textColor = UIColor.white
        
        self.navigationItem.title = category
        
        ref = FIRDatabase.database().reference()
        loadTitles()
        
        if category == "Über diese App" {
            
            footerView.alpha = 1
            
        } else {
            
            footerView.alpha = 0
            
        }
        
        /*
        if category == "Zeneggen" {
            titles = zeneggenTitles
        } else if category == "Dienstleistungen" {
            titles = dienstleistungenTitles
        } else if category == "Erlebnis" {
            titles = erlebnisTitles
        } else if category == "Gastronomie" {
            titles = gastronomieTitles
        } else if category == "Unterkunft" {
            titles = unterkunftTitles
        } else if category == "Multimedia" {
            titles = multimediaTitles
        } else if category == "Orte" {
            titles = orteTitles
        } else if category == "Einstellungen" {
            titles = einstellungenTitles
        } else if category == "Über diese App" {
            titles = aboutTitles
        }
        */
        
        /*
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        */
    }
    
    func loadTitles() {
        
        let titlesKey = "titles-second-\(self.category)"
        let seguesKey = "segues-second-\(self.category)"
        
        //Get Array to know if we have to update it or not
        let titlesUD = UserDefaults.standard.array(forKey: titlesKey)
        let seguesUD = UserDefaults.standard.array(forKey: seguesKey)
        
        print("BEN: \(titlesUD)")
        print("BEN: \(seguesUD)")
        
        var activityIndicatorStopped = false
        
        if titlesUD != nil && seguesUD != nil {
            
            self.titles = titlesUD as! [String]
            self.segues = seguesUD as! [String]
            
            self.tableView.reloadData()
            
            stopActivityIndicator()
            activityIndicatorStopped = true
            
        }
        
        var temporaryTitles = [String]()
        var temporarySegues = [String]()
        
        let query = (ref.child("menu").child("de").child("second").child(category)).queryOrderedByKey()
        query.observeSingleEvent(of: .value, with: { snapshot in
            
            for child in snapshot.children {
                
                let data = (child as! FIRDataSnapshot).value! as! NSDictionary
                
                let released = data["released"]! as! Bool
                
                if released {
                    
                    temporaryTitles.append(data["value"]! as! String)
                    temporarySegues.append(data["segue"]! as! String)
                    
                }
                
            }
            
            if self.titles != temporaryTitles {
                
                //Update User Defaults
                UserDefaults.standard.set(temporaryTitles, forKey: titlesKey)
                self.titles = temporaryTitles
                
            }
            
            if self.segues != temporarySegues {
                
                //Update User Defaults
                UserDefaults.standard.set(temporarySegues, forKey: seguesKey)
                self.segues = temporarySegues
                
            }
            
            self.tableView.reloadData()
            
            if !activityIndicatorStopped {
                
                self.stopActivityIndicator()
                
            }
            
        }) { (error) in
            
            print("BEN: ERRRRRRRORRRRRR")
            
            self.headerLabel.text = "Internet-Verbindung notwendig!"
            self.headerView.alpha = 1
            print(error.localizedDescription)
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        //super.viewWillAppear(animated)
        
        let selectedRow = self.tableView.indexPathForSelectedRow
        if selectedRow != nil {
            self.tableView.deselectRow(at: selectedRow!, animated: true)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail" {
            
            let object = selectedRow
            let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
            controller.viewCategory = object
            //controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
            //controller.navigationItem.leftItemsSupplementBackButton = true
            
        } else if segue.identifier == "multimedia" {
            
            let object = selectedRow
            let controller = (segue.destination as! UINavigationController).topViewController as! multimediaGallery
            controller.viewCategory = object
            //controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
            //controller.navigationItem.leftItemsSupplementBackButton = true
            
        } else if segue.identifier == "profile" {
            
            let object = selectedRow
            let controller = (segue.destination as! UINavigationController).topViewController as! bistroMagusiiVC
            print(object)
            controller.viewCategory = object
            //controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
            //controller.navigationItem.leftItemsSupplementBackButton = true
        
        //} else if segue.identifier == "login" {
            
            //let object = selectedRow
            //let controller = (segue.destination as! UINavigationController).topViewController as! loginVC
            //controller.viewCategory = object
            //controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
            //controller.navigationItem.leftItemsSupplementBackButton = true
            
        }
        
    }
 
    // MARK: - table
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return titles.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "2ndMenuCellUI")! as UITableViewCell
        
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        
        cell.textLabel?.text = titles[(indexPath as NSIndexPath).row]
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)! as UITableViewCell
        
        if cell.textLabel?.text == "Notfall" {
            
            performSegue(withIdentifier: "NOTFALL", sender: self)
            
        } else {
            
            if segues[indexPath.row] == "mapWithDirection" {
                
                if cell.textLabel?.text == "Anreise" {
                    
                    let universalMethods = externUniversalMethods()
                    universalMethods.goToMapWithDirections(lat: 46.273299, lon: 7.866678, title: "Zeneggen, Dorfzentrum")
                    
                }
                
            } else {
                
                self.selectedRow = (cell.textLabel?.text)!
                performSegue(withIdentifier: segues[indexPath.row], sender: self)
                
            }
            
        }
        /*
        if category == "Multimedia" {
            
            self.selectedRow = (cell.textLabel?.text)!
            performSegue(withIdentifier: "multimediaGallerySegue", sender: self)
            
        } else if category == "Zeneggen" {
            
            if cell.textLabel?.text == "Anreise" {
                
                
                
            } else {
            
            //if indexPath.row == 3 {
                
                self.selectedRow = (cell.textLabel!.text)!
                performSegue(withIdentifier: "bistroSegue", sender: self)
                
            }
            
        } else if category == "Gastronomie" {
            
            //if indexPath.row == 1 {
                
                self.selectedRow = (cell.textLabel?.text)!
                performSegue(withIdentifier: "bistroSegue", sender: self)
                
            //}
            
        } else if category == "Unterkunft" {
            
            //if indexPath.row == 0 {
                
                self.selectedRow = (cell.textLabel?.text)!
                performSegue(withIdentifier: "bistroSegue", sender: self)
                
            //}
            
        } else if category == "Einstellungen" {
            
            if (indexPath as NSIndexPath).row == 0 {
                
                //self.selectedRow = (cell.textLabel?.text)!
                performSegue(withIdentifier: "login", sender: self)
                
            }
        
        } else if category == "Über diese App" {
            
            if (indexPath as NSIndexPath).row == 0 {
                
                //self.selectedRow = (cell.textLabel?.text)!
                performSegue(withIdentifier: "developerSegue", sender: self)
                
            }
            
        } else if (indexPath as NSIndexPath).section == 0 {
            
            if (indexPath as NSIndexPath).row == 1 {
                
                //
                
            }
            
            self.selectedRow = (cell.textLabel?.text)!
            performSegue(withIdentifier: "detail", sender: self)
            
        }
        */
    }
    
    // MARK: - Activity Indicator
    func startActivityIndicator() {
        
        view.addSubview(activityIndicator)
        //UIApplication.shared.beginIgnoringInteractionEvents()
        
    }
    
    func stopActivityIndicator() {
        
        //End Activity Indicator
        self.activityIndicator.stopAnimating()
        //UIApplication.shared.endIgnoringInteractionEvents()
        self.activityIndicator.removeViews()
        
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
