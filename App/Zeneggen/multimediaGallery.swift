//
//  multimediaGallery.swift
//  Zeneggen
//
//  Created by Benjamin Pfammatter on 22.06.16.
//  Copyright © 2016 Benjamin Pfammatter. All rights reserved.
//

import UIKit
import Firebase

class multimediaGallery: UICollectionViewController {
    
    var keysForImages = [String]()
    var datesForImages = [String]()
    
    var viewCategory: String = ""
    
    var imageTableData = [UIImage]()
    
    var activityIndicator = activityIndicatorV()
    
    @IBOutlet weak var addMultimediaBarButton: UIBarButtonItem!
    
    //Firebase
    var ref: FIRDatabaseReference!
    var storage = FIRStorage.storage()
    
    override func viewDidLoad() {
        
        ref = FIRDatabase.database().reference()
        
        let userSignedIn: Bool = externUniversalMethods().checkIfUserIsSignedIn()
        if  !userSignedIn {
            
            self.navigationItem.rightBarButtonItem = nil
            
        } else {
            
            self.navigationItem.rightBarButtonItem = addMultimediaBarButton
            
        }
        
        //getImageData()
        
    }
    
    func uploadImage() {
        
        let dateObject = externUniversalMethods()
        let date = dateObject.getCurrenDate()
        
        //image reference in database
        let key = ref.childByAutoId().key
        let post = ["key": key,
                    "editor": false,
                    "release": false,
                    "date": date] as [String : Any]
        print(key)
        let childUpdates = ["/categories/Multimedia/Fotos/\(key)": post]
        ref.updateChildValues(childUpdates)
        
        //upload image
        let storageRef = storage.reference()
        let imageRef = storageRef.child("categories/Multimedia/Fotos/\(key)/icon.jpg")
        
        let imageForUpload: UIImage! = cropToBounds(UIImage(named: "1")!, width: 100.0, height: 100.0)
        
        let data: Data = UIImagePNGRepresentation(imageForUpload)!
        
        // Upload the file to the path
        print("Start Upload")
        let uploadTask = imageRef.put(data, metadata: nil) { metadata, error in
            if (error != nil) {
                // Uh-oh, an error occurred!
                print(error)
            } else {
                // Metadata contains file metadata such as size, content-type, and download URL.
                let downloadURL = metadata!.downloadURL
                print(downloadURL)
            }
            
        }
        
    }

    func cropToBounds(_ image: UIImage, width: Double, height: Double) -> UIImage {
            
        let contextImage: UIImage = UIImage(cgImage: image.cgImage!)
        
        let contextSize: CGSize = contextImage.size
        
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cgwidth: CGFloat = CGFloat(width)
        var cgheight: CGFloat = CGFloat(height)
        
        // See what size is longer and create the center off of that
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            cgwidth = contextSize.height
            cgheight = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            cgwidth = contextSize.width
            cgheight = contextSize.width
        }
        
        let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)
        
        // Create bitmap image from context using the rect
        let imageRef: CGImage = contextImage.cgImage!.cropping(to: rect)!
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        let imageCropped: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)

        let origin = CGPoint(x: 0, y: 0)
        let size = CGSize(width: CGFloat(width), height: CGFloat(height))
        
        UIGraphicsBeginImageContextWithOptions(size, true, 0.0)
        
        imageCropped.draw(in: CGRect(origin: origin, size: size))
        let resizedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        print(resizedImage)
        return resizedImage
        
    }
    
    func getImageData() {
        
        startActivityIndicator()
        
        keysForImages.removeAll()
        datesForImages.removeAll()
        
        let imageKeysQuery = ref.child("categories").child("Multimedia").child("Fotos").queryOrdered(byChild: "date")
        imageKeysQuery.observeSingleEvent(of: .value, with: {
            (snapshot) in
            
            for (item) in (snapshot.children) {
                
                let data = item as! [String: AnyObject]
                
                if data["release"] as! Bool != false {
                    
                    //self.keysForImages.append(data["key"] as! String)
                    self.keysForImages.append(data["key"] as! String)
                    self.datesForImages.append(data["date"] as! String)
                    
                } else {
                    
                    let post = "Freizugeben!"
                    let childUpdates = ["/categories/Multimedia/AAAAA-Fotos-Not-Released/\(data["key"] as! String)": post]
                    
                    self.ref.updateChildValues(childUpdates)
                    
                }
                
            }
            
            self.downloadImages()
            
        })
        
    }
    
    func downloadImages() {
        
        //get images query
        let storageRef = storage.reference()
        // Create a reference to the file you want to download
        imageTableData.removeAll()
        
        for var i in 0...(keysForImages.count - 1) {
            
            let imageRef = storageRef.child("categories/Multimedia/Fotos/\(keysForImages[i])/icon.jpg")
            // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
            imageRef.data(withMaxSize: 1 * 1024 * 1024) { (data, error) -> Void in
                if (error != nil) {
                    // Uh-oh, an error occurred!
                    print(error)
                    
                } else {
                    // Data for "images/island.jpg" is returned
                    // ... let islandImage: UIImage! = UIImage(data: data!)
                    self.imageTableData.append(UIImage(data: data!)!)
                    
                    if self.keysForImages.count == (self.imageTableData.count) {
                        
                        self.collectionView!.reloadData()
                        
                        //End Activity Indicator
                        self.activityIndicator.stopAnimating()
                        UIApplication.shared.endIgnoringInteractionEvents()
                        self.activityIndicator.removeViews()
                    
                    } else {
                        
                        i += 1
                        
                    }
                    
                }
             
            }
            
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageTableData.count
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: galleryCell = collectionView.dequeueReusableCell(withReuseIdentifier: "galleryCellUI", for: indexPath) as! galleryCell
        
        cell.cellImageView.image = imageTableData[(indexPath as NSIndexPath).row]
        
        return cell
        
    }
    
    func startActivityIndicator() {
        
        view.addSubview(activityIndicator)
        UIApplication.shared.beginIgnoringInteractionEvents()
        
    }

}
