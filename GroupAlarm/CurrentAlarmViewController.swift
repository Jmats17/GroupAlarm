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
    let query = PFObject(className: "Alarm")
    var dateFormatter = NSDateFormatter()

    override func viewDidLoad() {
        dateFormatter.dateFormat = "hh:mm a"

        super.viewDidLoad()
        var alarm : AnyObject! = query["alarmTime"]
        
        println(alarm)
//        println(alarm)
//        let alarmString = dateFormatter.stringFromDate(alarmDate)
//        label.text = alarmString
    }
}