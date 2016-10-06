//
//  externUniversalMethods.swift
//  Zeneggen
//
//  Created by Benjamin Pfammatter on 04.07.16.
//  Copyright © 2016 Benjamin Pfammatter. All rights reserved.
//

import UIKit
import Firebase
import MapKit
import Contacts

class externUniversalMethods: NSObject {
    
    func getCurrenDate() -> String {
        
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm - d. MMM yyyy"
        let formattedDate = formatter.string(from: currentDateTime)
        
        return formattedDate
        
    }
    
    func getDayOfWeek(_ today:String)->Int? {
        
        let formatter  = DateFormatter()
        formatter.dateFormat = "HH:mm - d. MMM yyyy"
        if let todayDate = formatter.date(from: today) {
            let myCalendar = Calendar(identifier: Calendar.Identifier.gregorian)
            let myComponents = (myCalendar as NSCalendar).components(.weekday, from: todayDate)
            let weekDay = myComponents.weekday
            return weekDay
        } else {
            return nil
        }
        
    }
    
    func getCurrentDayOfWeek() -> Int? {
        
        let currentDate = getCurrenDate()
        
        let formatter  = DateFormatter()
        formatter.dateFormat = "HH:mm - d. MMM yyyy"
        if let todayDate = formatter.date(from: currentDate) {
            let myCalendar = Calendar(identifier: Calendar.Identifier.gregorian)
            let myComponents = (myCalendar as NSCalendar).components(.weekday, from: todayDate)
            let weekDay = myComponents.weekday
            return weekDay
        } else {
            return nil
        }
        
    }
    
    func getCurrentYear() -> Int? {
        
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        let formattedDate = formatter.string(from: currentDateTime)
        
        return Int(formattedDate)
        
    }
    
    func getCurrentHour() -> Int? {
        
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "H"
        let formattedDate = formatter.string(from: currentDateTime)
        
        return Int(formattedDate)
        
    }
    
    func getCurrentMinutes() -> Int? {
        
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "m"
        let formattedDate = formatter.string(from: currentDateTime)
        
        return Int(formattedDate)
        
    }
    
    func checkIfUserIsSignedIn() -> Bool {
        
        if FIRAuth.auth()?.currentUser?.email == nil {
            
            return false
            
        } else {
            
            return true
            
        }
        
    }
    
    func goToMapWithDirections(lat: Double, lon: Double, title: String){
        
        let latitude: CLLocationDegrees =  lat
        let longitude: CLLocationDegrees =  lon
        
        let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        
        let placemark : MKPlacemark = MKPlacemark(coordinate: coordinate, addressDictionary:nil)
        
        let mapItem:MKMapItem = MKMapItem(placemark: placemark)
        
        mapItem.name = title
        
        let launchOptions:NSDictionary = NSDictionary(object: MKLaunchOptionsDirectionsModeDriving, forKey: MKLaunchOptionsDirectionsModeKey as NSCopying)
        
        let currentLocationMapItem:MKMapItem = MKMapItem.forCurrentLocation()
        
        MKMapItem.openMaps(with: [currentLocationMapItem, mapItem], launchOptions: launchOptions as? [String : Any])
        
    }
    
    func goToMapWithLocation(lat: Double, lon: Double, title: String, url: String, phone: String?){
        
        let latitude: CLLocationDegrees =  lat
        let longitude: CLLocationDegrees =  lon
        
        let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        
        let placemark : MKPlacemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
        
        let mapItem:MKMapItem = MKMapItem(placemark: placemark)
        
        mapItem.name = title
        if url != "" {
            mapItem.url = URL(string: url)
        } else {
            mapItem.url = nil
        }
        if phone != "" {
            mapItem.phoneNumber = phone
        } else {
            mapItem.phoneNumber = nil
        }
        
        MKMapItem.openMaps(with: [mapItem], launchOptions: nil)
        
    }

}
