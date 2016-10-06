//
//  bistroMagusiiVC.swift
//  Zeneggen
//
//  Created by Benjamin Pfammatter on 05.07.16.
//  Copyright © 2016 Benjamin Pfammatter. All rights reserved.
//

import UIKit
import Firebase
import MessageUI

class bistroMagusiiVC: UITableViewController, MFMailComposeViewControllerDelegate {
    
    var sectionHeaders = ["Beschreibung"]
    var sectionCellType = ["descriptionCellUI"]
    
    var numberOfSections = 0
    var tableSourceCounter = 1
    
    var activityIndicator = activityIndicatorV()
    var cellsLoaded = false
    var headerLoaded = false
    
    var gradientMade = false
    
    //Firebase
    var ref: FIRDatabaseReference!
    var storage = FIRStorage.storage()
    
    var viewCategory: String = ""
    
    var bistroMorgenAuf = [String]()
    var bistroMorgenZu = [String]()
    var bistroNachmittagAuf = [String]()
    var bistroNachmittagZu = [String]()
    var bistroAbendAuf = [String]()
    var bistroAbendZu = [String]()
    
    var tableData = [String: [String]]()
    var tableImageData = [String: UIImage]()
    var tableImageDataLoaded = [String: Bool]()
    
    //main query
    var viewTitle = ""
    var viewDescription = ""
    var buttonNeeded = false
    var buttonNeeded2 = false
    var buttonIcon = ""
    var buttonIcon2 = ""
    var buttonSegue = ""
    var buttonSegue2 = ""
    var buttonSegueSource = ""
    var buttonSegueSource2 = ""
    
    //section 2 query
    //var detailsTitlesTableData = [String]()
    //var detailsTextsTableData = [String]()
    //var detailsImagesTableData = [UIImage(named: "icon-clock"), UIImage(named: "icon-clock"), UIImage(named: "icon-clock"), UIImage(named: "icon-clock"), UIImage(named: "icon-clock"), UIImage(named: "icon-clock"), UIImage(named: "icon-clock"), UIImage(named: "icon-clock"), UIImage(named: "icon-clock"), UIImage(named: "icon-clock")]
    var detailsImagesLoaded = false
    
    //Section 3 query
    //var detailsTitlesTableData2 = [String]()
    //var detailsTextsTableData2 = [String]()
    //var detailsImagesTableData2 = [UIImage(named: "icon-clock"), UIImage(named: "icon-clock"), UIImage(named: "icon-clock"), UIImage(named: "icon-clock"), UIImage(named: "icon-clock"), UIImage(named: "icon-clock"), UIImage(named: "icon-clock"), UIImage(named: "icon-clock"), UIImage(named: "icon-clock"), UIImage(named: "icon-clock")]
    var detailsImagesLoaded2 = false
    
    //button segues
    var selectedButton = Int()
    //var webUrl: NSURL = NSURL(string: "")!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addZeitenBarButton: UIBarButtonItem!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var ToOpeningTimesButton: standardButton!
    @IBOutlet weak var button2: standardButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startActivityIndicator()
        
        //Analytics
        //FIRAnalytics.logEventWithName("opened_category_\(viewCategory)", parameters: nil)
        FIRAnalytics.logEvent(withName: "category_open", parameters: [
            "name": viewCategory as NSObject])
        
        ref = FIRDatabase.database().reference()
        
        configureTableView()
        layoutOutlets()
        
        cellsLoaded = false
        headerLoaded = false
        
        getData()
        loadHeaderImage()
        
        var userSignedIn: Bool = false
        
        if viewCategory == "Bistro" {
            
            userSignedIn = externUniversalMethods().checkIfUserIsSignedIn()
            getOpenedOrClosed()
            
        }
        
        if  !userSignedIn {
            
            self.navigationItem.rightBarButtonItem = nil
            
        } else {
            
            self.navigationItem.rightBarButtonItem = addZeitenBarButton
            
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.headerView.frame.size.height = self.view.frame.width / 2
        
    }
    
