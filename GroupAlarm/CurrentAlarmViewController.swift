//
//  CurrentAlarmViewController.swift
//  GroupAlarm
//
//  Created by Justin Matsnev on 7/21/15.
//  Copyright (c) 2015 Justin Matsnev. All rights reserved.
//

import Foundation
import UIKit
import Parse
import Bolts

class CurrentAlarmViewController : UIViewController {
    @IBOutlet var label : UILabel!
    let query = PFQuery(className: "Alarm")
    let queryUser = PFQuery(className: "_User")

    let currentUser = PFUser.currentUser()
    var dateFormatter = NSDateFormatter()
    var alarm : AnyObject!
    var alarmDate : NSDate!
    var array : NSMutableArray = NSMutableArray()
    override func viewDidLoad() {
        dateFormatter.dateFormat = "hh:mm a"
        println(alarmDate)
        super.viewDidLoad()
        query.findObjectsInBackgroundWithBlock {
            (objects, error) -> Void in
            if error == nil {
                
                for object in objects! {
                    var alarmUsers = object["alarmUsers"]
                    self.array.addObject(alarmUsers as! NSArray)
                    println(alarmUsers)
                    
                    self.queryUser.findObjectsInBackgroundWithBlock {
                        (users , error) -> Void in
                        if error == nil {
                            let listOfUsers = users as! [PFObject]
                            for user in listOfUsers {
                                let userUsername: AnyObject? = user["username"]
                            }
                        }
                    }
                    
                    
                }
                println(self.array)
            }
        }
//        println(alarm)
//        let alarmString = dateFormatter.stringFromDate(alarmDate)
//        label.text = alarmString
    }
}