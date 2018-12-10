//
//  Profile.swift
//  Juicy
//
//  Created by Will Morphy on 10/12/18.
//  Copyright © 2018 Will Morphy. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase


class Profile{
    var username: String!
    var imageAddress: String!

    //The profile key is also the unique user ID
    var profileKey: String!
    var profileRef: DatabaseReference!
    
    
    
    
    init(Name: String, Image: String) {
        self.username = Name
        self.imageAddress = Image
    }
    
    
    init(profileKey: String, profileData: Dictionary<String, AnyObject> ) {
        
        self.profileKey = profileKey
        
        if let username = profileData["username"] as? String{
            self.username = username
        }
       
        if let image = profileData["profile-image"] as? String{
            self.imageAddress = image
        }
      
        self.profileRef = Database.database().reference().child("users").child(profileKey)
    }
}
