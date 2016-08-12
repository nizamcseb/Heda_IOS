//
//  ProfileViewController.swift
//  HEDA DEMO
//
//  Created by Nizamuddeen on 8/10/16.
//  Copyright © 2016 MST SOLUTIONS PRIVATE LIMITED. All rights reserved.
//
import UIKit
import SalesforceSDKCore
import SalesforceRestAPI



class ProfileViewController: UIViewController{
    
    
    @IBOutlet var tvName: UILabel!
    
    @IBOutlet var tvMobileNumber: UILabel!
    
    @IBOutlet var tvEmail: UILabel!
    
    
    @IBAction func ActionLogout(sender: AnyObject) {
        
        
       // self.log(SFLogLevelDebug, msg: "Logout notification received.  Resetting app.")
       // self.initializeAppViewState()
        SFAuthenticationManager.sharedManager().logout()
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tvName.text=SFUserAccountManager.sharedInstance().currentUser?.fullName
        tvEmail.text=SFUserAccountManager.sharedInstance().currentUser?.email
        tvMobileNumber.text="9994471706"
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