    func layoutOutlets() {
        
        titleLabel.text = " "
        titleLabel.isHidden = true
        titleLabel.alpha = 0
        
        //7titleLabel.layer.shadowColor = UIColor.blackColor().CGColor
        //titleLabel.layer.shadowOffset = CGSizeMake(1, 1)
        //titleLabel.layer.shadowOpacity = 1.0
        //titleLabel.layer.shadowRadius = 2.0
        
        ToOpeningTimesButton.isHidden = true
        ToOpeningTimesButton.alpha = 0
        button2.isHidden = true
        button2.alpha = 0
        
    }
    
    func getData() {
        
        //gets called from viewDidLoad
        buttonNeeded = false
        buttonNeeded2 = false
        detailsImagesLoaded = false
        detailsImagesLoaded2 = false
        
        //This query loads the navigation bar title and the description in the first section - reloads the tableView
        let titleQuery = (ref.child("categories").child(viewCategory).child("de")).queryOrderedByKey()
        titleQuery.observeSingleEvent(of: .value, with: { snapshot in
            
            let data = snapshot.value as! [String : AnyObject]
            
            self.viewTitle = data["title"] as! String
            self.viewDescription = data["description"] as! String
            self.buttonNeeded = data["button"] as! Bool
            
            if self.buttonNeeded == true {
                
                self.buttonIcon = (data["buttonIcon"] as! String)
                self.buttonSegue = (data["buttonSegue"] as! String)
                self.buttonSegueSource = (data["buttonSegueSource"] as! String)
                
                self.buttonNeeded2 = data["button2"] as! Bool
                
                if self.buttonNeeded2 == true {
                    
                    self.buttonIcon2 = (data["buttonIcon2"] as! String)
                    self.buttonSegue2 = (data["buttonSegue2"] as! String)
                    self.buttonSegueSource2 = (data["buttonSegueSource2"] as! String)
                    
                }
                
            }
            
            self.navigationItem.title = self.viewTitle
            //self.tableView.reloadData()
            
        })
        
        //before appending remove all data
        //detailsTitlesTableData.removeAll()
        //detailsTextsTableData.removeAll()
        tableData.removeAll()
        
        //checking that a viewCategory has been passed from the previous view
        if viewCategory != "" {
            
            self.numberOfSections = 1
            self.tableSourceCounter = 1
            
            self.checkForMoreSections()
            
            
            //This query loads the titles and texts for the 2nd section and checks at the end if there are more sections to load
            let tableDataQuery = (ref.child("categories").child(viewCategory).child("de").child("table")).queryOrderedByKey()
            tableDataQuery.observeSingleEvent(of: .value, with: { snapshot in
                
                if !snapshot.exists() {
                    
                    print("BEN: No more items")
                    
                } else {
                    
                    let snapshotValues = (snapshot).value! as! NSDictionary
                    
                    var moreSections: Bool = false
                    
                    var titlesArrayForDict = [String]()
                    var textsArrayForDict = [String]()
                    
                    for child in snapshot.children {
                        
                        let key = (child as! FIRDataSnapshot).key
                        
                        //let data = (child as! FIRDataSnapshot).value! as! NSDictionary
                        
                        //print("BEN: \(data["title"] as! String)")
                        
                        if key != "more"  && key != "title" && key != "cellType" {
                            
                            let data = (child as! FIRDataSnapshot).value! as! NSDictionary
                            
                            titlesArrayForDict.append(data["title"]! as! String)
                            textsArrayForDict.append(data["text"]! as! String)
                            
                            //self.tableData["titles-section-1"]!.append(data["title"]! as! String)
                            //self.tableData["texts-section-1"]!.append(data["text"]! as! String)
                            
                            //are there more sections?!
                        } else if key == "more" {
                            
                            moreSections = snapshotValues["more"]! as! Bool
                            
                        }
                        
                    }
                    
                    self.tableData["titlesSection1"] = titlesArrayForDict
                    self.tableData["textsSection1"] = textsArrayForDict
                    
                    self.sectionHeaders.append(snapshotValues["title"]! as! String)
                    self.sectionCellType.append(snapshotValues["cellType"]! as! String)
                    
                    //redeclearing the correct count numbers
                    self.numberOfSections = 2
                    self.tableSourceCounter = 1
                    
                    if self.sectionCellType[self.tableSourceCounter] == "personCellUI" {
                        
                        self.loadCellImages(self.tableSourceCounter)
                        
                    }
                    
                    //if true it calls the checkForMoreSections method
                    if moreSections {
                        
                        self.tableView.reloadData()
                        self.tableSourceCounter = self.tableSourceCounter + 1
                        self.checkForMoreSections()
                        //self.tableSourceCounter += self.tableSourceCounter
                        
                    //if false it reloads and ends with loading data
                    } else {
                        
                        self.cellsLoaded = true
                        
                        if self.headerLoaded == true {
                            
                            self.tableView.reloadData()
                            
                            self.configureButton()
                            
                            self.activityIndicator.stopAnimating()
                            //UIApplication.shared.endIgnoringInteractionEvents()
                            self.activityIndicator.removeViews()
                            
                        }
                        
                        self.tableView.reloadData()
                        
                    }
                    
                }
                
            })
            
        }
        
    }
    
