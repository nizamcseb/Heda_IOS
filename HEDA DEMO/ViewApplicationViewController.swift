//
//  ViewApplicationViewController.swift
//  HEDA DEMO
//
//  Created by Nizamuddeen on 8/12/16.
//  Copyright © 2016 MST SOLUTIONS PRIVATE LIMITED. All rights reserved.
//

import UIKit
import SalesforceRestAPI
import SwiftSpinner

class ViewApplicationViewController: UIViewController,SFRestDelegate {
    
    
    var id:String?
    let sharedInstance = SFRestAPI.sharedInstance()
    
    override func viewWillAppear(animated: Bool) {
        
        SwiftSpinner.show("Connecting to satellite...")
        
      /*
        "FirstName__c" : str_Fname,
        "LastName__c" : str_Lname,
        "MiddleName__c" : str_Mname,
        "Term__c" : str_Term,
        "Program_Account__c" : str_Program,
        "ownerId" : str_UserID,
        "Gender__c" : str_Gender,
        "ReferenceEmail2__c" : str_Email,
        "WorkEmail__c" : str_WEmail,
        "Mobile__c" : str_Mnumber,
        "Married__c" : str_Marital*/

        
        var query = "SELECT Name ,FirstName__c,LastName__c,MiddleName__c,Term__c, Program_Account__c,ownerId,Gender__c,ReferenceEmail2__c,WorkEmail__c,Mobile__c,Married__c FROM Application__c Where Id='"+id!+"'"
        
        print("query  \(query)")
        
        let request = sharedInstance.requestForQuery(query)
        sharedInstance.send(request, delegate: self)
        
    }
    override func viewDidLoad() {
        
        print(id)
    }
    
    func request(request: SFRestRequest, didLoadResponse jsonResponse: AnyObject) {
        let records = jsonResponse.objectForKey("records") as! NSArray
        print("request:didLoadResponse: #records: \(records.count)");
        
        print(jsonResponse)
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
    
}
