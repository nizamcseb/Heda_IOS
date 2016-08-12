//
//  CourcesViewController.swift
//  HEDA DEMO
//
//  Created by Nizamuddeen on 8/10/16.
//  Copyright © 2016 MST SOLUTIONS PRIVATE LIMITED. All rights reserved.
//

import UIKit
import SalesforceRestAPI
import SwiftSpinner

class CourcesViewController: UIViewController,UITableViewDelegate,SFRestDelegate {
    
    
    var color: UIColor = UIColor(red:0.91, green:0.56, blue:0.56, alpha:1.0)
    
    let sharedInstance = SFRestAPI.sharedInstance()
    
    var dataRows = NSArray()
    @IBOutlet var tableView: UITableView!
    
    
    override func viewWillAppear(animated: Bool) {
        print("view will appear")
        
        //self.title = "Mobile SDK Sample App"
        SwiftSpinner.show("Connecting to satellite...")
        
        let request = sharedInstance.requestForQuery("SELECT Id,Name FROM Account")
        sharedInstance.send(request, delegate: self)
        
        //Important Swift- Make sure to register table cell for a non storyboard apps like this one
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
    }
    override func viewWillDisappear(animated: Bool) {
        SwiftSpinner.hide()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    func upsertEntries(entries: AnyObject, toSoup soupName: String, withExternalIdPath externalIdPath: String, error: NSError?) -> AnyObject {
        
        return entries
    }
    
    // #pragma mark - SFRestAPIDelegate
    func request(request: SFRestRequest, didLoadResponse jsonResponse: AnyObject) {
        let records = jsonResponse.objectForKey("records") as! NSArray
        print("request:didLoadResponse: #records: \(records.count)");
        self.dataRows = records
        SwiftSpinner.hide()
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
        })
    }
    
    
    
    
    func request(request: SFRestRequest, didFailLoadWithError error:NSError) {
        print("In Error: \(error)")
        SwiftSpinner.show("Failed to connect, Error ", animated: false)
    }
    
    func requestDidCancelLoad(request: SFRestRequest) {
        print("In requestDidCancelLoad \(request)")
        SwiftSpinner.show("Failed to connect, Canceled ", animated: false)
    }
    
    
    func requestDidTimeout(request: SFRestRequest) {
        print("In requestDidTimeout \(request)")
        SwiftSpinner.show("Failed to connect, Timeout ", animated: false)
    }
    
    
    // #pragma mark - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(self.dataRows)
        return self.dataRows.count;
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell")! as UITableViewCell
        //if (cell == nil) {
        cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "Cell")
        //}
        let image = UIImage(named:"icon.png")
        cell.imageView!.image = image
        
        let obj : AnyObject! =  dataRows.objectAtIndex(indexPath.row)
        
        let name = obj.objectForKey("Name") as! String
        cell.textLabel!.text = obj.objectForKey("Name") as? String
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell.backgroundColor = color
        return cell
    }
    

    
}
