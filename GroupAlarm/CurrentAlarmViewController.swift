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

class AlarmViewCell : UITableViewCell {
    @IBOutlet var timeLabel : UILabel!
    @IBOutlet var alarmLabel : UILabel!
}

class CurrentAlarmViewController : UIViewController, UITableViewDelegate, UITableViewDataSource  {
   
    @IBOutlet var tableView : UITableView!

    let query = PFQuery(className: "Alarm")
    let queryUser = PFQuery(className: "_User")
    
    let currentUser = PFUser.currentUser()
    var dateFormatter = NSDateFormatter()
    var alarm : AnyObject!
    var alarmDate : NSDate!
    var arrayOfArraysUsers : NSMutableArray = NSMutableArray()
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        
        dateFormatter.dateFormat = "hh:mm a"
      //  println(alarmDate)
        super.viewDidLoad()
        query.findObjectsInBackgroundWithBlock {
            (objects, error) -> Void in
            if error == nil {
                
                for object in objects! {
                    var alarmUsers : AnyObject? = object.objectForKey("alarmUsers")
                    var arrayOfAlarmUsers : NSArray = alarmUsers as! NSArray
                   // println(alarmUsers)
                    for userId in arrayOfAlarmUsers {
                        if (userId as! String) == self.currentUser?.objectId! {
                           // println("working :') ")
                            self.arrayOfArraysUsers.addObject(arrayOfAlarmUsers)
                            for eachArray in self.arrayOfArraysUsers {
                                
                            }
                        }
                    }
                   // println(self.arrayOfArraysUsers)
                    
                    
                }
              //  println(self.arrayOfArraysUsers)
            }
        }

//        println(alarm)
//        let alarmString = dateFormatter.stringFromDate(alarmDate)
//        label.text = alarmString
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! AlarmViewCell

        return cell
    }

    
}