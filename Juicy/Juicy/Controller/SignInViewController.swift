//
//  SignInViewController.swift
//  Juicy
//
//  Created by Will Morphy on 19/11/18.
//  Copyright © 2018 Will Morphy. All rights reserved.
//

import UIKit
import Firebase

class SignInViewController: UIViewController {
    
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    
    var userUid: String!
    var email: String!
    var password: String!
    
    
override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // Additional functions
    func goToTabBarVC(){
        shouldPerformSegue(withIdentifier: "SignInToTabController", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //prepare the segue for the sign in to tab bar
        if segue.identifier == "SignInToTabController"{
            //set destination of segue = to NewsfeedViewController
            if let destination = segue.destination as? NewsFeedViewController{
            if ((userUid != nil) && (email != nil) && (password != nil)) {
                //set the destinations stored variables to the current VC's stored variables(Inputed variables)
                destination.userUid = self.userUid
                destination.email = self.email
                destination.password = self.password

            }
            }
        }
    }
    
    
    
    
    
    
    
    // Action functions
    @IBAction func signInTapped(_ sender: Any) {
        if let email = emailInput.text, let password = passwordInput.text{
            Auth.auth().signIn(withEmail: email, password: password, completion:
                {(user,error) in
                    if error == nil{
                        if let user = user{
                            
                            //set the current users inputs to the stored variables
                            self.userUid = user.user.uid
                            self.email = email
                            self.password = password

                            self.goToTabBarVC()
                            
                        }
                        
                    }
                    else{
                        print("Error")
                    }
            } )
        }
    }
    
    


}