    func checkForMoreSections() {
        
        let tableDataQuery = (ref.child("categories").child(viewCategory).child("de").child("table-\(tableSourceCounter)")).queryOrderedByKey()
        tableDataQuery.observeSingleEvent(of: .value, with: { snapshot in
            
            
            
            if !snapshot.exists() {
                
                print("BEN: No more items")
                
            } else {
                
                let snapshotValues = (snapshot).value! as! NSDictionary
                
                var moreSections: Bool = false
                self.tableData["titlesSection\(self.tableSourceCounter)"] = [""]
                self.tableData["titlesSection\(self.tableSourceCounter)"]!.removeAll()
                self.tableData["textsSection\(self.tableSourceCounter)"] = [""]
                self.tableData["textsSection\(self.tableSourceCounter)"]!.removeAll()
                
                var titlesArrayForDict = [String]()
                var textsArrayForDict = [String]()
                
                for child in (snapshot.children) {
                    
                    let key = (child as! FIRDataSnapshot).key
                    
                    if key != "more" && key != "title" && key != "cellType" {
                        
                        let data = (child as! FIRDataSnapshot).value! as! NSDictionary
                        
                        titlesArrayForDict.append(data["title"]! as! String)
                        textsArrayForDict.append(data["text"]! as! String)
                        
                        //self.tableData["titlesSection\(self.tableSourceCounter)"]?.append(data["title"]! as! String)
                        //self.tableData["textsSection\(self.tableSourceCounter)"]?.append(data["text"]! as! String)
                        
                    } else if key == "more" {
                        
                         moreSections = snapshotValues["more"]! as! Bool
                        
                    }
                    
                }
                
                self.tableData["titlesSection\(self.tableSourceCounter)"] = titlesArrayForDict
                self.tableData["textsSection\(self.tableSourceCounter)"] = textsArrayForDict
                
                self.sectionHeaders.append(snapshotValues["title"]! as! String)
                self.sectionCellType.append(snapshotValues["cellType"]! as! String)
                
                if self.sectionCellType[self.tableSourceCounter] == "personCellUI" {
                    
                    self.loadCellImages(self.tableSourceCounter)
                    
                }
                
                self.numberOfSections = self.sectionHeaders.count
                
                if moreSections {
                    
                    //self.tableView.reloadData()
                    self.tableSourceCounter = self.tableSourceCounter + 1
                    self.checkForMoreSections()
                    
                } else {
                    
                    self.cellsLoaded = true
                    
                    if self.headerLoaded == true {
                        
                        self.tableView.reloadData()
                        
                        self.configureButton()
                        
                        self.activityIndicator.stopAnimating()
                        UIApplication.shared.endIgnoringInteractionEvents()
                        self.activityIndicator.removeViews()
                        
                    }
                    
                }
                
            }
            
        })
        
    }
    
