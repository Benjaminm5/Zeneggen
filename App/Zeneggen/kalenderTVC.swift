//
//  kalenderTVC.swift
//  Zeneggen
//
//  Created by Benjamin Pfammatter on 21.06.16.
//  Copyright © 2016 Benjamin Pfammatter. All rights reserved.
//

import UIKit
import Firebase

class kalenderTVC: UITableViewController {
    
    var viewCategory: String = ""
    
    var ref: FIRDatabaseReference!
    
    //TableView Data
    var titleTableData = [Int: [String]]()
    var dateTableData = [Int: [String]]()
    var disclosureData = [Int: [Bool]]()
    var months = [String]()
    //Cound Month for getDaysData() func
    var countDaysDataQuery = 0
    
    //set up activity indicator
    var activityIndicator = activityIndicatorV()
    
    override func viewDidLoad() {
        
        print(self.view.subviews)
        
        startActivityIndicator()
        
        configureTableView()
        
        ref = FIRDatabase.database().reference()
        
        ref.child("categories").child("Kalender").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let data = snapshot.value as! [String: AnyObject]
            
            let navigationTitle = data["title"] as! String
            //let navigationTitle = snapshot.value!["title"] as! String
            
            self.navigationController!.navigationBar.topItem!.title = navigationTitle
            
        }) { (error) in
            
            print(error.localizedDescription)
            self.navigationController!.navigationBar.topItem!.title = "Kalender"
            
        }
        
        titleTableData.removeAll()
        dateTableData.removeAll()
        months.removeAll()
        
        //get months query
        let monthsQuery = (ref.child("categories").child("Kalender").child("de")).queryOrderedByKey()
        monthsQuery.observeSingleEvent(of: .value, with: { snapshot in
            
            for child in (snapshot.children) {
                
                let data = (child as! FIRDataSnapshot).value! as! NSDictionary
                
                self.months.append(data["title"]! as! String)
                //self.months.append((item as AnyObject).value!["title"] as! String)
                
            }
            
            self.getDaysData()
            
        })
        
    }
    
    func getDaysData() {
        
        let daysQuery = (ref.child("categories").child("Kalender").child("de").child("\(countDaysDataQuery)")).queryOrderedByKey()
        
        //var rowsCount = 0
        var monthDataTitle = [String]()
        var monthDataDate = [String]()
        var monthDataDisclosure = [Bool]()
        
        daysQuery.observeSingleEvent(of: .value, with: { snapshot in
            for child in (snapshot.children) {
                
                let key = (child as! FIRDataSnapshot).key
                
                if key != "title" {
                    
                    let data = (child as! FIRDataSnapshot).value! as! NSDictionary
                    
                    monthDataTitle.append(data["title"]! as! String)
                    monthDataDate.append(String(data["date"]! as! Int))
                    monthDataDisclosure.append(data["disclosure"]! as! Bool)
                    
                } else {
                    
                    print("No Item, it's a title")
                    
                }
                
            }
            
            self.titleTableData[self.countDaysDataQuery] = monthDataTitle
            self.dateTableData[self.countDaysDataQuery] = monthDataDate
            self.disclosureData[self.countDaysDataQuery] = monthDataDisclosure
            
            monthDataTitle.removeAll()
            monthDataDate.removeAll()
            monthDataDisclosure.removeAll()
            
            if self.countDaysDataQuery == self.months.count-1 {
                
                self.countDaysDataQuery = 0
                
                self.tableView.reloadData()
                
                //End Activity Indicator
                self.activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
                self.activityIndicator.removeViews()
                
            } else {
                
                self.countDaysDataQuery += 1
                self.getDaysData()
                
            }
            
        })
        
    }
    
    func configureTableView() {
        //tableView.rowHeight = UITableViewAutomaticDimension
        //tableView.estimatedRowHeight = 44.0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (titleTableData[section]?.count)!
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return months[section]
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return months.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "kalenderCellUI")!
        
        let monthFilteredTitleTableData = self.titleTableData[(indexPath as NSIndexPath).section]
        let monthFilteredDateTableData = self.dateTableData[(indexPath as NSIndexPath).section]
        let monthFilteredDisclosureTableData = self.disclosureData[(indexPath as NSIndexPath).section]
        
        cell.detailTextLabel!.text = monthFilteredTitleTableData![(indexPath as NSIndexPath).row]
        cell.textLabel!.text = monthFilteredDateTableData![(indexPath as NSIndexPath).row]
        
        //Disclosure?!
        if monthFilteredDisclosureTableData![(indexPath as NSIndexPath).row] {
            
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            
        } else {
            
            cell.accessoryType = UITableViewCellAccessoryType.none
            
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
        
    }
    
    // MARK: - Activity Indicator
    func startActivityIndicator() {
        
        view.addSubview(activityIndicator)
        UIApplication.shared.beginIgnoringInteractionEvents()
        
    }
    
}
