//
//  PendingAlarmsViewController.swift
//  GroupAlarm
//
//  Created by Justin Matsnev on 8/10/15.
//  Copyright (c) 2015 Justin Matsnev. All rights reserved.
//

import Foundation
import UIKit
import Parse
import Bolts

class PendingAlarmCell : UITableViewCell {
    @IBOutlet var alarmLabelandCreator : UILabel!
    @IBOutlet var alarmDate : UILabel!
    @IBOutlet var alarmTime : UILabel!
    
}

class PendingAlarmsViewController : UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView : UITableView!
    var currentUser = PFUser.currentUser()
    var users : PFObject!
    //var currentUserAlarms: NSMutableArray = NSMutableArray()
    //var creatorArray : NSMutableArray = NSMutableArray()
    var boolArray : NSMutableArray = NSMutableArray()
    var userAlarmRoleObjectIds: [String] = []
    var dateFormatterTime = NSDateFormatter()
    var dateFormatterDate = NSDateFormatter()
    var alarmDate : NSDate!
    let alarmClass = PFObject(className: "Alarm")
    let queryUser = PFQuery(className: "_User")
    let queryUserAlarm = PFQuery(className: "UserAlarmRole")

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        dateFormatterTime.dateFormat = "h:mm a"
        dateFormatterDate.dateFormat = "EEEE, MMMM d"
        queryForUsersAlarms(queryUserAlarm)
        Mixpanel.sharedInstance().track("user made it to pending")
    }
    
    
    override func didReceiveMemoryWarning() {
        
    }
    
    override func viewDidAppear(animated: Bool) {
       // queryForUsersAlarms(queryUserAlarm)
        
        tableView.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return boolArray.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 144
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! PendingAlarmCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        let obj = self.boolArray[indexPath.row] as! PFObject
        var newBool = obj["toShowRow"] as! NSNumber
        var newNewBool = newBool.boolValue
        var currUser = obj["user"] as! PFObject
        var alarm = obj["alarm"] as! PFObject
        var creator = obj["creator"] as! String
        alarm.fetchIfNeeded()
        //var alrmLabel = alarm["alarmLabel"]! as? String
        var timeLabelString = alarm["alarmTime"]! as? NSDate
        let stringTime = dateFormatterTime.stringFromDate(timeLabelString!).lowercaseString
        let stringDate = dateFormatterDate.stringFromDate(timeLabelString!).lowercaseString
        cell.alarmLabelandCreator.text = creator + " " + "wants to add you!"
        cell.alarmTime.text = stringTime
        cell.alarmDate.text = stringDate
       // }
       

        return cell
    }
    
    
    func queryForUsersAlarms(query : PFQuery) {
        query.whereKey("user", equalTo: (currentUser!))
        query.whereKey("toShowRow", equalTo: true)
        query.findObjectsInBackgroundWithBlock {
            (objects, error) -> Void in
            if error == nil {
                for row in objects! {

                self.boolArray.addObject(row)

                    
               
                }
                self.tableView.reloadData()
                
            }
        }
        
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let accept = UITableViewRowAction(style: .Normal, title: "Accept") { action, index in
            print("accept button tapped")
            Mixpanel.sharedInstance().track("User accepted alarms")
            let object = self.boolArray[indexPath.row] as! PFObject
            let alarmObject = object["alarm"] as! PFObject
            object.setObject(true, forKey: "alarmActivated")
            object.setObject(false, forKey: "toShowRow")
            let numOfUsers = alarmObject["numOfUsers"] as! Int
            
            let addOneToUsers = (numOfUsers + 1)
            alarmObject.setObject(addOneToUsers, forKey: "numOfUsers")
            alarmObject.saveInBackgroundWithBlock({ (success, error) -> Void in
                if error == nil {
                    print("success")
                }
            })
            object.saveInBackgroundWithBlock({ (success, error) -> Void in
                if error == nil {
                    print("hooray")
                }
                
            })
            PFCloud.callFunctionInBackground("schedulePushNotification", withParameters: ["alarmObjectId": alarmObject.objectId!], block: { success, error in
                if error == nil {
                    print(success)
                }
                else {
                    print(error)
                }
                
            })
            
            self.boolArray.removeObjectAtIndex(indexPath.row)
            
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Left )
            self.tableView.reloadData()
            if self.boolArray.count == 0 {
                self.performSegueWithIdentifier("pendingToHome", sender: self)
            }
        }
        accept.backgroundColor = UIColor(red: 0/255, green: 204/255, blue: 102/255, alpha: 1.0)
        
        
        
        let decline = UITableViewRowAction(style: .Normal, title: "Decline") { action, index in
            print("Decline button tapped")
            Mixpanel.sharedInstance().track("User declined alarm")
            let object = self.boolArray[indexPath.row] as! PFObject
            let alarmObject = object["alarm"] as! PFObject
            
            object.deleteInBackgroundWithBlock({ (success, error) -> Void in
                if error == nil {
                    print("horray")
                }
            })
            self.boolArray.removeObjectAtIndex(indexPath.row)
            
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            self.tableView.reloadData()
            if self.boolArray.count == 0 {
                self.performSegueWithIdentifier("pendingToHome", sender: self)
            }
        }
        decline.backgroundColor = UIColor(red: 242/255, green: 124/255, blue: 124/255, alpha: 1.0) /* #f27c7c */
        
        
        
        return [accept,decline]
    }
    
    
    
    
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // the cells you would like the actions to appear needs to be editable
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     

    }

    
}
