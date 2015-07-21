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
    var  currentUser = PFUser.currentUser()
    var dateFormatter = NSDateFormatter()

    override func viewDidLoad() {
        dateFormatter.dateFormat = "hh:mm a"

        super.viewDidLoad()
        var alarm: AnyObject? = currentUser?.objectForKey("alarmTime")
        let alarmDate = alarm as! NSDate
        println(alarm)
        let alarmString = dateFormatter.stringFromDate(alarmDate)
        label.text = alarmString
    }
}