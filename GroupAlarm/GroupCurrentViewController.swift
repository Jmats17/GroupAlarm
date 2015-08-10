//
//  GroupCurrentViewController.swift
//  GroupAlarm
//
//  Created by Justin Matsnev on 8/3/15.
//  Copyright (c) 2015 Justin Matsnev. All rights reserved.
//

import Foundation
import UIKit
import Parse
import Bolts

class FriendTableViewCell : UITableViewCell {
    @IBOutlet var friendName : UILabel!
    @IBOutlet var statusCircle : UIImageView!
}

class GroupCurrentAlarmViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var groupAlarmLabel : String!
    var groupAlarmDate : String!
    var groupAlarmTime : NSDate!
    var groupAlarmObject : PFObject!
    var editAlarmObject : PFObject!
    var newGroupAlarmObject :PFObject!
    @IBOutlet weak var alarmLabel : UILabel!
    @IBOutlet weak var alarmDate : UILabel!
    @IBOutlet weak var alarmTime : UILabel!
    var dateFormatterTime = NSDateFormatter()
    var dateFormatterDate = NSDateFormatter()

    @IBOutlet var tableView : UITableView!
    var usersFriends : NSMutableArray = NSMutableArray()
    let queryUserAlarm = PFQuery(className: "UserAlarmRole")
    var currentUser = PFUser.currentUser()
    var editControllerAlarmLabel : String!
    var editControllerAlarmTime : String!
    var editControllerAlarmDate : String!
    var editControllerAsPrevious : Bool = false
    
    override func didReceiveMemoryWarning() {
        
    }
    
    override func viewDidAppear(animated: Bool) {
        tableView.reloadData()

    }
    
    override func viewDidLoad() {

        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        dateFormatterTime.dateFormat = "h:mm a"
        dateFormatterDate.dateFormat = "EEEE, MMMM d"
        if editControllerAsPrevious == true {
            alarmDate.text = editControllerAlarmDate
            alarmTime.text = editControllerAlarmTime
            alarmLabel.text = editControllerAlarmLabel
        }
        else {
            var alarmTimeString = dateFormatterTime.stringFromDate(groupAlarmTime)

            alarmDate.text = groupAlarmDate
            alarmTime.text = alarmTimeString
            alarmLabel.text = groupAlarmLabel
        }

        println(groupAlarmObject)
        querying(queryUserAlarm)
        newGroupAlarmObject = groupAlarmObject
        
    }
    
    func querying(query : PFQuery) {
        if editControllerAsPrevious == true {
            var alarmObject = editAlarmObject
            query.whereKey("alarm", equalTo: alarmObject)
            query.selectKeys(["user"])
            query.includeKey("user")
            query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
                if error == nil {
                    for result in objects! {
                        var userObject = result["user"] as! PFObject
                        userObject.fetchIfNeeded()
                        self.usersFriends.addObject(userObject)
                    }
                    self.tableView.reloadData()
                }
            }
        }
        else {
         var alarmObject = groupAlarmObject
         query.whereKey("alarm", equalTo: alarmObject)
         query.selectKeys(["user"])
         query.includeKey("user")
         query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil {
                for result in objects! {
                    var userObject = result["user"] as! PFObject
                    userObject.fetchIfNeeded()
                    self.usersFriends.addObject(userObject)
                }
                self.tableView.reloadData()
            }
        }
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return usersFriends.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! FriendTableViewCell
        let object = self.usersFriends[indexPath.row] as! PFObject
        if object.objectId == currentUser?.objectId {
            
        }
        else {
            
            var userFullName = object["FullName"]! as? String
            cell.friendName.text = userFullName
        }
      
        return cell

    }
    
    @IBAction func editButton(sender : AnyObject) {
        self.performSegueWithIdentifier("groupAlarmToEdit", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "groupAlarmToEdit" {
            var editAlarmViewController = segue.destinationViewController as! EditAlarmViewController
            editAlarmViewController.alarmObject = newGroupAlarmObject
        }
    }
    
    
}