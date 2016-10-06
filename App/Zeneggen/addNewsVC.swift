//
//  addNewsVC.swift
//  Zeneggen
//
//  Created by Benjamin Pfammatter on 14.06.16.
//  Copyright © 2016 Benjamin Pfammatter. All rights reserved.
//

import UIKit
import Firebase

class addNewsVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var titlesTextfield: UITextField!
    @IBOutlet weak var textTextview: UITextView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var choosePhotosButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    //Image Picking
    let imagePickerController = UIImagePickerController()
    let activeVC: UIViewController = UIApplication.shared.keyWindow!.rootViewController!
    var profileImageSelected: Bool = false
    
    var ref: FIRDatabaseReference!
    var storage = FIRStorage.storage()
    
    var titles = [String]()
    
    override func viewDidLoad() {
        
        ref = FIRDatabase.database().reference()
        
        progressView.tintColor = secondaryColor
        progressView.progress = Float(0)
        
        titleLabel.textColor = blackOnWhiteBackground
        textLabel.textColor = blackOnWhiteBackground
        /*
        uploadButton.layer.cornerRadius = 5.0
        uploadButton.backgroundColor = secondaryColor
        uploadButton.setTitleColor(blackOnWhiteBackground, forState: .Normal)
 
        choosePhotosButton.layer.cornerRadius = 5.0
        choosePhotosButton.backgroundColor = secondarySecondaryColorLight
        choosePhotosButton.setTitleColor(blackOnWhiteBackground, forState: .Normal)
        */
        textTextview.layer.cornerRadius = 5
        textTextview.backgroundColor = UIColor.white
        textTextview.layer.borderWidth = 1
        textTextview.layer.borderColor = thirdBlackOnWhiteBackground.cgColor
        textTextview.textColor = blackOnWhiteBackground
        textTextview.tintColor = secondaryColor
        
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 5
        
    }
    
    @IBAction func choosePhotosButton(_ sender: AnyObject) {
        
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = false
        
        let action = UIAlertController(title: "Foto hinzufügen", message: "Wähle ein Foto aus deiner Fotomediathek oder knipse jetzt ein Foto:", preferredStyle: UIAlertControllerStyle.actionSheet)
        action.addAction(UIAlertAction(title: "Kamera", style: .default, handler: { action in
            
            self.imagePickerController.sourceType = UIImagePickerControllerSourceType.camera
            self.activeVC.present(self.imagePickerController, animated: true, completion:  nil)
            
        }))
        action.addAction(UIAlertAction(title: "Fotomediathek", style: .default, handler: { action in
            
            self.imagePickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.activeVC.present(self.imagePickerController, animated: true, completion:  nil)
            
        }))
        action.addAction(UIAlertAction(title: "Abbrechen", style: .cancel, handler: { action in
            
            self.activeVC.dismiss(animated: true, completion: nil)
            
        }))
        activeVC.present(action, animated: true, completion: nil)
        
    }
    
    @IBAction func uploadPost(_ sender: AnyObject) {
        
        if profileImageSelected {
            
            let dateObject = externUniversalMethods()
            let date = dateObject.getCurrenDate()
            
            var author = ""
            
            if FIRAuth.auth()?.currentUser?.email == "benjamin.pfammatter@gmail.com" {
                author = "Developer"
            } else {
                author = (FIRAuth.auth()?.currentUser?.email)!
            }
            
            let key = ref.childByAutoId().key
            let post = ["title": titlesTextfield.text!,
                        "text": textTextview.text!,
                        "key": key,
                        "date": date,
                        "author": author]
            let childUpdates = ["/categories/Aktuelles/de/\(key)": post]
            
            ref.updateChildValues(childUpdates)
            
            let uploadMetadata = FIRStorageMetadata()
            uploadMetadata.contentType = "image/jpeg"
            
            print("Title and Text Uploaded")
            
            //upload image
            let storageRef = storage.reference()
            let imageRef = storageRef.child("categories/Aktuelles/de/\(key)/postimage.jpg")
            
            let resizedImage = resizeImage(image: image.image!, newWidth: image.frame.width)
            
            let imageData: Data = UIImagePNGRepresentation(resizedImage)!
            
            // Upload the file to the path
            let uploadTaskImage = imageRef.put(imageData, metadata: uploadMetadata) { metadata, error in
                if (error != nil) {
                    // Uh-oh, an error occurred!
                    print(error)
                } else {
                    // Metadata contains file metadata such as size, content-type, and download URL.
                    let downloadURL = metadata!.downloadURL
                    print(downloadURL)
                    print("Image Uploaded")
                    
                    self.profileImageSelected = false
                    
                }
            }
            
            uploadTaskImage.observe(.progress) { [weak self] (snapshot) in
            
                guard self != nil else { return }
                guard let progress = snapshot.progress else { return }
                self?.progressView.progress = Float(progress.fractionCompleted)
                
            }
            
        }
        
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / image.size.height
        let newHeight = image.size.width * scale
        UIGraphicsBeginImageContext(CGSize(width: newHeight, height: newWidth))
        image.draw(in: CGRect(x: 0, y: 0, width: newHeight, height: newWidth))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [AnyHashable: Any]!) {
        
        self.image.image = image
        self.image.layer.masksToBounds = true
        self.image.layer.cornerRadius = 5
        self.activeVC.dismiss(animated: true, completion: nil)
        profileImageSelected = true
        
    }
    
    //Return on Keyboard is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //login()
        textField.resignFirstResponder()
        return true
    }
    
    //Close keyboard when touching the view outside of the textfield
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
}