    func loadCellImages(_ section: Int) {
        
        print("BEN: Load Cell Images For Section \(section)")
        
        let storageRef = storage.reference()
        
        //if section == 1 {
            
            //detailsImagesTableData.removeAll()
            var imageAdded = 0
            print("BEN: " + "\(tableData["titlesSection\(section)"])")
            for var i in 0...(tableData["titlesSection\(section)"]!.count - 1) {
                
                let imageRef = storageRef.child("categories/\(viewCategory)/table-\(section)/\(i).jpg")
                imageRef.data(withMaxSize: 1 * 500 * 500) { (data, error) -> Void in
                    if (error != nil) {
                        
                        print(error)
                        
                    } else {
                        
                        let key = "imageSection\(section)Row\(i)"
                        
                        self.tableImageData[key] = (UIImage(data: data!)!)
                        self.tableImageDataLoaded[key] = true
                        print("BEN: ")
                        if self.tableData["titlesSection\(section)"]!.count == imageAdded + 1 {
                            
                            self.detailsImagesLoaded = true
                            self.tableView.reloadData()
                            
                        } else {
                            //self.tableView.reloadData()
                            i = i + 1
                            imageAdded = imageAdded + 1
                            
                        }
                        
                    }
                    
                }
                
            }
            
        //} else if section == 2 {
            /*
            //detailsImagesTableData2.removeAll()
            var imageAdded = 0
            
            for var i in 0...(detailsTitlesTableData2.count - 1) {
                
                let imageRef = storageRef.child("categories/\(viewCategory)/table-2/\(i).jpg")
                imageRef.dataWithMaxSize(1 * 1024 * 1024) { (data, error) -> Void in
                    if (error != nil) {
                        
                        print(error)
                        
                    } else {
                        
                        self.detailsImagesTableData2[i] = (UIImage(data: data!)!)
                        print("BEN: imageAdded" + "\(imageAdded)")
                        print("BEN: count" + "\(self.detailsTitlesTableData2.count)")
                        print(i)
                        
                        if self.detailsTitlesTableData2.count == imageAdded + 1 {
                            
                            self.detailsImagesLoaded2 = true
                            self.tableView.reloadData()
                            
                        } else {
                            
                            i = i + 1
                            imageAdded = imageAdded + 1
                            
                        }
                        
                    }
                    
                }
                
            }
            */
        //}
        
    }
    
    func loadHeaderImage() {
        
        // Create a reference to the file you want to download
        let storageRef = storage.reference()
        
        let imageRef = storageRef.child("categories/\(viewCategory)/header.jpg")
        
        // Download in memory with a maximum allowed size of 1MB (1 * 1080 * 540 bytes)
        imageRef.data(withMaxSize: 1 * 1080 * 540) { (data, error) -> Void in
            if (error != nil) {
                
                print("FIR: " + "\(error)")
                
            } else {
                // Data for "images/island.jpg" is returned
                // ... let islandImage: UIImage! = UIImage(data: data!)
                self.headerImage.image = UIImage(data: data!)!
                
                if self.gradientMade == false {
                    
                    let gradient: CAGradientLayer = CAGradientLayer()
                    gradient.frame = CGRect(x: 0, y: self.headerImage.center.y + 25, width: self.headerImage.frame.width, height: (self.headerImage.frame.height / 2) - 25)
                    gradient.colors = [UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor, UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor]
                    self.headerImage.layer.insertSublayer(gradient, at: 0)
                    
                    self.gradientMade = true
                    
                }
                
                self.headerLoaded = true
                
                if self.cellsLoaded == true {
                    
                    self.tableView.reloadData()
                    
                    self.configureButton()
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    self.activityIndicator.removeViews()
                    
                }
                
                
            }
            
        }
        
        
    }
    
