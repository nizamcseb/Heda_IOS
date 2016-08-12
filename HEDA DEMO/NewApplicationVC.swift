//
//  NewApplicationVC.swift
//  HEDA DEMO
//
//  Created by Nizamuddeen on 8/10/16.
//  Copyright © 2016 MST SOLUTIONS PRIVATE LIMITED. All rights reserved.
//

import UIKit
import DropDown
import SalesforceRestAPI
import SwiftSpinner



class NewApplicationVC: UIViewController, UITextFieldDelegate,SFRestDelegate {
    
    let sharedInstance = SFRestAPI.sharedInstance()
    
    
    
    var str_Fname = "",str_Mname = "",str_Lname = "",
    str_Email = "",str_WEmail = "",str_Mnumber = "",
    str_Term = "",str_Program = "",str_Gender = "",str_Marital = "",str_UserID = ""
    
    
    
    
    
    
    
    @IBOutlet var et_Fname: UITextField!
    
    @IBOutlet var et_Mname: UITextField!
    
    @IBOutlet var et_Lname: UITextField!
    
    @IBOutlet var et_Email: UITextField!
    
    @IBOutlet var et_Wemail: UITextField!
    
    @IBOutlet var et_Mobile: UITextField!
    
    
    var id:Int = 0
    
    let dD_Term = DropDown()
    let dD_Program = DropDown()
    let dD_Gender = DropDown()
    let dD_Marital = DropDown()
    
    let gender:[String] = ["Male", "Female"]
    let marital:[String] = ["Married", "Divorced", "Widowed","Seperated"]
    var term_name:[String] = []
    var term_id:[String] = []
    var program_name:[String] = []
    var program_id:[String] = []
    
    
    
    var Array_term:NSArray = []
    var Array_program:NSArray = []
    
    
    
    //var dataRows = NSArray()
    
    
    @IBOutlet var btn_term: UIButton!
    @IBOutlet var btn_program: UIButton!
    @IBOutlet var btn_gender: UIButton!
    @IBOutlet var btn_marital: UIButton!
    
    
    @IBAction func Action_Term(sender: AnyObject){
        
      
        
        
        dD_Term.anchorView = btn_term
        dD_Term.dataSource = term_name
        dD_Term.show()
        dD_Term.selectionAction = { [unowned self] (index, item) in
            self.btn_term.setTitle(item, forState: .Normal)
            
            self.str_Term = self.term_id[index]
            print("str_term selected \(self.str_Term)")
            
        }
    }
    
    
    @IBAction func Action_Program(sender: AnyObject){
        
        
        dD_Program.anchorView = btn_program
        dD_Program.dataSource = program_name
        dD_Program.show()
        dD_Program.selectionAction = { [unowned self] (index, item) in
            self.btn_program.setTitle(item, forState: .Normal)
            
            self.str_Program = self.program_id[index]
            print("str_Program selected \(self.str_Program)")
        }

    }
    
    @IBAction func Action_Gender(sender: AnyObject){
         dD_Gender.anchorView = btn_gender
        dD_Gender.dataSource = gender
        dD_Gender.show()
        dD_Gender.selectionAction = { [unowned self] (index, item) in
            self.btn_gender.setTitle(item, forState: .Normal)
            
            self.str_Gender=item
        }

        
    }
    
