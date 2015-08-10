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

}

class GroupCurrentAlarmViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var groupAlarmLabel : String!
    var groupAlarmDate : String!
    var groupAlarmTime : NSDate!
    @IBOutlet weak var alarmLabel : UILabel!
    @IBOutlet weak var alarmDate : UILabel!
    @IBOutlet weak var alarmTime : UILabel!
    var dateFormatterTime = NSDateFormatter()
    var dateFormatterDate = NSDateFormatter()
    @IBOutlet var tableView : UITableView!
    var usersFriends : NSMutableArray!
    
    override func didReceiveMemoryWarning() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        dateFormatterTime.dateFormat = "h:mm a"
        dateFormatterDate.dateFormat = "EEEE, MMMM d"
        var alarmTimeString = dateFormatterTime.stringFromDate(groupAlarmTime)
        alarmDate.text = groupAlarmDate
        alarmTime.text = alarmTimeString
        alarmLabel.text = groupAlarmLabel
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //return usersFriends.count
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! FriendTableViewCell
        return cell
    }
    
    
}