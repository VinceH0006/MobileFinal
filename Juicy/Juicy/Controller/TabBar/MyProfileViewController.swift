//
//  MyProfileViewController.swift
//  Juicy
//
//  Created by Will Morphy on 19/11/18.
//  Copyright © 2018 Will Morphy. All rights reserved.
//



//Stuff to do
//1. add collection delegate and collection datasource

import UIKit
import Firebase
import FirebaseAuth
import SwiftKeychainWrapper

class MyProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
   
    
    
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var postsCollectionView: UICollectionView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postsCollectionView.delegate = self
        postsCollectionView.delegate = self

        // Do any additional setup after loading the view.
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let  cell = postsCollectionView.dequeueReusableCell(withReuseIdentifier: "PostProfileCollectionViewCell", for: indexPath) as! PostProfileCollectionViewCell
        
        print("Success")
        return cell
    }

    @IBAction func signOut(_ sender: Any) {
        try! Auth.auth().signOut()
        
        KeychainWrapper.standard.removeObject(forKey: "uid")
        dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
