//
//  aktuellesTVC.swift
//  Zeneggen
//
//  Created by Benjamin Pfammatter on 12.06.16.
//  Copyright © 2016 Benjamin Pfammatter. All rights reserved.
//

import UIKit
import Firebase

class aktuellesTVC: UITableViewController {
    
    var viewCategory: String = ""
    
    var ref: FIRDatabaseReference!
    var storage = FIRStorage.storage()
    
    var titleTableData = [String]()
    var textTableData = [String]()
    var authorRef = [String]()
    var authorTableData = [String]()
    var imageTableData = [UIImage]()
    var postKeys = [String]()
    var dateTableData = [String]()
    
    var dataLoaded = false
    var imagesLoaded = false
    
    //HEADER
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    
    //set up activity indicator
    var activityIndicator = activityIndicatorV()
    
    @IBOutlet weak var addNewsBarButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        
        headerView.alpha = 0
        headerView.isHidden = true
        headerView.backgroundColor = secondaryColor
        headerLabel.textColor = UIColor.white
        
        let userSignedIn: Bool = externUniversalMethods().checkIfUserIsSignedIn()
        if  !userSignedIn {
            
            self.navigationItem.rightBarButtonItem = nil
            
        } else {
            
            self.navigationItem.rightBarButtonItem = addNewsBarButtonItem
            
        }
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        startActivityIndicator()
        
        configureTableView()
        
        ref = FIRDatabase.database().reference()
        
        loadNews()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if "showAuthorSegue" == segue.identifier {
            if let button = sender as? UIButton {
                
                let userKey = authorRef[button.tag]
                let controller = (segue.destination as! UINavigationController).topViewController as! developerInfoTVC
                controller.user = userKey
                
            }
        }
        
    }
    
    func authorSegue(sender: AnyObject!) {
        
        self.performSegue(withIdentifier: "showAuthorSegue", sender: self)
        
    }
    
    func loadNews() {
        
        dataLoaded = false
        imagesLoaded = false
        
        titleTableData.removeAll()
        textTableData.removeAll()
        postKeys.removeAll()
        dateTableData.removeAll()
        authorRef.removeAll()
        
        //get items query
        let newsQuery = (ref.child("categories").child("Aktuelles").child("de")).queryOrdered(byChild: "date")
        newsQuery.observeSingleEvent(of: .value, with: { snapshot in
            
            for child in snapshot.children {
                
                let data = (child as! FIRDataSnapshot).value! as! NSDictionary
                
                self.titleTableData.append(data["title"]! as! String)
                self.textTableData.append(data["text"]! as! String)
                self.postKeys.append(data["key"]! as! String)
                self.dateTableData.append(data["date"]! as! String)
                self.authorRef.append(data["author"]! as! String)
                
                /*
 var titleTableDataAscending = [String]()
 var textTableDataAscending = [String]()
 var authorRefAscending = [String]()
 var postKeysAscending = [String]()
 var dateTableDataAscending = [String]()
 
 titleTableDataAscending.append(data["title"]! as! String)
 textTableDataAscending.append(data["text"]! as! String)
 postKeysAscending.append(data["key"]! as! String)
 dateTableDataAscending.append(data["date"]! as! String)
 authorRefAscending.append(data["author"]! as! String)
 
 self.titleTableData = titleTableDataAscending.reversed()
 self.textTableData = textTableDataAscending.reversed()
 self.postKeys = postKeysAscending.reversed()
 self.dateTableData = dateTableDataAscending.reversed()
 self.authorRef = authorRefAscending.reversed()
                */
 
            }
 
            self.authorData()
            self.loadimages()
 
        })
 
    }
 
    func authorData() {
 
        authorTableData.removeAll()
 
        if authorRef.count > 0 {
            
            for index in 0...authorRef.count - 1 {
                
                let authorQuery = (ref.child("users").child("\(authorRef[index])"))
                authorQuery.observeSingleEvent(of: .value, with: { snapshot in
                    
                    let data = snapshot.value as! [String: AnyObject]
                    
                    let authorName = data["name"] as! String
                    let authorSurname = data["surname"] as! String
                    self.authorTableData.append(authorSurname + " " + authorName)
                    
                    self.dataLoaded = true
                    
                    if self.imagesLoaded == true {
                        
                        self.tableView.reloadData()
                        
                        //End Activity Indicator
                        self.activityIndicator.stopAnimating()
                        //UIApplication.shared.endIgnoringInteractionEvents()
                        self.activityIndicator.removeViews()
                        
                    }
                    
                })
                
            }
            
        } else {
            
            headerView.alpha = 1
            headerLabel.text = "Zurzeit gibts nichts Aktuelles"
            headerView.isHidden = false
            
            self.tableView.reloadData()
            
            //End Activity Indicator
            self.activityIndicator.stopAnimating()
            //UIApplication.shared.endIgnoringInteractionEvents()
            self.activityIndicator.removeViews()
            
        }
        
    }
    
    func loadimages() {
        
        //get images query
        let storageRef = storage.reference()
        // Create a reference to the file you want to download
        imageTableData.removeAll()
        
        if postKeys.count > 0 {
            
            for var i in 0...(postKeys.count - 1) {
                
                let imageRef = storageRef.child("categories/Aktuelles/de/\(postKeys[i])/postimage.jpg")
                // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
                imageRef.data(withMaxSize: 1 * 4096 * 4096) { (data, error) -> Void in
                    if (error != nil) {
                        // Uh-oh, an error occurred!
                        
                        print(error)
                        
                    } else {
                        // Data for "images/island.jpg" is returned
                        // ... let islandImage: UIImage! = UIImage(data: data!)
                        self.imageTableData.append(UIImage(data: data!)!)
                        
                        if self.imageTableData.count == (self.postKeys.count) {
                            
                            self.imagesLoaded = true
                            
                            if self.dataLoaded == true {
                                
                                self.tableView.reloadData()
                                
                                //End Activity Indicator
                                self.activityIndicator.stopAnimating()
                                //UIApplication.shared.endIgnoringInteractionEvents()
                                self.activityIndicator.removeViews()
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
                i += 1
                
            }
            
        }
        
    }
    
    func configureTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 330.0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleTableData.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: aktuellesCell = self.tableView.dequeueReusableCell(withIdentifier: "aktuellesCellUI")! as! aktuellesCell
        
        cell.titleLabel.text = self.titleTableData[(indexPath as NSIndexPath).row]
        cell.textsLabel.text = self.textTableData[(indexPath as NSIndexPath).row]
        cell.dateLabel.text = self.dateTableData[(indexPath as NSIndexPath).row]
        cell.authorButton.setTitle(self.authorTableData[(indexPath as NSIndexPath).row], for: .normal)
        cell.authorKey = self.authorRef[(indexPath as NSIndexPath).row]
        cell.authorButton.tag = indexPath.row
        
        cell.postImage.layer.masksToBounds = true
        //cell.postImage.layer.cornerRadius = 8
        cell.postImage.image = self.imageTableData[(indexPath as NSIndexPath).row]
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    // MARK: - Activity Indicator
    func startActivityIndicator() {
        
        view.addSubview(activityIndicator)
        //UIApplication.shared.beginIgnoringInteractionEvents()
        
    }
    
}
