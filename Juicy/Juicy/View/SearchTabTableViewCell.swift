//
//  SearchTabTableViewCell.swift
//  Juicy
//
//  Created by Will Morphy on 10/12/18.
//  Copyright © 2018 Will Morphy. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import FirebaseCore

class SearchTabTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    
    var profile: Profile!
    var userPostKey: DatabaseReference!
    var userID:String!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImageView.layer.cornerRadius = profileImageView.frame.width/2
        profileImageView.clipsToBounds = true
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    
    //When the search loads the cell the post is sent here and then loads in the information.
    func configCell(profile: Profile, img: UIImage? = nil){
        
        self.profile = profile
        self.profileNameLabel.text = profile.username
        
        //UserID
        self.userID = profile.profileKey
        
        if img != nil{
            self.profileImageView.image = img
            print("img does not equal nill in config cell")
        }
        else {
            let ref = Storage.storage().reference(forURL: profile.imageAddress)
            ref.getData(maxSize:  10000000, completion: { (data, error) in
                if error != nil{
                    print("couldnt load img")
                } else {
                    if let imgData = data {
                        if let img = UIImage(data: imgData){
                            self.profileImageView.image = img
                        }
                    }
                }
                
            })
        }
        
    }

}
