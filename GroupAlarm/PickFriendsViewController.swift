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
        
        
        
        if selectedIndexPaths.containsObject(obj) {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
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
        search(searchTextUsername: searchText)
    }
    
    
    @IBAction func cancelButton(sender : AnyObject) {
        self.performSegueWithIdentifier("friendToAlarmPick", sender: self)
    }
    @IBAction func doneButton(sender : AnyObject) {

        alarmClass.setObject(self.selectedIndexPaths.count, forKey: "numOfUsers")
        selectedIndexPaths.addObject(currentUser!)

        alarmClass.setValue(createdDate, forKeyPath: "alarmTime")
        alarmClass.setValue(alarmLabel, forKeyPath: "alarmLabel")
        
        
        
        
        
        alarmClass.saveInBackgroundWithBlock {
            (result, error) -> Void in
            for objID in self.selectedIndexPaths {
                var newUserAlarm = PFObject(className: "UserAlarmRole")
                newUserAlarm.setObject(objID, forKey: "user")
                newUserAlarm.setObject(self.alarmClass, forKey: "alarm")
                newUserAlarm.save()
            }
            PFCloud.callFunctionInBackground("schedulePushNotification", withParameters: ["alarmObjectId": self.alarmClass.objectId!], block: { success, error in
        
                println(success)
                println(error)
            })
        }
        
        self.performSegueWithIdentifier("friendToCurrent", sender: self)

    }
}
