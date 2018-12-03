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

class PostProfileCollectionViewCell: UICollectionViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
//
//    //When the newsfeed loads the cell the post is sent here and then loads in the information.
//    func configCell(post: Post, img: UIImage? = nil){
//        self.post = post
//        self.username.text = post._username
//        self.caption.text = post._caption
//
//        if img != nil{
//            self.postImg.image = img
//            print("img does not equal nill in config cell")
//        }
//        else {
//            let ref = Storage.storage().reference(forURL: post._postImg)
//
//
//            ref.getData(maxSize:  10000000, completion: { (data, error) in
//                if error != nil{
//                    print("couldnt load img")
//                } else {
//                    if let imgData = data {
//                        if let img = UIImage(data: imgData){
//                            self.postImg.image = img
//                        }
//                    }
//                }
//
//            })
//        }
//
//    }

}
