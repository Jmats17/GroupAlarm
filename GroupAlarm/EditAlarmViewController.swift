//
//  EditAlarmViewController.swift
//  GroupAlarm
//
//  Created by Justin Matsnev on 8/10/15.
//  Copyright (c) 2015 Justin Matsnev. All rights reserved.
//

import Foundation
import UIKit
import Parse
import Bolts

class EditAlarmViewController : UIViewController /*, UITextFieldDelegate*/ {
    
//    //var queryAlarm
//    var alarmTextLabel : String!
//    var dateFormatter = NSDateFormatter()
//    var dateFormatterTime = NSDateFormatter()
//    var dateFormatterDate = NSDateFormatter()
//
//    var alarmObject : PFObject!
//    @IBOutlet var alarmLabelTextField : UITextField!
//    @IBOutlet var saveButton : UIBarButtonItem!
//    var dateFromObject : NSDate!
//    var stringFromObject : String!
//    var boolView : Bool = true
//    var boolViewForCurrentView : Bool = false
//    let alarmClass = PFObject(className: "Alarm")
//
//   
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        alarmLabelTextField.delegate = self
//        let date : NSDate = NSDate()
//        textFieldShouldReturn(alarmLabelTextField)
//        println(alarmObject)
//        stringFromObject = alarmObject["alarmLabel"] as! String
//        alarmLabelTextField.text = stringFromObject
//        dateFromObject = alarmObject["alarmTime"] as! NSDate
//        dateFormatterTime.dateFormat = "h:mm a"
//        dateFormatterDate.dateFormat = "EEEE, MMMM d"
//        
//        
//    }
//    
//    func textFieldShouldReturn(textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        //  saveButton.enabled = true
//        alarmTextLabel = alarmLabelTextField?.text
//        
//        return true
//    }
//    
//    @IBAction func saveButton(sender : AnyObject) {
//       
//        self.performSegueWithIdentifier("editToGroupCurrent", sender: self)
//        
//    }
//    
//    @IBAction func cancelButton(sender : AnyObject) {
//        self.performSegueWithIdentifier("editCancelToGroupAlarm", sender: self)
//    }
//    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "editToGroupCurrent" {
//            var groupAlarmViewController = segue.destinationViewController as! GroupCurrentAlarmViewController
//            let stringDate = dateFormatterDate.stringFromDate(dateFromObject).lowercaseString
//            let stringTime = dateFormatterTime.stringFromDate(dateFromObject).lowercaseString
//            groupAlarmViewController.editControllerAlarmDate = stringDate
//            groupAlarmViewController.editControllerAlarmTime = stringTime
//            
//            if alarmTextLabel != stringFromObject {
//                alarmObject.setValue(alarmTextLabel, forKey: "alarmLabel")
//                groupAlarmViewController.editControllerAlarmLabel = alarmTextLabel
//
//            }
//            else {
//                groupAlarmViewController.editControllerAlarmLabel = alarmTextLabel
//
//            }
//            alarmObject.saveInBackgroundWithBlock({ (success, error) -> Void in
//                if error == nil {
//                   
//                }
//            })
//            groupAlarmViewController.editControllerAsPrevious = boolView
//            groupAlarmViewController.editAlarmObject = alarmObject
//        }
//        if segue.identifier == "editCancelToGroupAlarm" {
//            
//            var groupAlarmViewController = segue.destinationViewController as! GroupCurrentAlarmViewController
//            let stringDate = dateFormatterDate.stringFromDate(dateFromObject).lowercaseString
//            let stringTime = dateFormatterTime.stringFromDate(dateFromObject).lowercaseString
//            groupAlarmViewController.editControllerAlarmDate = stringDate
//            groupAlarmViewController.editControllerAlarmTime = stringTime
//            groupAlarmViewController.editControllerAlarmLabel = alarmTextLabel
//            groupAlarmViewController.editControllerAsPrevious = boolView
//            groupAlarmViewController.editAlarmObject = alarmObject
//        }
//        
//    }
//    
//    
//    override func didReceiveMemoryWarning() {
//        
//    }
}