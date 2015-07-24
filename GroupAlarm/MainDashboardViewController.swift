//
//  MainDashboardViewController.swift
//  GroupAlarm
//
//  Created by Justin Matsnev on 7/16/15.
//  Copyright (c) 2015 Justin Matsnev. All rights reserved.
//

import Foundation
import UIKit
import Parse
import Bolts

class MainDashboardViewController : UIViewController {
   
    @IBOutlet var logOutButton : UIButton!
    var currentUser = PFUser.currentUser()
    var username : String!
    @IBOutlet var date : UILabel!
    @IBOutlet var time : UILabel!
    
    override func viewDidLoad() {
        let date = NSDate()
        printDate(date)
        username = currentUser?.username
        logOutButton.setTitle("Log Out of \(username)", forState: nil)
        println(currentUser)
    }
    
    @IBAction func logOut(sender : AnyObject) {
        
        PFUser.logOut()
        var currentUser = PFUser.currentUser()
        currentUser = nil
        
    }
    
    func printDate(date1:NSDate){
        
        let dateFormatter = NSDateFormatter()
        let timeFormatter = NSDateFormatter()
        var theDateFormat = NSDateFormatterStyle.LongStyle
        
        let theTimeFormat = NSDateFormatterStyle.ShortStyle
        
        dateFormatter.dateStyle = theDateFormat
        timeFormatter.timeStyle = theTimeFormat
        
        date.text =  dateFormatter.stringFromDate(date1)
        time.text = timeFormatter.stringFromDate(date1)
        
        
    }
}