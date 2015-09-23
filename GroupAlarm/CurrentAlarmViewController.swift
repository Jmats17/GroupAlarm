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
    @IBOutlet var deleteAlarmArrow : UIImageView!

}


class CurrentAlarmViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView : UITableView!
    @IBOutlet var pendingAlarmButton : UIButton!
    let queryUser = PFQuery(className: "_User")
    let queryUserAlarm = PFQuery(className: "UserAlarmRole")
    let queryAlarm = PFQuery(className: "Alarm")
    let currentUser = PFUser.currentUser()
    var dateFormatterTime = NSDateFormatter()
    var dateFormatterDate = NSDateFormatter()
    var dateFormatter = NSDateFormatter()
    var users : PFObject!
     var currentUserAlarms: NSMutableArray = NSMutableArray()
    var userAlarmRoleObjectIds: [String] = []
    override func viewDidLoad() {
       
        UITabBar.appearance().tintColor = UIColor(red: 242/255, green: 124/255, blue: 124/255, alpha: 1.0)

        Mixpanel.sharedInstance().track("user made it to current alarms")
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        

        dateFormatterTime.dateFormat = "h:mm a"
        dateFormatterDate.dateFormat = "EEEE, MMMM d"
        pendingAlarmButton.layer.borderWidth = 1.0
        pendingAlarmButton.layer.borderColor = UIColor(red: 242/255, green: 124/255, blue: 124/255, alpha: 1.0).CGColor
    
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
        let indexPath = tableView.indexPathForSelectedRow
        let selectedCell = tableView.cellForRowAtIndexPath(indexPath!) as! AlarmViewCell
        
        alarmLabelToAlarm = selectedCell.alarmLabel.text
        alarmDateToAlarm = selectedCell.dateLabel.text
        
        let alarmTimeAsNsDate = dateFormatterTime.dateFromString(selectedCell.timeLabel.text!)
        alarmTimeToAlarm = alarmTimeAsNsDate
        
        alarmPfObjectToAlarm = selectedCell.alarmObject
        self.performSegueWithIdentifier("alarmDashboardToAlarm", sender: self)

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if (segue.identifier == "alarmDashboardToAlarm") {
            
            // initialize new view controller and cast it as your view controller
            let groupAlarmViewController = segue.destinationViewController as! GroupCurrentAlarmViewController
            // your new view controller should have property that will store passed value
            groupAlarmViewController.groupAlarmLabel = alarmLabelToAlarm
            groupAlarmViewController.groupAlarmTime = alarmTimeToAlarm
            groupAlarmViewController.groupAlarmDate = alarmDateToAlarm
            groupAlarmViewController.groupAlarmObject = alarmPfObjectToAlarm
            groupAlarmViewController.cameFromAppDel = false
        }
        
    }
    
    func queryToDelete(query : PFQuery, queryAlarm : PFQuery, userAlarmObject : PFObject) {
        query.whereKey("alarm", equalTo: userAlarmObject["alarm"]!)
        query.findObjectsInBackgroundWithBlock {
            (userAlarmObjects, error) -> Void in
            if error == nil {
                for userAlarmObject in userAlarmObjects! {
                    let valuesOfUserAlarmObjects = userAlarmObject as! PFObject
                    let alarmPointer = userAlarmObject["alarm"] as! PFObject
                    
                    alarmPointer.deleteInBackgroundWithBlock({ (success, error) -> Void in
                        if error == nil {
                            print("success")
                        }
                    })

                    valuesOfUserAlarmObjects.deleteInBackgroundWithBlock({ (success, error) -> Void in
                        if error == nil {
                            print("success")
                        }
                    })
                }
                
            }
        }
        
        
    }
    

    
    
    
    func queryForUsersAlarms(query : PFQuery) {
        query.whereKey("user", equalTo: (currentUser!))
        query.whereKey("alarmActivated", equalTo: true)
        query.selectKeys(["alarm", "alarmActivated"])
        query.includeKey("alarm")
        query.findObjectsInBackgroundWithBlock {
            (objects, error) -> Void in
            if error == nil {
                for row in objects! {
                    let userAlarmObject = row as! PFObject
                 //   var alarmInfo = row["alarm"] as! PFObject
                    self.currentUserAlarms.addObject(userAlarmObject)

                }
                self.tableView.reloadData()
        
            }
        }
        
    }
    
   
    
    @IBAction func pendingAlarmButton(sender : AnyObject) {
        self.performSegueWithIdentifier("currentToPending", sender: self)
    }
    
   
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! AlarmViewCell


            let object = self.currentUserAlarms[indexPath.row] as! PFObject
            let alarmObject = object["alarm"] as! PFObject
            let alarmLabelString  = alarmObject["alarmLabel"]! as? String
            let time = alarmObject["alarmTime"]! as? NSDate
            let numOfUsers = alarmObject["numOfUsers"] as? NSNumber
            let stringTime = dateFormatterTime.stringFromDate(time!).lowercaseString
            let stringDate = dateFormatterDate.stringFromDate(time!).lowercaseString
            cell.alarmLabel.text = alarmLabelString
            cell.timeLabel.text = stringTime
            cell.dateLabel.text = stringDate
            cell.alarmObject = alarmObject

                let numOfUsersString : String? = String(format: "%i", numOfUsers!.integerValue)

                cell.numOfUsersLabel.text = numOfUsersString

            //}
        
            if time!.timeIntervalSinceNow.isSignMinus {
                object.setObject(true, forKey: "checkIn")
                object.saveInBackgroundWithBlock({ (success, error) -> Void in
                    
                })
            }
            else {
                
            }
    
            return cell
    }

    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let object = self.currentUserAlarms[indexPath.row] as! PFObject
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! AlarmViewCell
        let alarmObject = object["alarm"] as! PFObject
        let alarmDate = alarmObject["alarmTime"]! as! NSDate
        if alarmDate.timeIntervalSinceNow.isSignMinus {
            cell.deleteAlarmArrow.hidden = false

            let delete = UITableViewRowAction(style: .Normal, title: "Leave") { action, index in

                let alertController = UIAlertController(title: "Leave Alarm", message:
                    "Are you sure you want to leave this alarm?", preferredStyle: UIAlertControllerStyle.Alert)
                
                self.presentViewController(alertController, animated: true, completion: nil)
                
                alertController.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { action in
                    self.queryToDelete(self.queryUserAlarm, queryAlarm : self.queryAlarm, userAlarmObject: object)

//                    object.deleteInBackgroundWithBlock({ (success, error) -> Void in
//                        
//                    })
                    Mixpanel.sharedInstance().track("user left the alarm")
                    let alarmPointer = object["alarm"] as! PFObject
                    let alarmActivatedBool = object["checkIn"] as! Bool
                    if self.currentUserAlarms.count == 1 && alarmActivatedBool == false {
                        alarmPointer.deleteInBackgroundWithBlock({ (success, error) -> Void in
                            if error == nil {
                                print("success")
                            }
                        })
                        self.currentUserAlarms.removeObjectAtIndex(indexPath.row)
                        self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                        
                        self.tableView.reloadData()
                    }
                    else {
                        self.currentUserAlarms.removeObjectAtIndex(indexPath.row)
                        self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                        
                        self.tableView.reloadData()
                    }
                    
                    
                }))
                alertController.addAction(UIAlertAction(title: "No", style: .Default, handler: { action in
                    tableView.editing = false
                    
                }))
                print("delete button tapped")
                
            }
            delete.backgroundColor = UIColor(red: 242/255, green: 124/255, blue: 124/255, alpha: 1.0) /* #f27c7c */

            return [delete]
        } else {
            cell.deleteAlarmArrow.hidden = true
            
            return []

        }
      

    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true

    }
    
    @IBAction func signOut(sender : AnyObject) {
        let alertView = UIAlertController(title: "Sign out", message: "Are you sure you want to sign out?", preferredStyle: UIAlertControllerStyle.Alert)
        self.presentViewController(alertView, animated: true, completion: nil)
        alertView.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { action in
            PFUser.logOut()
            self.performSegueWithIdentifier("currentToStart", sender: self)
        }))
        alertView.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler: {  action in
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
       
    }

    
}