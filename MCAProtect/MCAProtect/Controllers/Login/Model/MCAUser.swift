//
//  MCAUser.swift
//  MCAProtect
//
//  Created by Sarath NS on 3/27/17.
//  Copyright © 2017 Accionlabs. All rights reserved.
//

import UIKit

class MCAUser: NSObject {

    var brokerID: Int!
    var brokarageFirmID : Int!
    var brokerUID : String!
    var brokerEmail : String!
    var brokerContactNumber : String!
    var brokerContactName : String!
    var userType : Int!

    
    
    /*
 {
 "data":
 {
 "id": 6,
 "provider": "email",
 "uid": "broker085@gmail.com",
 "brokerage_firm_id": 1,
 "contact_name": "Test Broker1",
 "business_name": "Ply Woods",
 "email": "broker085@gmail.com",
 "contact_number": "7777777777",
 "profile_picture_file_name": null,
 "profile_picture_content_type": null,
 "profile_picture_file_size": null,
 "profile_picture_updated_at": null,
 "active": true,
 "status": 0,
 "unix_timestamp": 1486983333,
 "admin_id": null,
 "image_url": "https://mcaprotect-dev-storage.s3.amazonaws.com/profile-images/1486979609971-Df3yv7vvkcZvETgG.jpg"
 }
 }
 */
 
 
    init(loginUserData: Dictionary<String,AnyObject>! , userLoginType: Int)
    {
        
        let userData = loginUserData["data"] as! Dictionary<String,AnyObject>
        
        if nil == userData
        {
            brokerID      = 67
            brokarageFirmID    = 68
            brokerUID  = "Glink Lender"
            brokerEmail        = "Glink Lender"
            brokerContactNumber       = "Monthly"
            brokerContactName          = "Glink Lender"
            userType = userLoginType
        }
        else
        {
            brokerID            = userData["id"] as! Int
            brokarageFirmID     = userData["brokerage_firm_id"]  as! Int
            brokerUID           = MCAUtilities.getnilcheckedStringValue(stringToNilCheck: userData["uid"] as! String?)
            brokerEmail         = MCAUtilities.getnilcheckedStringValue(stringToNilCheck: userData["email"] as! String?)
            brokerContactNumber = MCAUtilities.getnilcheckedStringValue(stringToNilCheck: userData["contact_number"] as! String?)
            brokerContactName   = MCAUtilities.getnilcheckedStringValue(stringToNilCheck: userData["contact_name"] as! String?)
            
            userType = userLoginType
        }
    }

    
}