    func configureButton() {
        
        titleLabel.isHidden = false
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.titleLabel.alpha = 1
            
        })
        
        
        if buttonNeeded {
            
            self.ToOpeningTimesButton.setImage(UIImage(named: buttonIcon), for: UIControlState())
            self.ToOpeningTimesButton.tintColor = buttonWhiteColor
            self.ToOpeningTimesButton.isHidden = false
            
            UIView.animate(withDuration: 0.3, animations: {
                
                self.ToOpeningTimesButton.alpha = 1
                
            })
            
        } else {
            
            UIView.animate(withDuration: 0.3, animations: {
                
                self.ToOpeningTimesButton.alpha = 0
                
            }, completion: {
                (value: Bool) in
                    
                self.ToOpeningTimesButton.isHidden = true
                    
            })
            
        }
        
        if buttonNeeded2 {
            
            self.button2.setImage(UIImage(named: buttonIcon2), for: UIControlState())
            self.button2.tintColor = buttonWhiteColor
            self.button2.isHidden = false
            
            UIView.animate(withDuration: 0.3, animations: {
                
                self.button2.alpha = 1
                
            })
            
        } else {
            
            UIView.animate(withDuration: 0.3, animations: {
                
                self.button2.alpha = 0
                
                }, completion: {
                    (value: Bool) in
                    
                    self.button2.isHidden = true
                    
            })
            
        }
        
    }
    
    func getOpenedOrClosed() {
        
        let weekdayObject = externUniversalMethods()
        let hour = weekdayObject.getCurrentHour()
        let minutes = weekdayObject.getCurrentMinutes()
        let minutesInDec: Double = Double(minutes!)/60.0
        let weekday = weekdayObject.getCurrentDayOfWeek()!
        let doubleHourMinute: Double = minutesInDec + Double(hour!)
        
        ref.child("categories").child("Bistro").child("de").child(String(weekday)).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let snapshotValues = (snapshot).value! as! NSDictionary
            
            if  (doubleHourMinute >= snapshotValues["a-morgen-auf"]! as! Double &&
                doubleHourMinute <= snapshotValues["a-morgen-zu"]! as! Double) ||
                (doubleHourMinute >= snapshotValues["b-nachmittag-auf"]! as! Double &&
                    doubleHourMinute <= snapshotValues["b-nachmittag-zu"] as! Double) ||
                (doubleHourMinute >= snapshotValues["c-abend-auf"]! as! Double &&
                    doubleHourMinute <= snapshotValues["c-abend-zu"]! as! Double) {
                
                self.titleLabel.text = "Jetzt geöffnet"
                //self.titleLabel.textColor = mainColor
                
            } else {
                
                self.titleLabel.text = "Geschlossen"
                //self.titleLabel.textColor = secondaryColor
                
            }
            
        }) { (error) in
            
            print("FIR: " + "\(error.localizedDescription)")
            self.titleLabel.text = error.localizedDescription
            self.titleLabel.textColor = UIColor.orange
            
        }

        
    }
    
    @IBAction func toOpeningTimesButton(_ sender: AnyObject) {
        
        selectedButton = 1
        
        if buttonSegue == "mail" {
            
            setUpMailC(recipient: buttonSegueSource)
            
        } else { //web
            
            var url = buttonSegueSource
            
            if buttonSegue == "facebook" {
                
                url = "fb://profile/\(buttonSegueSource)/"
                
                if UIApplication.shared.openURL(URL(string: url)!) {
                    
                    UIApplication.shared.openURL(URL(string: url)!)
                    
                } else {
                    
                    url = "https://www.facebook.com/\(buttonSegueSource)/"
                    openSafari(url: url)
                    
                }
                
            } else if buttonSegue == "phone" {
                
                url = "tel://\(buttonSegueSource)"
                openSafari(url: url)
                
            } else {
                
                openSafari(url: url)
                
            }
            
        }

        
    }
    
    func openSafari(url: String) {
        
        UIApplication.shared.openURL(URL(string: url)!)
        
    }
    
    @IBAction func button2(_ sender: AnyObject) {
        
        if buttonSegue2 == "mail" {
            
            setUpMailC(recipient: buttonSegueSource2)
            
        } else {
            
            var url = buttonSegueSource2
            
            if buttonSegue2 == "phone" {
                
                url = "tel://\(buttonSegueSource2)"
                
            }
            
            selectedButton = 2
            UIApplication.shared.openURL(URL(string: url)!)
            //self.performSegue(withIdentifier: buttonSegue, sender: self)
            
        }
        
    }
    
    func setUpMailC(recipient: String) {
        
        if MFMailComposeViewController.canSendMail() {
            
            let subject = "\(self.viewCategory) - Kontakt über Zeneggen App"
            let toRecipients = [recipient]
            
            let mailController: MFMailComposeViewController = MFMailComposeViewController()
            
            mailController.navigationBar.barTintColor = mainColor
            mailController.view.tintColor = secondaryBlackOnWhiteBackground
            mailController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: blackOnWhiteBackground]
            mailController.mailComposeDelegate = self
            mailController.setSubject(subject)
            mailController.setMessageBody(  "\n" +
                "\n" +
                "---\n" +
                " " + self.appVersion() + " (" + self.deviceLanguage() + ")\n" +
                self.iPhoneDevice() + " (" + self.iOSVersion() + ")", isHTML: false)
            mailController.setToRecipients(toRecipients)
            
            self.present(mailController, animated: true, completion: nil)
            
        } else {
            
            self.displayNoMailAccountAlert( "Kein Mail Account Gefunden", error: "Du kannst einen Mail Account in den Einstellungen hinzufügen um Mails von deinem \(self.iPhoneDevice()) senden zu können: \n" +
                "Einstellungen -> Mail -> Account hinzufügen")
            
        }
        
    }
    
    // MARK: - Activity Indicator
    func startActivityIndicator() {
        
        view.addSubview(activityIndicator)
        //UIApplication.shared.beginIgnoringInteractionEvents()
        
    }
    
    func configureTableView() {
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44.0
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var numberOfRows = [1]
        
        for i in 1...numberOfSections {
            
            if tableData["titlesSection\(i)"]?.count != nil {
                
                print("BEN-NOW: \(tableData["titlesSection\(i)"])")
                numberOfRows.append(tableData["titlesSection\(i)"]!.count)
                
            }
            
            print("BEN: \(numberOfRows)")
            
        }
        
        
        //let numberOfRows = [1, tableData["titlesSection1"]?.count, tableData["titlesSection2"]?.count, tableData["titlesSection3"]?.count, tableData["titlesSection4"]?.count]
        return numberOfRows[section]
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSections
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionHeaders[section]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellType = sectionCellType[(indexPath as NSIndexPath).section]
        
        if cellType == "descriptionCellUI" {
            
            let cell = self.tableView.dequeueReusableCell(withIdentifier: cellType)!
            
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.text = self.viewDescription
            
            return cell
            
        } else if cellType == "detailCellUI" {
            
            let cell: detailTableCell = self.tableView.dequeueReusableCell(withIdentifier: cellType)! as! detailTableCell
            
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.detailLabel.numberOfLines = 0
            
            let titles = tableData["titlesSection\((indexPath as NSIndexPath).section)"]!
            let texts = tableData["textsSection\((indexPath as NSIndexPath).section)"]!
            
            cell.titleLabel.text = titles[(indexPath as NSIndexPath).row]
            cell.detailLabel.text = texts[(indexPath as NSIndexPath).row]
            
            /*
             if indexPath.section == 1 {
             
             cell.titleLabel.text = detailsTitlesTableData[indexPath.row]
             cell.detailLabel.text = detailsTextsTableData[indexPath.row]
             
             } else {
             
             cell.titleLabel.text = detailsTitlesTableData2[indexPath.row]
             cell.detailLabel.text = detailsTextsTableData2[indexPath.row]
             
             }
             */
            return cell
            
        } else {
            
            let cell: personDetailTVCell = self.tableView.dequeueReusableCell(withIdentifier: cellType)! as! personDetailTVCell
            
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.detailLabel.numberOfLines = 0
            
            print(tableData["textsSection1"]!)
            print((indexPath as NSIndexPath).section)
            let titles = tableData["titlesSection\((indexPath as NSIndexPath).section)"]!
            let texts = tableData["textsSection\((indexPath as NSIndexPath).section)"]!
            
            
            cell.titleLabel.text = titles[(indexPath as NSIndexPath).row]
            cell.detailLabel.text = texts[(indexPath as NSIndexPath).row]
            
            
            let key = "imageSection\((indexPath as NSIndexPath).section)Row\((indexPath as NSIndexPath).row)"
            
            if tableImageDataLoaded[key] == true {
                
                cell.photoImageView.image = tableImageData[key]
                
            }
            
            //if det
            
            /*
             if indexPath.section == 1 {
             
             cell.titleLabel.text = detailsTitlesTableData[indexPath.row]
             cell.detailLabel.text = detailsTextsTableData[indexPath.row]
             
             if detailsImagesLoaded == true {
             
             cell.photoImageView.image = detailsImagesTableData[indexPath.row]
             
             }
             
             } else {
             
             cell.titleLabel.text = detailsTitlesTableData2[indexPath.row]
             cell.detailLabel.text = detailsTextsTableData2[indexPath.row]
             
             if detailsImagesLoaded2 == true {
             
             cell.photoImageView.image = detailsImagesTableData2[indexPath.row]
             
             }
             
             }
             */
            return cell
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "web" {
            
            var webUrl: URL = URL(string: "http://google.ch")!
            
            if selectedButton == 1 {
                
                webUrl = URL(string: buttonSegueSource)!
                
            } else {
                
                webUrl = URL(string: buttonSegueSource2)!
                
            }
            
            let controller = (segue.destination as! UINavigationController).topViewController as! webStandardVC
            controller.urlReceived = webUrl
            controller.viewCategory = viewCategory
            
        }
        
    }
    
    var mailTitle = "ERROR"
    var mailError = "Error message"
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        mailTitle = "ERROR"
        mailError = "Error message"
        
        switch result.rawValue {
            
        case MFMailComposeResult.cancelled.rawValue:
            
            print("Mail Draft Canceled And Not Saved")
            
        case MFMailComposeResult.saved.rawValue:
            
            mailTitle = "Gesichert"
            mailError = "Deine Mail wurde erfolgreich in den Entwürfen gesichert."
            
            _ = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(bistroMagusiiVC().mailAlert), userInfo: nil, repeats: false)
            
        case MFMailComposeResult.sent.rawValue:
            
            mailTitle = "Gesendet"
            mailError = "Deine Mail wurde erfolgreich gesendet. Wir werden uns schnellstmöglich mit dir in Verbindung setzen."
            
            _ = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(bistroMagusiiVC().mailAlert), userInfo: nil, repeats: false)
            
        case MFMailComposeResult.failed.rawValue:
            
            mailTitle = "Fehlgeschlagen"
            mailError =     "Deine Mail konnte leider nicht gesendet werden. Versuche es später nochmal. \n" +
            "Falls du keine Verbindung zum Internet hast versuche es dann wenn du wieder verbunden bist."
            
            _ = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(bistroMagusiiVC().mailAlert), userInfo: nil, repeats: false)
            
        default:
            break
            
        }
        
        self.dismiss(animated: false, completion: nil)
        
    }
    
    func mailAlert() {
        
        self.displayErrorAlert( mailTitle, error: mailError)
        
    }
    
    //controlls display Alerts
    func displayErrorAlert(_ title:String, error:String) {
        
        let alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.alert)
        alert.view.tintColor = secondaryColor
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            
            self.dismiss(animated: true, completion: nil)
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    //controlls display Alerts
    func displayNoMailAccountAlert(_ title:String, error:String) {
        
        let alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.alert)
        alert.view.tintColor = secondaryColor
        
        alert.addAction(UIAlertAction(title: "Einstellungen", style: .default, handler: { action in
            
            let settingsUrl = URL(string: UIApplicationOpenSettingsURLString)
            if let url = settingsUrl {
                
                UIApplication.shared.openURL(url)
                
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            
            self.dismiss(animated: true, completion: nil)
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func appVersion() -> String {
        
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        
    }
    
    func iPhoneDevice() -> String {
        
        return UIDevice.current.model as String
        
    }
    
    func iOSVersion() -> String {
        
        return UIDevice.current.systemVersion as String
        
    }
    
    func deviceLanguage() -> String {
        
        return Bundle.main.preferredLocalizations[0]
        
    }
    /*
    func buttonOffset(offset: CGFloat) {
        
        var frame: CGRect = ToOpeningTimesButton.frame
        frame.origin.y = offset
        ToOpeningTimesButton.frame = frame
        
        var frame2: CGRect = button2.frame
        frame2.origin.y = offset
        button2.frame = frame2
        
        view.bringSubview(toFront: ToOpeningTimesButton)
        view.bringSubview(toFront: button2)
        
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView){
        
        let offset = scrollView.contentOffset.y + self.view.frame.height - ToOpeningTimesButton.frame.height - 10
        
        buttonOffset(offset: offset)
        
    }
    */
}
