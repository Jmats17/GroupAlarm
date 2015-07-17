//
//  LoginViewController.swift
//  GroupAlarm
//
//  Created by Justin Matsnev on 7/15/15.
//  Copyright (c) 2015 Justin Matsnev. All rights reserved.
//

import Foundation
import UIKit
import Parse
import Bolts
class LoginViewController : UIViewController {
    @IBOutlet var usernameTextField : UITextField!
    @IBOutlet var passwordTextField : UITextField!
    @IBOutlet var invalidCreds : UILabel!
    @IBOutlet var missingUsername : UILabel!
    @IBOutlet var missingPassword : UILabel!
    
    
    @IBAction func signUp(sender : AnyObject) {
        
    }
    
    override func viewDidLoad() {
        invalidCreds.hidden = true
        missingPassword.hidden = true
        missingUsername.hidden = true
    }
    
    @IBAction func tappedOutside(sender: AnyObject) {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    @IBAction func login(sender : AnyObject) {
        var userCreds = usernameTextField.text
        var passCreds = passwordTextField.text
        var getUser = PFQuery(className:"_User")
        //        var queryForUser : PFQuery = PFUser .query()
        //        var usernamee = [queryForUser .getObjectWithId("FullName")]
        var getUserName = getUser.getObjectWithId("username")
        var getUserPass = getUser.getObjectWithId("password")
        var getAuthentication = getUser.getObjectWithId("Authenticated")
        var user : PFUser
        PFUser.logInWithUsernameInBackground(userCreds, password: passCreds) {
            (user ,error) -> Void in
            if user != nil {
                self.performSegueWithIdentifier("loginViewSegue", sender: self)
                user?.save()
                
            }
            else if  self.usernameTextField.text != "" && self.passwordTextField.text != "" {
                //checking username validity
                
                if userCreds != getUserName && passCreds == getUserPass && getAuthentication == false {
                    self.missingUsername.hidden = true
                    self.missingPassword.hidden = true
                    self.invalidCreds.hidden = false
                }
                else if userCreds == getUserName && passCreds != getUserPass {
                    self.invalidCreds.hidden = false
                    self.missingUsername.hidden = true
                    self.missingPassword.hidden = true
                }
                else {
                    self.invalidCreds.hidden = false
                    self.missingUsername.hidden = true
                    self.missingPassword.hidden = true
                }
                /////////////////////
            }
            else if self.usernameTextField.text == "" && self.passwordTextField.text != "" {
                self.missingUsername.hidden = false
                self.missingPassword.hidden = true
                self.invalidCreds.hidden = true
                
            }
            else if  self.usernameTextField.text != "" && self.passwordTextField.text == "" {
                self.missingPassword.hidden = false
                self.missingUsername.hidden = true
                self.invalidCreds.hidden = true
                
            }
            else  {
                
                self.missingUsername.hidden = false
                self.missingPassword.hidden = false
                self.invalidCreds.hidden = true
            }
            
            
            
            
        }
        
    }
}
    

    
