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
    var data1:[PFObject]!
    var filtered:[PFObject]!
    
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        search()

    }
    
    
    
    func search(searchTextUsername: String? = nil, searchTextFull : String? = nil){
        let query = PFQuery(className: "_User")
        let query1 = PFQuery(className: "_User")

        if(searchTextUsername != nil){
            query.whereKey("username", containsString: searchTextUsername)
        }
        if (searchTextUsername != nil) {
            query1.whereKey("FullName", containsString: searchTextFull)
        }
        query.findObjectsInBackgroundWithBlock { (results, error) -> Void in
            self.data = results as? [PFObject]
            self.tableView.reloadData()
        }
        query1.findObjectsInBackgroundWithBlock { (results, error) -> Void in
            self.data1 = results as? [PFObject]
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
        cell.usernameLabel.text = obj["username"] as? String
        return cell
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true
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
}