    @IBAction func Action_Marital(sender: AnyObject){
        dD_Marital.anchorView = btn_marital
        dD_Marital.dataSource = marital
        dD_Marital.show()
        dD_Marital.selectionAction = { [unowned self] (index, item) in
            self.btn_marital.setTitle(item, forState: .Normal)
            
            self.str_Marital=item
        }
    }
    
    
    @IBAction func Action_Apply(sender: AnyObject) {
        
        str_Fname = et_Fname.text!
        str_Mname = et_Mname.text!
        str_Lname = et_Lname.text!
        str_Email = et_Email.text!
        str_WEmail = et_Wemail.text!
        str_Mnumber = et_Mobile.text!
        str_UserID = SFRestAPI.sharedInstance().coordinator.credentials.userId
        
        print(str_UserID)
        
        
        
        
       
        
        
        let app_objectType = "Application__c"
        
       
        
        let formfields: [String : AnyObject] = [
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
            "Married__c" : str_Marital
        ]
        
        print(formfields)
        
        let request = sharedInstance.requestForCreateWithObjectType(app_objectType, fields: formfields)
        SFRestAPI.sharedInstance().send(request, delegate: self)
        id=33
        
         SwiftSpinner.show("Applying Please wait...")
        
    }
    
    
    // #pragma mark - SFRestAPIDelegate
    func request(request: SFRestRequest, didLoadResponse jsonResponse: AnyObject) {
        
        
        print("jsonResponse \(jsonResponse)")
        
        if id==23 {
            
            let records = jsonResponse.objectForKey("records") as! NSArray
        
        self.Array_term = records
        
        print("request:didLoadResponse: #records: \(records)");
        
        
        for var i = 0; Array_term.count > i; i += 1 {
            
        let obj : AnyObject! =  Array_term.objectAtIndex(i)
        
            let name = obj.objectForKey("Name") as! String
            let id = obj.objectForKey("Id") as! String
            
            print("term name = \(name) id = \(id)")
            
            
            term_name.append(name)
            term_id.append(id)
        }
            
            
        
        send_program()
        
        dispatch_async(dispatch_get_main_queue(), {
            //self.term.reloadData()
            self.dD_Term.reloadAllComponents()
        })
            
            
        }else if id==24{
            
            let records = jsonResponse.objectForKey("records") as! NSArray
        
            self.Array_program = records
            
            print("request:didLoadResponse: #records: \(records)");
            
            
            for var i = 0; Array_program.count > i; i += 1 {
                
                let obj : AnyObject! =  Array_program.objectAtIndex(i)
                
                let name = obj.objectForKey("Name") as! String
                let id = obj.objectForKey("Id") as! String
                
                print("program name = \(name) id = \(id)")
                
                program_name.append(name)
                program_id.append(id)
            }
            
            
            dispatch_async(dispatch_get_main_queue(), {
                //self.term.reloadData()
                self.dD_Program.reloadAllComponents()
            })
        
        }else if id==33{
          
            
            let records = jsonResponse.objectForKey("success") as! CFBoolean
            
            print("request:didLoadResponse: #records: \(records)");
            
            if records==1{
            
            print("true")
                
                alert_success()
                
            }else {
            
            print("false")
                
               alert_error()
            }

        
        }
        
       
    }
    
    
    
    func request(request: SFRestRequest, didFailLoadWithError error:NSError) {
        print("In Error: \(error)")
        
        alert_error()
        
    }
    
    func requestDidCancelLoad(request: SFRestRequest) {
        print("In requestDidCancelLoad \(request)")
        alert_error()
       
    }
    
    
    func requestDidTimeout(request: SFRestRequest) {
        print("In requestDidTimeout \(request)")
       alert_error()
    }
    
    func alert_success(){
        
         SwiftSpinner.hide()
        let alert = UIAlertController(title: "Message", message: "Application created successfully ", preferredStyle: UIAlertControllerStyle.Alert)
        //alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { action in
            switch action.style{
            case .Default:
                print("default")
                self.navigationController?.popViewControllerAnimated(true)
                
            case .Cancel:
                print("cancel")
                self.navigationController?.popViewControllerAnimated(true)
                
            case .Destructive:
                print("destructive")
                self.navigationController?.popViewControllerAnimated(true)
            }
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    
    }

    func alert_error(){
         SwiftSpinner.hide()
    
        let alert = UIAlertController(title: "Alert", message: "Application not created, please try again.. ", preferredStyle: UIAlertControllerStyle.Alert)
        //alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { action in
            switch action.style{
            case .Default:
                print("default")
                //self.navigationController?.popViewControllerAnimated(true)
                
            case .Cancel:
                print("cancel")
                //self.navigationController?.popViewControllerAnimated(true)
                
            case .Destructive:
                print("destructive")
                //self.navigationController?.popViewControllerAnimated(true)
            }
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        print("view will appear")
    }
    
    
    override func viewDidLoad() {
         super.viewDidLoad()
       
        et_Fname.text="IOStestFname"
        et_Mname.text="IOStestMname"
        et_Lname.text="IOStestLname"
        et_Email.text="nizamcseb@gmail.com"
        et_Wemail.text="nizamuddeen@mstsolutions.com"
        et_Mobile.text="9994471706"
        
        
        send_term()
       
        
      
        
        //Looks for single or multiple taps.
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(NewApplicationVC.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func send_term() {
        
        let request = sharedInstance.requestForQuery("SELECT Id,Name FROM hed__Term__c")
        sharedInstance.send(request, delegate: self)
        id=23
    
    }
    func send_program() {
        let request = sharedInstance.requestForQuery("SELECT Id,Name FROM Account")
        sharedInstance.send(request, delegate: self)
        id=24
    }
    
    
    
   
}


