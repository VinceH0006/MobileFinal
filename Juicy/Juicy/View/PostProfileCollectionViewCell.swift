//
//  PostProfileCollectionViewCell.swift
//  Juicy
//
//  Created by Will Morphy on 19/11/18.
//  Copyright © 2018 Will Morphy. All rights reserved.
//



//Things to do
//1. Attach image in IB to this

import UIKit
import FirebaseDatabase
import FirebaseStorage


class PostProfileCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var postImage: UIImageView!
    
    
    var post: Post!
    var userPostKey: DatabaseReference!
    var userID:String!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        postImage.layer.cornerRadius = 4
        postImage.clipsToBounds = true
        // Initialization code
    }

    //When the newsfeed loads the cell the post is sent here and then loads in the information.
    func configCell(post: Post){
        
        self.post = post

        let ref = Storage.storage().reference(forURL: post._postImg)

        ref.getData(maxSize:  10000000, completion: { (data, error) in
            if error != nil{
                print("couldnt load img")
            } else {
                if let imgData = data {
                    if let img = UIImage(data: imgData){
                        self.postImage.image = img
                    }
                }
            }

        })
        

    }

}
