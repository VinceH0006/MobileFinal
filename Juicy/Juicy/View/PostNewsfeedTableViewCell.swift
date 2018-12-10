//
//  PostNewsfeedTableViewCell.swift
//  Juicy
//
//  Created by Will Morphy on 19/11/18.
//  Copyright © 2018 Will Morphy. All rights reserved.
//

//Things to do
//attach all of the IB things to this 

import UIKit
import FirebaseDatabase
import FirebaseStorage


class PostNewsfeedTableViewCell: UITableViewCell {
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var caption: UILabel!
    @IBOutlet weak var userProfilePhoto: UIImageView!
    
    
    var post: Post!
    var userPostKey: DatabaseReference!
    var userID:String!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userProfilePhoto.layer.cornerRadius = userProfilePhoto.frame.width/2
        userProfilePhoto.clipsToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //When the newsfeed loads the cell the post is sent here and then loads in the information.
    func configCell(post: Post, img: UIImage? = nil){
        self.post = post
        self.username.text = post._username
        self.caption.text = post._caption
        
        //UserID
        self.userID = post._userID
        getUserProfilePhoto()
        
        if img != nil{
            self.postImg.image = img
            print("img does not equal nill in config cell")
        }
        else {
            let ref = Storage.storage().reference(forURL: post._postImg)
            ref.getData(maxSize:  10000000, completion: { (data, error) in
                if error != nil{
                    print("couldnt load img")
                } else {
                    if let imgData = data {
                        if let img = UIImage(data: imgData){
                            self.postImg.image = img
                        }
                    }
                }
                
            })
        }
        
    }
    
    //Gets the user that posted the posts profile photo url and assigns that to the profile photo
    func getUserProfilePhoto(){
        Database.database().reference().child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let data = snapshot.value as! Dictionary<String, AnyObject>
            
            if let imgURL = data["profile-image"] as? String{
                let ref = Storage.storage().reference(forURL: imgURL)
                        ref.getData(maxSize:  10000000, completion: { (data, error) in
                            if error != nil{
                                print("couldnt load img")
                            } else {
                                if let imgData = data {
                                    if let img = UIImage(data: imgData){
                                        self.userProfilePhoto.image = img
                                    }
                                }
                            }
                
                        })
            }
        })
    }
    
    
    
    
    /*Future abstraction of the converter*/
//    //Converts image url to UIimage
//    func convertURLToImage(url: String) -> UIImage {
//
//        var finalImg = UIImage()
//
//        let ref = Storage.storage().reference(forURL: url)
//        ref.getData(maxSize:  10000000, completion: { (data, error) in
//            if error != nil{
//                print("couldnt load img")
//            } else {
//                if let imgData = data {
//                    if let img = UIImage(data: imgData){
//                        print("done")
//
//                    }
//                }
//            }
//
//        })
//        return finalImg
//    }

}
