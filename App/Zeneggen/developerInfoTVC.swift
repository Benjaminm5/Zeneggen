//
//  developerInfoTVC.swift
//  Zeneggen
//
//  Created by Benjamin Pfammatter on 20.09.16.
//  Copyright © 2016 Benjamin Pfammatter. All rights reserved.
//

import UIKit
import Firebase

class developerInfoTVC: UITableViewController {
    
    //Firebase
    var ref: FIRDatabaseReference!
    var storage = FIRStorage.storage()
    
    //set up activity indicator
    var activityIndicator = activityIndicatorV()
    
    var name = String()
    var surname = String()
    var titleWork = String()
    var age = Int()
    var portrait = UIImage()
    var landscape = UIImage()
    
    var tableData = [String: [String]]()
    var tableSectionTitles = [String]()
    
    var user = "Developer"
    
    var image = UIImage()
    
    var sectionsInTableView = 0
    var rowsPerSection = [Int]()
    
    var sectionCounter = 0
    
    //HEADER
    @IBOutlet weak var portraitImageV: UIImageView!
    @IBOutlet weak var landscapeImageV: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutViews()
        configureTableView()
        
        startActivityIndicator()
        
        getFirbaseData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func layoutViews() {
        
        nameLabel.textColor = blackOnWhiteBackground
        titleLabel.textColor = secondaryBlackOnWhiteBackground
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.headerView.frame.size.height = self.view.frame.width / 2
    }
    
    func configureTableView() {
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44.0
        
    }
    
    func getTableData() {
        
        ref = FIRDatabase.database().reference()
        
        ref.child("users").child(user).child("dataSection\(sectionCounter)").observeSingleEvent(of: .value, with: { (snapshot: FIRDataSnapshot) in
            // Get user value
            
            let data = snapshot.value as! [String : AnyObject]
            
            self.tableSectionTitles.append(data["sectionTitle"] as! String)
            
            var titlesArrayForDict = [String]()
            var valuesArrayForDict = [String]()
            
            for index in 0...self.rowsPerSection[self.sectionCounter] - 1 {
                print("BEN: \(index)")
                if data["title\(index)"] as! String == "Alter" {
                    
                    let birthYear = data["value\(index)"] as! Int
                    
                    let weekdayObject = externUniversalMethods()
                    let year = weekdayObject.getCurrentYear()
                    
                    self.age = year! - birthYear
                    
                    titlesArrayForDict.append(data["title\(index)"] as! String)
                    valuesArrayForDict.append(String(year! - birthYear))
                    
                } else {
                    
                    titlesArrayForDict.append(data["title\(index)"] as! String)
                    valuesArrayForDict.append(data["value\(index)"] as! String)
                    
                }
                
            }
            
            self.tableData["titlesSection\(self.sectionCounter)"] = titlesArrayForDict
            self.tableData["valuesSection\(self.sectionCounter)"] = valuesArrayForDict
            
            self.sectionCounter = self.sectionCounter + 1
            
            self.tableView.reloadData()
            
            if self.sectionCounter < self.sectionsInTableView {
                
                self.getTableData()
                
            }
            /*
            
            */
            
        }) { (error) in
            
            print(error.localizedDescription)
            
        }
        
    }
    
    func getFirbaseData() {
        
        ref = FIRDatabase.database().reference()
        
        ref.child("users").child(user).observeSingleEvent(of: .value, with: { (snapshot: FIRDataSnapshot) in
            // Get user value
            
            let data = snapshot.value as! [String : AnyObject]
            
            self.name = data["name"] as! String
            self.surname = data["surname"] as! String
            self.titleWork = data["title"] as! String
            self.sectionsInTableView = data["sections"] as! Int
            
            self.rowsPerSection.removeAll()
            
            for index in 0...self.sectionsInTableView - 1 {
                
                self.rowsPerSection.append(data["rowsSection\(index)"] as! Int)
                
            }
            
            self.sectionCounter = 0
            self.tableData.removeAll()
            self.tableSectionTitles.removeAll()
            self.getTableData()
            
            self.nameLabel.text = self.surname + " " + self.name
            self.titleLabel.text = self.titleWork
            
            self.getPortait()
            
        }) { (error) in
            
            print(error.localizedDescription)
            
        }
        
    }
    
    func getPortait() {
        
        // Create a reference to the file you want to download
        let storageRef = storage.reference()
        
        let imageRef = storageRef.child("users/\(user)/portrait.jpg")
        
        // Download in memory with a maximum allowed size of 1MB (1 * 1080 * 540 bytes)
        imageRef.data(withMaxSize: 1 * 1024 * 1024) { (data, error) -> Void in
            if (error != nil) {
                
                print("BEN - FIR: " + "\(error)")
                
            } else {
                // Data for "images/island.jpg" is returned
                // ... let islandImage: UIImage! = UIImage(data: data!)
                self.portrait = UIImage(data: data!)!
                self.portraitImageV.image = self.portrait
                self.portraitImageV.layer.masksToBounds = true
                self.portraitImageV.layer.cornerRadius = self.portraitImageV.frame.size.height / 2
                
                self.getLandscape()
                
            }
            
        }
        
    }
    
    func getLandscape() {
        
        // Create a reference to the file you want to download
        let storageRef = storage.reference()
        
        let imageRef = storageRef.child("users/\(user)/landscape.jpg")
        
        // Download in memory with a maximum allowed size of 1MB (1 * 1080 * 540 bytes)
        imageRef.data(withMaxSize: 1 * 1024 * 1024) { (data, error) -> Void in
            if (error != nil) {
                
                print("BEN - FIR: " + "\(error)")
                
            } else {
                // Data for "images/island.jpg" is returned
                // ... let islandImage: UIImage! = UIImage(data: data!)
                self.landscape = UIImage(data: data!)!
                self.landscapeImageV.image = self.landscape
                self.landscapeImageV.layer.masksToBounds = true
                
                //Blur Effect
                let blur: UIBlurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
                let blurView: UIVisualEffectView = UIVisualEffectView(effect: blur)
                blurView.frame = self.landscapeImageV.bounds
                blurView.alpha = 1
                self.landscapeImageV.addSubview(blurView)
                
                self.tableView.reloadData()
                
                self.activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
                self.activityIndicator.removeViews()
                
            }
            
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sectionCounter
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableSectionTitles[section]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return rowsPerSection[section]
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "normalCellUI", for: indexPath)
        
        let titlesSection = tableData["titlesSection\(indexPath.section)"]
        let valuesSection = tableData["valuesSection\(indexPath.section)"]
        
        cell.textLabel?.text = titlesSection?[indexPath.row]
        cell.detailTextLabel?.text = valuesSection?[indexPath.row]
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Activity Indicator
    func startActivityIndicator() {
        
        view.addSubview(activityIndicator)
        //UIApplication.shared.beginIgnoringInteractionEvents()
        
    }

}
