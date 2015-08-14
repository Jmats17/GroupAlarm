//
//  SignupViewController.swift
//  GroupAlarm
//
//  Created by Justi/n Matsnev on 7/15/15. 
//  Copyright (c) 2015 Justin Matsnev. All rights reserved.
//

import Foundation
import UIKit
import Parse
import Bolts

class SignupViewController : UIViewController,UITextFieldDelegate {
    @IBOutlet var passwordTextField : UITextField!
    @IBOutlet var usernameTextField : UITextField!
    @IBOutlet var emailTextField : UITextField!
    @IBOutlet var fulLNameTextField : UITextField!
    @IBOutlet var usernameTaken : UILabel!
    @IBOutlet var missingField : UILabel!
    @IBOutlet var invalidEmail : UILabel!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        invalidEmail.hidden = true
        missingField.hidden = true
        usernameTaken.hidden = true
        passwordTextField.delegate = self
        usernameTextField.delegate = self
        emailTextField.delegate = self
        fulLNameTextField.delegate = self
        fulLNameTextField.becomeFirstResponder()
        textFieldShouldReturn(fulLNameTextField)
        textFieldShouldReturn(emailTextField)
        textFieldShouldReturn(usernameTextField)
        textFieldShouldReturn(passwordTextField)
        
        textFieldDidBeginEditing(passwordTextField)
        textFieldDidEndEditing(passwordTextField)
        
        textFieldDidBeginEditing(usernameTextField)
        textFieldDidEndEditing(usernameTextField)
        
        textFieldDidBeginEditing(emailTextField)
        textFieldDidEndEditing(emailTextField)
        
        textFieldDidBeginEditing(fulLNameTextField)
        textFieldDidEndEditing(fulLNameTextField)
    }
   
   
    
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        //move textfields up
        let myScreenRect: CGRect = UIScreen.mainScreen().bounds
        let keyboardHeight : CGFloat = 216
        
        UIView.beginAnimations( "animateView", context: nil)
        var movementDuration:NSTimeInterval = 0.35
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
        var movementDuration:NSTimeInterval = 0.35
        var frame : CGRect = self.view.frame
        frame.origin.y = 0
        self.view.frame = frame
        UIView.commitAnimations()
    
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == self.fulLNameTextField {
            textField.resignFirstResponder()
            emailTextField.becomeFirstResponder()
        }
        if textField == self.emailTextField {
            textField.resignFirstResponder()
            usernameTextField.becomeFirstResponder()
        }
        if textField == self.usernameTextField {
            textField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        }
        if textField == self.passwordTextField {
            textField.resignFirstResponder()
            Mixpanel.sharedInstance().track("MadeToSignUpPasswordTextfield")
        }
        return true
    }
    
    @IBAction func signUp(sender : AnyObject) {
        
        var userEntered = usernameTextField.text
        var passEntered = passwordTextField.text
        var emailEntered = emailTextField.text
        var fullNameEntered = fulLNameTextField.text
        var user = PFUser()
        user.username = userEntered
        user.password = passEntered
        user.email = emailEntered
        var savedUser = PFUser(className: "_User")
        var logininviewcontroller = LoginViewController()

        
        
        func userSignUp() {
            
            [user .setObject(fullNameEntered, forKey: "FullName")]
            savedUser.setObject(userEntered, forKey: "username")
            savedUser.setObject(passEntered, forKey: "password")
            savedUser.setObject(fullNameEntered, forKey: "FullName")
            
            
            savedUser.saveInBackgroundWithBlock { (succeeded , error) -> Void in
                if error == nil {
                    println("saved!")
                }
                else {
                    
                }
            }
            
            user.setObject(user.isAuthenticated() == true, forKey: "authenticated")
            user.signUpInBackgroundWithBlock {
                (succeeded ,error) -> Void in
                if error == nil {
                    println("user signed up")
                    var currentInstallation = PFInstallation.currentInstallation()
                    currentInstallation["user"] = PFUser.currentUser()!
                    currentInstallation.saveInBackground()
                 
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        self.performSegueWithIdentifier("signUpToLogIn", sender: self)
                    })
                    
                    //   savedUser.save()
                    
                }
                else {
                    var errorcode = error!.code
                    
                    if (errorcode == 125 && errorcode == 202) {
                        self.invalidEmail.text = "Invalid Email"
                        self.invalidEmail.hidden = false
                        self.usernameTaken.hidden = false
                    }
                    else if (errorcode == 202 && errorcode == 203) {
                        self.invalidEmail.text = "Email in use"
                        self.invalidEmail.hidden = false
                        self.usernameTaken.hidden = false
                    }
                    else if errorcode == 125 {
                        self.invalidEmail.text = "Invalid Email"
                        self.invalidEmail.hidden = false
                        self.usernameTaken.hidden = true
                    }
                    else if errorcode == 202 {
                        self.invalidEmail.text = "Invalid Email"
                        self.invalidEmail.hidden = true
                        self.usernameTaken.hidden = false
                    }
                    else if errorcode == 203 {
                        self.invalidEmail.text = "Email in use"
                        self.invalidEmail.hidden = false
                        self.usernameTaken.hidden = true
                    }
                        
                    else {
                        
                    }
                    
                }
                
                
            }
        }
        
        
        if userEntered != "" && passEntered != "" && emailEntered != "" && fullNameEntered != ""  {
            missingField.hidden = true
            logininviewcontroller.userEnteredFromSignup = userEntered!
            logininviewcontroller.passEnteredFromSignup = passEntered!
            userSignUp()
            Mixpanel.sharedInstance().track("Signed Up")
        }
        else {
            missingField.hidden = false
        }
        
    }
    
    
    
}

    
