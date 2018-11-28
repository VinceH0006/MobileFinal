//
//  Post.swift
//  Juicy
//
//  Created by Will Morphy on 28/11/18.
//  Copyright © 2018 Will Morphy. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase


//When you have the time make private
//Add likes at some point

class Post{
    var _username: String!
   // var location: String
    var _postImg: String!
    var _caption: String!
    
    
    var _postKey: String!
    var _postRef: DatabaseReference!
    
    init(name: String, img: String, caption: String) {
        _username = name
        _postImg = img
        _caption = caption
    }
    
    init(postKey: String, postData: Dictionary<String, AnyObject> ) {
        
        _postKey = postKey
        
        if let username = postData["userName"] as? String{
            _username = username
        }
        
        if let image = postData["imgUrl"] as? String{
            _postImg = image
        }
        
        if let caption = postData["caption"] as? String{
            _caption = caption
        }
        
        _postRef = Database.database().reference().child("posts").child(postKey)
    }
    
}
