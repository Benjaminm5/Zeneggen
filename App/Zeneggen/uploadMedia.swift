//
//  uploadMedia.swift
//  Zeneggen
//
//  Created by Benjamin Pfammatter on 04.07.16.
//  Copyright © 2016 Benjamin Pfammatter. All rights reserved.
//

import UIKit
import Firebase

class uploadMedia: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    //Firebase
    var ref: FIRDatabaseReference!
    var storage = FIRStorage.storage()
    
    var loggedIn = false
    
    var activityIndicator = activityIndicatorV()
    
    let imagePickerController = UIImagePickerController()
    let activeVC: UIViewController = UIApplication.shared.keyWindow!.rootViewController!
    var profileImageSelected:Bool = false
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var uploadMediaButton: standardButton!
    
    @IBAction func chooseMedia(_ sender: AnyObject) {
        
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = false
        
        let action = UIAlertController(title: "Foto hinzufügen", message: "Wähle ein Foto aus deiner Fotomediathek oder knipse jetzt ein Foto:", preferredStyle: UIAlertControllerStyle.actionSheet)
        action.view.tintColor = secondaryColor
        action.addAction(UIAlertAction(title: "Kamera", style: .default, handler: { action in
            
            self.imagePickerController.sourceType = UIImagePickerControllerSourceType.camera
            self.activeVC.present(self.imagePickerController, animated: true, completion:  nil)
            
        }))
        action.addAction(UIAlertAction(title: "Fotomediathek", style: .default, handler: { action in
            
            self.imagePickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
            //self.imagePickerController.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
            self.activeVC.present(self.imagePickerController, animated: true, completion:  nil)
            
        }))
        action.addAction(UIAlertAction(title: "Abbrechen", style: .cancel, handler: { action in
            
            self.activeVC.dismiss(animated: true, completion: nil)
            
        }))
        activeVC.present(action, animated: true, completion: nil)
        
    }
    
    @IBAction func uploadMedia(_ sender: AnyObject) {
        
        uploadMedia()
        
    }
    
    override func viewDidLoad() {
        
        self.navigationController!.navigationBar.topItem!.title = "Foto Hinzufügen"
        
        ref = FIRDatabase.database().reference()
        //Anonymous Login
        
        progressView.progress = Float(0)
        uploadMediaButton.isEnabled = false
        
        layoutSubviews()
        
    }
    
    func layoutSubviews() {
        
        imageView.layer.cornerRadius = 5
        imageView.backgroundColor = thirdBlackOnWhiteBackground
        
        let placeholder = UILabel()
        placeholder.text = "Choose an image"
        placeholder.textColor = secondaryBlackOnWhiteBackground
        placeholder.center = imageView.center
        imageView.addSubview(placeholder)
        
    }
    
    func uploadMedia() {
        
        startActivityIndicator()
        
        let userSignedIn: Bool = externUniversalMethods().checkIfUserIsSignedIn()
        if userSignedIn {
            
            let dateObject = externUniversalMethods()
            let date = dateObject.getCurrenDate()
            
            //image reference in database
            let key = ref.childByAutoId().key
            let post = ["key": key,
                        "editor": false,
                        "release": false,
                        "date": date] as [String : Any]
            let childUpdates = ["/categories/Multimedia/Fotos/\(key)": post]
            ref.updateChildValues(childUpdates)
            
            //upload image
            let storageRef = storage.reference()
            let imageRef = storageRef.child("categories/Multimedia/Fotos/\(key)/image.jpg")
            let iconRef = storageRef.child("categories/Multimedia/Fotos/\(key)/icon.jpg")
            
            let uploadMetadata = FIRStorageMetadata()
            uploadMetadata.contentType = "image/jpeg"
            
            let iconForUpload: UIImage! = cropToBounds(imageView.image!, width: 100.0, height: 100.0)
            let imageForUpload: UIImage! = imageView.image!
            
            let imageData: Data = UIImagePNGRepresentation(imageForUpload)!
            let iconData: Data = UIImagePNGRepresentation(iconForUpload)!
            
            // Upload the file to the path
            print("Start Upload")
            
            let uploadTaskImage = imageRef.put(imageData, metadata: uploadMetadata) { metadata, error in
                if (error != nil) {
                    print("Image Upload Error: \(error)")
                } else {
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    self.activityIndicator.removeViews()
                    
                    print("Image Upload Complete. Metadata: \(metadata)")
                    
                }
            
            }
            
            uploadTaskImage.observe(.progress) { [weak self] (snapshot) in
                
                guard self != nil else { return }
                guard let progress = snapshot.progress else { return }
                self?.progressView.progress = Float(progress.fractionCompleted)
                
            }
            
            iconRef.put(iconData, metadata: nil) { metadata, error in
                if (error != nil) {
                    print(error)
                } else {
                    
                    print("Icon uploaded")
                    
                }
                
            }
            
        } else {
            
            print("Login first")
            
            self.activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            self.activityIndicator.removeViews()
            
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
        
        return resizedImage
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.activeVC.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [AnyHashable: Any]!) {
        
        self.imageView.image = image
        self.imageView.layer.masksToBounds = true
        self.imageView.layer.cornerRadius = 5
        self.activeVC.dismiss(animated: true, completion: nil)
        
        profileImageSelected = true
        uploadMediaButton.isEnabled = true
        
    }
    
    func startActivityIndicator() {
        
        view.addSubview(activityIndicator)
        UIApplication.shared.beginIgnoringInteractionEvents()
        
    }

}
