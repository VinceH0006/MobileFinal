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
    
    
    
    func setUpUser(){
        if userName.text != nil{
            userNameVar = userName.text
        }
        
        let userData = [
            "userName": userNameVar!
        ]
        
        let setLocation = Database.database().reference().child("users").child(userUid)
        
        setLocation.setValue(userData)
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
                
                
            }
        }
        
    }

}
