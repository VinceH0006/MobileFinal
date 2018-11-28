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
    
    
    var post: Post!
    var userPostKey: DatabaseReference!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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

}
