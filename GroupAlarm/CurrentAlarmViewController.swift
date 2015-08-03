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
    @IBOutlet var numOfUsersLabel : UILabel!

}

class CurrentAlarmViewController : UIViewController, UITableViewDelegate, UITableViewDataSource  {
   
    @IBOutlet var tableView : UITableView!

    let queryUser = PFQuery(className: "_User")
    let queryUserAlarm = PFQuery(className: "UserAlarmRole")
    let currentUser = PFUser.currentUser()
    var dateFormatter = NSDateFormatter()
    var alarmDate : NSDate!
    var corrAlarm : PFObject!
    var users : PFObject!
    var dictOfLabelTime : NSMutableDictionary = NSMutableDictionary()
    var currentUserAlarms : NSMutableArray = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        dateFormatter.dateFormat = "hh:mm a"
     
    }
    override func viewDidAppear(animated: Bool) {
        queryForUsersAlarms(queryUserAlarm)
        tableView.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return currentUserAlarms.count
    }
    
    func queryForUsersFriends(query : PFQuery) {
        
        
        
        
    }
    
    
    func queryForUsersAlarms(query : PFQuery) {
        query.whereKey("user", equalTo: (currentUser!))
        query.selectKeys(["alarm"])
        query.includeKey("alarm")
        query.findObjectsInBackgroundWithBlock {
            (objects, error) -> Void in
            if error == nil {
                for row in objects! {
                    var objId = row.objectId!
                    var alarmInfo = row["alarm"] as! PFObject
                    self.currentUserAlarms.addObject(alarmInfo)
                }
               
                self.tableView.reloadData()
     
            }
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! AlarmViewCell
            let alarmString : String!
            // println(currentUserAlarms)
        
            let object = self.currentUserAlarms[indexPath.row] as! PFObject
            var alarmLabelString  = object["alarmLabel"]! as? String
            var timeLabelString = object["alarmTime"]! as? NSDate
            let stringDate = dateFormatter.stringFromDate(timeLabelString!)
            cell.alarmLabel.text = alarmLabelString
            cell.timeLabel.text = stringDate
        
            return cell
    }

    
}