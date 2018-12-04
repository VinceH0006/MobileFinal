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
import FirebaseAuth
import SwiftKeychainWrapper


class RegisterViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    

    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var imagePickerButton: UIButton!
    @IBOutlet weak var userImagePickerUIView: UIImageView!
    
    
    var userNameVar: String!
    var emailVar: String!
    var userUid: String!
    
    var imagePicker: UIImagePickerController!
    var imageSelected = false
    var selectedImage: UIImage!
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Image picker set up
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true

    }
    
    
    //Keychain wrapper
    func keychain(){
        KeychainWrapper.standard.set(userUid, forKey: "uid")
    }
    
    
    //Image picker pressed present image picker
    @IBAction func imagePickerPressed(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil )
    }
    
    
    //register pressed
    //saves the email password to the database as a new user
    //calls upoad data
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
                    //upload data to the database and
                   self.uploadData()
            }
         
        }
        
    }
    
    
    
    
    //If both username and email are not full save image to the database
    func uploadData(){
        if userName.text != nil && emailInput.text != nil{
            userNameVar = userName.text
            emailVar = emailInput.text
        }
        
        guard let img = userImagePickerUIView.image, imageSelected == true else {
            print("image must be selected")
            return
        }
       
        if let imgData = selectedImage.jpegData(compressionQuality: 0.2){
            
            let imgUid = NSUUID().uuidString
            
            let metadata = StorageMetadata()
            
            metadata.contentType = "image/jpeg"
            
            Storage.storage().reference().child("profile-pics").child(imgUid).putData(imgData, metadata: metadata) {
                (metadata, error) in
                
                if error != nil{
                    print("image wasnt saved")
                }
                else{
                    print("image was saved")
                }
                
                Storage.storage().reference().child("profile-pics").child(imgUid).downloadURL(completion: { (url, error) in
                    if error != nil {
                        print(error!)
                    } else {
                        let downloadURL = url?.absoluteString
                        if let url = downloadURL {
                        
                            //posts the user information to the firebase database with profile image
                            self.setUpUser(img: url)
                        }
                    }
                }
                )}
        }
    
    }
    
    
    
    func setUpUser(img: String) {
        
        let userData = [
            "username": userNameVar!,
            "email": emailVar! ,
            "profile-image": img
        ]
        
        keychain()
        
        let setLocation = Database.database().reference().child("users").child(userUid)
        
        setLocation.setValue(userData)
        
        print("saved user info to database")
        
    }
    
    
    
    
    //Image Picker Controller
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            userImagePickerUIView.image = image
            selectedImage = image
            imageSelected = true
        }
        else{
            print("a valid picture wasnt selected")
        }
        imagePicker.dismiss(animated: true, completion: nil )
        
    }

}
