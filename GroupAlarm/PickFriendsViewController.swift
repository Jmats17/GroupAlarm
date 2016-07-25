//
//  PickFriendsViewController.swift
//  GroupAlarm
//
//  Created by Justin Matsnev on 7/21/15.
//  Copyright (c) 2015 Justin Matsnev. All rights reserved.
//

import Foundation
import UIKit
import Parse
import Bolts

class tableViewCell : UITableViewCell {
    @IBOutlet var usernameLabel : UILabel!
    @IBOutlet var fullNameLabel : UILabel!

}

class PickFriendsViewController : UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    @IBOutlet var searchBar : UISearchBar!
    @IBOutlet var tableView : UITableView!
    var searchActive : Bool = false
    var data:[PFObject]!
    var alarmVar : alarmLabelDate?
    var filtered:[PFObject]!
    var createdDate : NSDate!
    var currentUser = PFUser.currentUser()
    var currentUserId : String!
    var alarmLabel : String!
    var selectedRows : NSMutableDictionary!
    var selectedIndexPaths : NSMutableArray = NSMutableArray()
    let alarmClass = PFObject(className: "Alarm")
    let userAlarmClass = PFObject(className: "UserAlarmRole")
    var currentUserFullName : String = String()
    //let userAlarmClass = PFObject(className: "UserAlarmRole")
    let numOfUsers : Int = 0

    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
       // selectedRows = [[NSMutableDictionary alloc] init]
        search()
        createdDate = alarmVar?.alarmDate
        alarmLabel = alarmVar?.alarmLabel
        currentUserId = currentUser?.objectId
        currentUserFullName = currentUser?.objectForKey("FullName") as! String
        Mixpanel.sharedInstance().track("User made it to PickFriends")
    }
    

    func search(searchTextUsername: String? = nil, searchTextFull : String? = nil){
        let query = PFQuery(className: "_User")

        if(searchTextUsername != nil){
          query.whereKey("username", containsString: searchTextUsername)
            
        }
        //query.whereKey("FullName", containsString: searchTextFull)

        query.findObjectsInBackgroundWithBlock { (results, error) -> Void in
            self.data = results as? [PFObject]
            
            var currentUserIndex : Int!
            
            for var x = 0; x < self.data.count; x++ {
                let obj = self.data[x]
                if (obj["username"] as! String) == self.currentUser?.username {
                    currentUserIndex = x
                    self.data.removeAtIndex(currentUserIndex)

                }
            }
            
            
            self.tableView.reloadData()
        }

        
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.data != nil){
            return self.data.count
        }
        return 0
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! tableViewCell
        let obj = self.data[indexPath.row]
        cell.fullNameLabel.text = obj["FullName"] as? String
        cell.usernameLabel.text = "@" + (obj["username"] as? String)!
        Mixpanel.sharedInstance().track("Times Array of Users popped up", properties: ["#" : self.data.count])
        
        
        if selectedIndexPaths.containsObject(obj) {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            Mixpanel.sharedInstance().track("# of users checked")
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)  {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let obj = self.data[indexPath.row]

        let cell = tableView.cellForRowAtIndexPath(indexPath)
        if selectedIndexPaths.containsObject(obj) {
            //if user is checked..and currentuser taps them again, this code will uncheck them and remove from array
            cell!.accessoryType = UITableViewCellAccessoryType.None
            selectedIndexPaths.removeObject(obj)
        } else {
            //if user is not checked..and currentuser taps them, this code will check them and add them to array
            cell!.accessoryType = UITableViewCellAccessoryType.Checkmark
            
            selectedIndexPaths.addObject(obj)
        }

    }
    
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 216.0, 0)
        tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 216.0, 0)
        Mixpanel.sharedInstance().track("User clicked on search bar")
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false
        searchBar.resignFirstResponder()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        search(searchText)
    }
    
    func fixNotificationDate(dateToFix: NSDate) -> NSDate {
<<<<<<< HEAD
=======
        let dateComponets: NSDateComponents = NSCalendar.currentCalendar().components([NSCalendarUnit.NSDayCalendarUnit, NSCalendarUnit.NSMonthCalendarUnit, NSCalendarUnit.NSYearCalendarUnit, NSCalendarUnit.NSHourCalendarUnit, NSCalendarUnit.NSMinuteCalendarUnit] , fromDate: dateToFix)
>>>>>>> 48ab17fd49076e4c768c2b50b4cf1d83df1bc764
        
        let dateComp : NSDateComponents = NSCalendar.currentCalendar().components([.Day, .Month, .Year, .Hour , .Minute], fromDate: dateToFix)
        dateComp.second = 0
        
<<<<<<< HEAD
        let fixedDate: NSDate! = NSCalendar.currentCalendar().dateFromComponents(dateComp)
=======
        let fixedDate: NSDate! = NSCalendar.currentCalendar().dateFromComponents(dateComponets)
>>>>>>> 48ab17fd49076e4c768c2b50b4cf1d83df1bc764
        
        return fixedDate
    }
    
//    @IBAction func cancelButton(sender : AnyObject) {
////        Mixpanel.sharedInstance().track("cancel button hit on pickfriends")
////        self.performSegueWithIdentifier("friendToAlarmPick", sender: self)
//    }
    @IBAction func doneButton(sender : AnyObject) {

        //alarmClass.setObject(self.selectedIndexPaths.count, forKey: "numOfUsers")
        selectedIndexPaths.addObject(currentUser!)
        let fixedDate = fixNotificationDate(createdDate)

        alarmClass.setValue(fixedDate, forKeyPath: "alarmTime")
        alarmClass.setValue(alarmLabel, forKeyPath: "alarmLabel")
        alarmClass.setValue(0, forKey: "numOfUsers")
        
        
        
        
        alarmClass.saveInBackgroundWithBlock {
            (result, error) -> Void in
            for objID in self.selectedIndexPaths {
                let newUserAlarm = PFObject(className: "UserAlarmRole")
                newUserAlarm.setObject(objID, forKey: "user")
                newUserAlarm.setObject(self.alarmClass, forKey: "alarm")
                newUserAlarm.setObject(false, forKey: "checkIn")
                newUserAlarm.setObject(self.currentUserFullName, forKey: "creator")
                if self.currentUser == (objID as! PFObject) {
                    newUserAlarm.setObject(false, forKey: "toShowRow")
                    newUserAlarm.setObject(true, forKey: "alarmActivated")
                    PFCloud.callFunctionInBackground("schedulePushNotification", withParameters: ["alarmObjectId": self.alarmClass.objectId!], block: { success, error in
                    
                        print(success)
                        print(error)
                    })
                    
                }
                else {
                    newUserAlarm.setObject(true, forKey: "toShowRow")
                    newUserAlarm.setObject(false, forKey: "alarmActivated")

                }
                newUserAlarm.save()
            }
//            PFCloud.callFunctionInBackground("schedulePushNotification", withParameters: ["alarmObjectId": self.alarmClass.objectId!], block: { success, error in
//        
//                println(success)
//                println(error)
//            })
        }
        Mixpanel.sharedInstance().track("Alarm Created")
        self.performSegueWithIdentifier("friendToCurrent", sender: self)


    }
}
