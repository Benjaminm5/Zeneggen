//
//  loginVC.swift
//  Zeneggen
//
//  Created by Benjamin Pfammatter on 23.08.16.
//  Copyright © 2016 Benjamin Pfammatter. All rights reserved.
//

import UIKit
import Firebase

class loginVC: UIViewController {
    
    @IBOutlet weak var mailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        loginButton.layer.cornerRadius = 5.0
        loginButton.backgroundColor = secondaryColor
        loginButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        */
 
        registerButton.setTitleColor(secondaryColor, for: UIControlState())
        /*
        logoutButton.layer.cornerRadius = 5.0
        logoutButton.backgroundColor = secondarySecondaryColorLight
        logoutButton.setTitleColor(secondaryBlackOnWhiteBackground, forState: .Normal)
        */
        errorLabel.textColor = blackOnWhiteBackground
        
        if ((FIRAuth.auth()?.currentUser?.email) != nil) {
            
            errorLabelLoggedIn()
            
        } else {
            
            errorLabel.text = "Login below:"
            
        }
        
        //mailTextfield.delegate = self
        //passwordTextfield.delegate = self
        
        checkIfAdminLoggedIn()
        
    }
    
    @IBAction func loginButton(_ sender: AnyObject) {
        
        login()
        
    }
    
    @IBAction func logoutButton(_ sender: AnyObject) {
        
        logout()
        
    }
    
    func logout() {
        
        if FIRAuth.auth()?.currentUser?.email != nil {
            
            try! FIRAuth.auth()!.signOut()
            print("Successfulli Signed Out")
            errorLabel.text = "Login below:"
            registerButton.isHidden = true
            
        } else {
            
            errorLabel.text = "You are not logged in yet. Login:"
            
        }
        
    }
    
    @IBAction func registerButton(_ sender: AnyObject) {
        
        //if FIRAuth.auth()?.currentUser?.email == nil {
        
        logout()
        
        if let mail = mailTextfield.text, let password = passwordTextfield.text {
                
            FIRAuth.auth()?.createUser(withEmail: mail, password: password, completion: { (user, error) in
                    
                if error == nil {
                        
                    print("Successfully Created A New User And Logged In")
                    self.errorLabelLoggedIn()
                    self.checkIfAdminLoggedIn()
                    self.deleteTextfieldsInput()
                        
                } else {
                        
                    self.errorLabel.text = "Something went wrong :("
                        
                }
            })
        }
            
        //} else {
            
            //self.errorLabel.text = "You have to log out first."
            
        //}
        
    }
    
    func login() {
        
        if FIRAuth.auth()?.currentUser?.email == nil {
            
            if let mail = mailTextfield.text, let password = passwordTextfield.text {
                
                FIRAuth.auth()?.signIn(withEmail: mail, password: password, completion: { (user, error) in
                    
                    if error == nil {
                        
                        print("Successfully Signed In")
                        self.errorLabelLoggedIn()
                        self.checkIfAdminLoggedIn()
                        self.deleteTextfieldsInput()
                        
                    } else {
                        
                        self.errorLabel.text = "Something went wrong :("
                        
                    }
                    
                })
                
            }
            
        } else {
            
            self.errorLabel.text = "You have to log out first."
            
        }
        
    }
    
    func checkIfAdminLoggedIn() {
        
        if FIRAuth.auth()?.currentUser?.email == "benjamin.pfammatter@gmail.com" {
            
            registerButton.isHidden = false
            
        } else {
            
            registerButton.isHidden = true
            
        }
        
    }
    
    func deleteTextfieldsInput() {
        
        mailTextfield.text = ""
        passwordTextfield.text = ""
        
    }
    
    func errorLabelLoggedIn() {
        
        errorLabel.text = "Logged in: " + (FIRAuth.auth()?.currentUser?.email)!
        
    }
    
    //Return on Keyboard is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        login()
        textField.resignFirstResponder()
        return true
    }
    
    //Close keyboard when touching the view outside of the textfield
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
}
