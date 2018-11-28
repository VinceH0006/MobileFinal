//
//  RegisterViewController.swift
//  Juicy
//
//  Created by Will Morphy on 19/11/18.
//  Copyright © 2018 Will Morphy. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import SwiftKeychainWrapper


class RegisterViewController: UIViewController {
    

    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    
    var userNameVar: String!
    var emailVar: String!
    var userUid: String!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func keychain(){
        KeychainWrapper.standard.set(userUid, forKey: "uid")
    }
    
    
    //Passing information about the user to the database, sets up the collection as you save it
    func setUpUser(){
        if userName.text != nil && emailInput.text != nil{
            userNameVar = userName.text
            emailVar = emailInput.text
        }
        
        let userData = [
            "username": userNameVar!,
            "email": emailVar!
        ]
        keychain()
        
        let setLocation = Database.database().reference().child("users").child(userUid)
        
        setLocation.setValue(userData)
        
        print("saved user info to database")
    }
    
    

    @IBAction func registerPressed(_ sender: Any) {

        //Set up a new user on our Firebase database
        Auth.auth().createUser(withEmail: emailInput.text!, password: passwordInput.text!) { (user, error) in

            if error != nil {
                print(error!)
                
                
            } else {
                if let user = user{
                    //set the current users inputs to the stored variables
                    self.userUid = user.user.uid
                    self.performSegue(withIdentifier: "RegisterToTabController", sender: self)
                }
                   self.setUpUser()
            }
         
        }
        
    }

}
