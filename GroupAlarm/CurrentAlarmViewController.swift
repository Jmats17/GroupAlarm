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
    @IBOutlet var dateLabel : UILabel!
    var alarmObject : PFObject!
}


class CurrentAlarmViewController : UIViewController, UITableViewDelegate, UITableViewDataSource  {
   
    @IBOutlet var tableView : UITableView!

    let queryUser = PFQuery(className: "_User")
    let queryUserAlarm = PFQuery(className: "UserAlarmRole")
    let currentUser = PFUser.currentUser()
    var dateFormatterTime = NSDateFormatter()
    var dateFormatterDate = NSDateFormatter()
    var alarmDate : NSDate!
    var corrAlarm : PFObject!
    var users : PFObject!
     var currentUserAlarms: NSMutableArray = NSMutableArray()
    var userAlarmRoleObjectIds: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        dateFormatterTime.dateFormat = "h:mm a"
        dateFormatterDate.dateFormat = "EEEE, MMMM d"
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
    
    var alarmLabelToAlarm : String!
    var alarmDateToAlarm : String!
    var alarmTimeToAlarm : NSDate!
    var alarmPfObjectToAlarm : PFObject!
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let indexPath = tableView.indexPathForSelectedRow()
        let selectedCell = tableView.cellForRowAtIndexPath(indexPath!) as! AlarmViewCell
        
        alarmLabelToAlarm = selectedCell.alarmLabel.text
        alarmDateToAlarm = selectedCell.dateLabel.text
        
        var alarmTimeAsNsDate = dateFormatterTime.dateFromString(selectedCell.timeLabel.text!)
        alarmTimeToAlarm = alarmTimeAsNsDate
        
        alarmPfObjectToAlarm = selectedCell.alarmObject
        
        self.performSegueWithIdentifier("alarmDashboardToAlarm", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if (segue.identifier == "alarmDashboardToAlarm") {
            
            // initialize new view controller and cast it as your view controller
            var groupAlarmViewController = segue.destinationViewController as! GroupCurrentAlarmViewController
            // your new view controller should have property that will store passed value
            groupAlarmViewController.groupAlarmLabel = alarmLabelToAlarm
            groupAlarmViewController.groupAlarmTime = alarmTimeToAlarm
            groupAlarmViewController.groupAlarmDate = alarmDateToAlarm
            groupAlarmViewController.groupAlarmObject = alarmPfObjectToAlarm
        }
        
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
    
    @IBAction func unwindToCurrentAlarmViewController(segue : UIStoryboardSegue, sender : AnyObject) {
        
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! AlarmViewCell
            let alarmString : String!

        
            let object = self.currentUserAlarms[indexPath.row] as! PFObject
        
            var alarmLabelString  = object["alarmLabel"]! as? String
            var timeLabelString = object["alarmTime"]! as? NSDate
            var numOfUsers = object["numOfUsers"] as? NSNumber
            let stringTime = dateFormatterTime.stringFromDate(timeLabelString!).lowercaseString
            let stringDate = dateFormatterDate.stringFromDate(timeLabelString!).lowercaseString

            var numOfUsersString : String = String(format: "%i", numOfUsers!.integerValue)
            cell.alarmLabel.text = alarmLabelString
            cell.timeLabel.text = stringTime
            cell.dateLabel.text = stringDate
            cell.alarmObject = object
                if numOfUsers!.integerValue == 1 {
                    cell.numOfUsersLabel.text = numOfUsersString
                }
                else {
                    cell.numOfUsersLabel.text = numOfUsersString 
                }
            return cell
    }
    
    @IBAction func signOut(sender : AnyObject) {
        PFUser.logOut()
        var currentUser = PFUser.currentUser()
        self.performSegueWithIdentifier("currentToStart", sender: self)
    }

    
}