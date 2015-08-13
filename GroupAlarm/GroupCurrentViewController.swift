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
    var groupObjId : String!
    var cameFromAppDel : Bool = false
    @IBOutlet weak var alarmLabel : UILabel!
    @IBOutlet weak var alarmDate : UILabel!
    @IBOutlet weak var alarmTime : UILabel!
    var dateFormatterTime = NSDateFormatter()
    var dateFormatterDate = NSDateFormatter()
    @IBOutlet var tableView : UITableView!
    var usersFriends : NSMutableArray = NSMutableArray()
    let queryUserAlarm = PFQuery(className: "UserAlarmRole")
    let queryAlarm = PFQuery(className: "Alarm")
    var currentUser = PFUser.currentUser()
    var queryAlarmObject : PFObject!
    override func didReceiveMemoryWarning() {
        
    }
    
    override func viewDidAppear(animated: Bool) {
   
    }
    
    override func viewDidLoad() {

        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        dateFormatterTime.dateFormat = "h:mm a"
        dateFormatterDate.dateFormat = "EEEE, MMMM d"
       
        querying(queryUserAlarm)
        
        tableView.reloadData()
        if cameFromAppDel == true {
            var objectTime = queryAlarmObject["alarmTime"] as! NSDate
            let stringTime = dateFormatterTime.stringFromDate(objectTime).lowercaseString
            let stringDate = dateFormatterDate.stringFromDate(objectTime).lowercaseString
            var objectLabel = queryAlarmObject["alarmLabel"] as! String
            alarmDate.text = stringDate
            alarmTime.text = stringTime
            alarmLabel.text = objectLabel
        }
        if cameFromAppDel == false {
            var alarmTimeString = dateFormatterTime.stringFromDate(groupAlarmTime)
            
            alarmDate.text = groupAlarmDate
            alarmTime.text = alarmTimeString
            alarmLabel.text = groupAlarmLabel
        }
        
    }
    
    func queryingAlarmClass(query : PFQuery) {
        if cameFromAppDel == true {

        query.whereKey("objectId", equalTo: groupObjId)
        queryAlarmObject = query.getFirstObject()
            
        }
        if cameFromAppDel == false {
                                                                                                    
        }
    }
    
    func querying(query : PFQuery) {
        queryingAlarmClass(queryAlarm)

        if cameFromAppDel == true {

                query.whereKey("alarm", equalTo: queryAlarmObject)
                query.whereKey("alarmActivated", equalTo: true)
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
        if cameFromAppDel == false {
         var alarmObject = groupAlarmObject
         query.whereKey("alarm", equalTo: alarmObject)
        query.whereKey("alarmActivated", equalTo: true)
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
    
    @IBAction func dismissGroupController(sender : AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
        if cameFromAppDel == true {
            if object.objectId == currentUser?.objectId  {
            var userFullName = object["FullName"]! as? String
            cell.friendName.text = userFullName! + " (me)"
            cell.statusCircle.image = UIImage(named: "greenstatusButton.png")
            }
            else {
                var userFullName = object["FullName"]! as? String
                cell.friendName.text = userFullName
            }
        }
        if cameFromAppDel == false {
            if object.objectId == currentUser?.objectId  {
            var userFullName = object["FullName"]! as? String
            cell.friendName.text = userFullName! + " (me)"
            }
            else {
                
                var userFullName = object["FullName"]! as? String
                cell.friendName.text = userFullName
            }
        }
       
        
      
        return cell

    }
    
    
}