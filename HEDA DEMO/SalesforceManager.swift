//
//  SalesforceManager.swift
//  SFsdkApp
//
//  Created by Suriya on 7/27/16.
//  Copyright © 2016 MST SOLUTIONS PRIVATE LIMITED. All rights reserved.
//

import UIKit

import SalesforceSDKCore
import SalesforceRestAPI

public class SalesforceManager : NSObject {
    
    //Define a shared instance for singleton
    static let sharedInstance = SalesforceManager()
    
    //let errorDomain = "com.centare.contactforce.salesforcemanager"
    
    var consumerKey:String = ""
    var redirectUrl:String = ""
    
    private override init() {
        super.init()
        //Perform any setup - load the salesforce configuration
        
        SFLogger.setLogLevel(.Debug)
        
        consumerKey = "3MVG9Iu66FKeHhINtJPyHH.KFiCb9j4SQbsKqqcPBsVwxhBfTokt0n_1mC6db1.ZF35YRrko665y085zpyG7E"  //Loaded from Configuration class in my example app
        redirectUrl = "https://test.salesforce.com/services/oauth2/success"  //Loaded from Configuration class in my example app
    }
    
    func setupSDKManager() {
        let salesforceSDKManager = SalesforceSDKManager.sharedManager()
        salesforceSDKManager.connectedAppId = self.consumerKey
        salesforceSDKManager.connectedAppCallbackUri = self.redirectUrl
        
        salesforceSDKManager.authScopes = ["web", "api"]
        
        //Post launch action handler
        salesforceSDKManager.postLaunchAction = { launchActionList in
            let launchActionString = SalesforceSDKManager.launchActionsStringRepresentation(launchActionList)
            print("postLaunchAction: \(launchActionString)")
        }
        
        //Launch error handler
        salesforceSDKManager.launchErrorAction = { error, launchActionList in
            //Log the error
            print("Error during launch of Salesforce SDK: \(error.localizedDescription)")
        }
        
        //Post logout action
        salesforceSDKManager.postLogoutAction = {
            print("SalesforceSDK log out.")
            
            //TODO: Reset app state
        }
    }
    
    func launch() {
        SalesforceSDKManager.sharedManager().launch()
    }
}
