//
//  PostMakingViewController.swift
//  Juicy
//
//  Created by Will Morphy on 3/12/18.
//  Copyright © 2018 Will Morphy. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import SwiftKeychainWrapper
import MapKit
import CoreLocation


class PostMakingViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var captionTextField: UITextField!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longtitudeLabel: UILabel!
    @IBOutlet weak var imagePickedView: UIImageView!
    
    var userUid: String!
    var username: String!
    
    
    var imagePicker:UIImagePickerController!
    var imageSelected = false
    var selectedImage: UIImage!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        captionTextField.delegate = self
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addImageButtonPressed(_ sender: Any) {
        
        let actionSheet = UIAlertController(title: "Add an image", message: "choose a scource", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction) in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                self.imagePicker.sourceType = UIImagePickerController.SourceType.camera
                self.imagePicker.cameraCaptureMode = .photo
                self.imagePicker.modalPresentationStyle = .fullScreen
                self.imagePicker.allowsEditing = true
                self.present(self.imagePicker, animated: true, completion: nil)
            }
            else{
                print("Camera not available")
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "PhotoLibrary", style: .default, handler: {(action: UIAlertAction) in
            
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
       
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
        self.captionTextField.text = "The photo failed"
    }
    
    
    //Image Picker Controller
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            self.imagePickedView.image = image
            self.selectedImage = image
            self.imageSelected = true
        }
        else{
            print("a valid picture wasnt selected")
        }
        imagePicker.dismiss(animated: true, completion: nil )
        
    }
    
    
    
    
    
    @IBAction func postButtonPressed(_ sender: Any) {

        //upload data to the database and
        self.uploadData()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func uploadData(){
        
        
        guard let img = imagePickedView.image, imageSelected == true else {
            print("image must be selected")
            return
        }
        
        if let imgData = selectedImage.jpegData(compressionQuality: 0.2){
            
            let imgUid = NSUUID().uuidString
            
            let metadata = StorageMetadata()
            
            metadata.contentType = "image/jpeg"
            
            Storage.storage().reference().child("post-pics").child(imgUid).putData(imgData, metadata: metadata) {
                (metadata, error) in
                
                if error != nil{
                    print("image wasnt saved")
                }
                else{
                    print("image was saved")
                }
                
                Storage.storage().reference().child("post-pics").child(imgUid).downloadURL(completion: { (url, error) in
                    if error != nil {
                        print(error!)
                    } else {
                        let downloadURL = url?.absoluteString
                        if let url = downloadURL {
                            
                            //posts the user information to the firebase database with profile image
                            self.setUpPost(img: url)
                        }
                    }
                }
                )}
        }
        
    }
    
    
    func setUpPost(img: String) {
        let userID = Auth.auth().currentUser?.uid
        
        Database.database().reference().child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let data = snapshot.value as! Dictionary<String, AnyObject>
            let caption = self.captionTextField.text
            let username = data["username"]
            
            let post: Dictionary<String, AnyObject> = [
                "userId": userID as AnyObject,
                "username": username!,
                "imgUrl":  img as AnyObject,
                "caption": caption as AnyObject
            ]
            
            let firebasePost = Database.database().reference().child("posts").childByAutoId()
            
            firebasePost.setValue(post)
            
            self.imageSelected = false
            
        })
    }
        
        
        
        
        
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
