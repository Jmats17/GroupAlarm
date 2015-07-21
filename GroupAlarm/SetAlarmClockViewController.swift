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

class SetAlarmViewController : UIViewController {
    @IBOutlet var myDatePicker : UIDatePicker!
    @IBOutlet var chosenDate : UILabel!
    var strDate : String!
    var currentUser = PFUser.currentUser()
    var dateFormatter = NSDateFormatter()

    @IBAction func dateAction(sender : AnyObject) {
        dateFormatter.dateFormat = "hh:mm a"
        strDate = dateFormatter.stringFromDate(myDatePicker.date)
        self.chosenDate.text = strDate
    }
    
    @IBAction func addButton(sender : AnyObject) {
        let myAlarm =  dateFormatter.dateFromString(strDate)
        
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