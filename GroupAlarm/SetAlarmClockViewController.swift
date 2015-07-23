//
//  SetAlarmClockViewController.swift
//  GroupAlarm
//
//  Created by Justin Matsnev on 7/20/15.
//  Copyright (c) 2015 Justin Matsnev. All rights reserved.
//

import Foundation
import UIKit
import Parse
import Bolts




class SetAlarmViewController : UIViewController, UITextFieldDelegate {
    @IBOutlet var myDatePicker : UIDatePicker!
    var strDate : String!
    var currentUser = PFUser.currentUser()
    var alarmTextLabel : String!
    var dateFormatter = NSDateFormatter()
    @IBOutlet var alarmLabelTextField : UITextField!
    @IBOutlet var saveButton : UIBarButtonItem!
    @IBAction func dateAction(sender : AnyObject) {
        dateFormatter.dateFormat = "hh:mm a"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alarmLabelTextField.delegate = self
        
        textFieldShouldReturn(alarmLabelTextField)
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
      //  saveButton.enabled = true
        alarmTextLabel = alarmLabelTextField?.text
        if alarmLabelTextField.text == "" {
            saveButton.enabled = false
        }
        else {
            saveButton.enabled = true
        }
        return true
    }
    
    
    @IBAction func addButton(sender : AnyObject) {
        strDate = dateFormatter.stringFromDate(myDatePicker.date)

        let myAlarm =  dateFormatter.dateFromString(strDate)
        currentUser!.setObject(alarmTextLabel, forKey: "alarmLabel")
        currentUser!.setObject(myAlarm!, forKey: "alarmTime")
        println("hi")
        println(currentUser?.username)
        currentUser!.saveInBackgroundWithBlock {
            (succeeded, error) ->  Void in
            if error == nil {
                println("saved!")
            }
            else {
                
            }
            
        }
        self.performSegueWithIdentifier("alarmtoFriend", sender: self)
    }
    
    @IBAction func cancelButton(sender : AnyObject) {
        
    }
    
    
}