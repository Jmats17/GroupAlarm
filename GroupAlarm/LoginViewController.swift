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
class LoginViewController : UIViewController, UITextFieldDelegate {
    @IBOutlet var usernameTextField : UITextField!
    @IBOutlet var passwordTextField : UITextField!
    @IBOutlet var invalidCreds : UILabel!
    @IBOutlet var missingUsername : UILabel!
    var userEnteredFromSignup : String!
    var passEnteredFromSignup : String!

   
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
        if textField == self.usernameTextField {
            textField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        }
        if textField == self.passwordTextField {
            textField.resignFirstResponder()
        }
        return true
    }
    
    override func viewDidLoad() {
      
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        invalidCreds.hidden = true
        missingUsername.hidden = true
        textFieldShouldReturn(usernameTextField)
        textFieldShouldReturn(passwordTextField)
        textFieldDidBeginEditing(passwordTextField)
        textFieldDidEndEditing(passwordTextField)
            if let userNameField = userEnteredFromSignup, passNameField = passEnteredFromSignup {
                usernameTextField.text = userNameField
                passwordTextField.text = passNameField
            }
            else {
                usernameTextField.text = usernameTextField.text
                passwordTextField.text = passwordTextField.text
            }

    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        //move textfields up
        let myScreenRect: CGRect = UIScreen.mainScreen().bounds
        let keyboardHeight : CGFloat = 216
        
        UIView.beginAnimations( "animateView", context: nil)
        var needToMove: CGFloat = 0
        
        var frame : CGRect = self.view.frame
        if (textField.frame.origin.y + textField.frame.size.height + /*self.navigationController.navigationBar.frame.size.height + */UIApplication.sharedApplication().statusBarFrame.size.height > (myScreenRect.size.height - keyboardHeight)) {
            needToMove = (textField.frame.origin.y + textField.frame.size.height + /*self.navigationController.navigationBar.frame.size.height +*/ UIApplication.sharedApplication().statusBarFrame.size.height) - (myScreenRect.size.height - keyboardHeight);
        }
        
        frame.origin.y = -needToMove
        self.view.frame = frame
        UIView.commitAnimations()
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        //move textfields back down
        UIView.beginAnimations( "animateView", context: nil)
        var frame : CGRect = self.view.frame
        frame.origin.y = 0
        self.view.frame = frame
        UIView.commitAnimations()
        
    }
    
    
    
    @IBAction func login(sender : AnyObject) {
        let userCreds = usernameTextField.text
        let passCreds = passwordTextField.text
        let getUser = PFQuery(className:"_User")
        //        var queryForUser : PFQuery = PFUser .query()
        //        var usernamee = [queryForUser .getObjectWithId("FullName")]
        let getUserName = getUser.getObjectWithId("username")
        let getUserPass = getUser.getObjectWithId("password")
        let getAuthentication = getUser.getObjectWithId("Authenticated")
        PFUser.logInWithUsernameInBackground(userCreds!, password: passCreds!) {
            (user ,error) -> Void in
            if user != nil {
                Mixpanel.sharedInstance().track("User Logged In")
                self.performSegueWithIdentifier("loginViewSegue", sender: self)
                user?.save()
                
            }
            else if  self.usernameTextField.text != "" && self.passwordTextField.text != "" {
                //checking username validity
                
                if userCreds != getUserName && passCreds == getUserPass && getAuthentication == false {
                    self.missingUsername.hidden = true
                    self.invalidCreds.hidden = false
                    
                }
                else if userCreds == getUserName && passCreds != getUserPass {
                    self.invalidCreds.hidden = false
                    self.missingUsername.hidden = true
                }
                else {
                    self.invalidCreds.hidden = false
                    self.missingUsername.hidden = true
                }
                /////////////////////
            }
            else if self.usernameTextField.text == "" && self.passwordTextField.text != "" {
                self.missingUsername.hidden = false
                self.invalidCreds.hidden = true
                
            }
            else if  self.usernameTextField.text != "" && self.passwordTextField.text == "" {
                self.missingUsername.hidden = false
                self.invalidCreds.hidden = true
                
            }
            else  {
                
                self.missingUsername.hidden = false
                self.invalidCreds.hidden = true
            }
            
            
            
            
        }
        
    }
}
    

    
