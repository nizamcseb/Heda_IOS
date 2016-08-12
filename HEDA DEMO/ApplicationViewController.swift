//
//  FirstViewController.swift
//  HEDA DEMO
//
//  Created by Nizamuddeen on 8/10/16.
//  Copyright © 2016 MST SOLUTIONS PRIVATE LIMITED. All rights reserved.
//

import UIKit
import SalesforceRestAPI
import SwiftSpinner



class ApplicationViewController: UIViewController,UITableViewDelegate,SFRestDelegate {
    
    var color: UIColor = UIColor(red:0.56, green:0.78, blue:0.91, alpha:1.0)
    
    
    
    let sharedInstance = SFRestAPI.sharedInstance()
    
    var dataRows = NSArray()
    var application_id:[String] = []
    var id_index:Int?
    
    @IBOutlet var tableView: UITableView!
    
    
    override func viewWillAppear(animated: Bool) {
        print("view will appear")
        //self.title = "Mobile SDK Sample App"
        
        
            SwiftSpinner.show("Connecting to satellite...")
            
            let request = sharedInstance.requestForQuery("SELECT Id,Name FROM Application__c ORDER BY Name DESC")
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
        
        for var i = 0; dataRows.count > i; i += 1 {
            
            let obj : AnyObject! =  dataRows.objectAtIndex(i)
            
            let name = obj.objectForKey("Name") as! String
            let id = obj.objectForKey("Id") as! String
            
            print("Application name = \(name) id = \(id)")
            
            application_id.append(id)
            //program_id.append(id)
        }

        
        SwiftSpinner.hide()
        
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
        })
    }
    
    
    
    
    func request(request: SFRestRequest, didFailLoadWithError error:NSError) {
        print("In Error: \(error)")
         SwiftSpinner.show("Failed to connect, Error ", animated: false)
        SwiftSpinner.hide()
    }
    
    func requestDidCancelLoad(request: SFRestRequest) {
        print("In requestDidCancelLoad \(request)")
        SwiftSpinner.show("Failed to connect, Canceled ", animated: false)
        SwiftSpinner.hide()
    }
    
    
    func requestDidTimeout(request: SFRestRequest) {
        print("In requestDidTimeout \(request)")
        SwiftSpinner.show("Failed to connect, Timeout ", animated: false)
        SwiftSpinner.hide()
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("Row \(indexPath.row)selected")
        
        id_index=indexPath.row
        
        performSegueWithIdentifier("idSagueApplication", sender: self)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        if(segue.identifier == "idSagueApplication") {
            var vc = segue.destinationViewController as! ViewApplicationViewController
            vc.id = self.application_id[id_index!]
            //vc.lblDetail = selectedLabel
        }
    }


}

