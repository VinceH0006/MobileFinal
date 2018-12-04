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
import FirebaseDatabase
import FirebaseStorage
import SwiftKeychainWrapper
import MapKit
import CoreLocation

class MyProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegateFlowLayout {
    
    
    
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var postsCollectionView: UICollectionView!
    @IBOutlet weak var usernameLabel: UILabel!
  
    
    
    var imagePicker:UIImagePickerController!
    var imageSelected = false
    var selectedImage: UIImage!
    var userID: String!

    var posts = [Post]()
    var post:  Post!
    
    
    
    var manager = CLLocationManager()
    var currentLocation: CLLocation!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Get the current users userID
        self.userID = Auth.auth().currentUser?.uid
        
        //CollectionView for Posts
        postsCollectionView.delegate = self
        postsCollectionView.dataSource = self
        
        
        //LocationManager for Location delegate
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        
        //Image picker
        imagePicker = UIImagePickerController() 
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        
        //load data
        loadProfileInfoFromDB()
        
        //Profile photo
        profilePhoto.layer.cornerRadius = 10
        profilePhoto.clipsToBounds = true

        //download posts
        downloadPosts()
        print(posts.count)
        
    }
    
    /* Download posts Functionality */
    //Download posts from DB that have same userID as current user
    func downloadPosts(){
        //accesses database "posts" and observes the data in a snapshot
        //Adds to posts array if it has the same user id as current user
        Database.database().reference().child("posts").observe(.value, with:
            {(snapshot) in
                

                if let snapshot = snapshot.children.allObjects as? [DataSnapshot]{
                    
                    //clears the posts array so that when we add a new one it doesn't show them all again
                    self.posts.removeAll()
                    
                    //Runs through all the data in a for loop and appends it to posts
                    for data in snapshot {
                        if let postDict = data.value as? Dictionary<String, AnyObject>{
    
                            if postDict["userId"] as! String == self.userID {
                                let key = data.key
                                let post = Post(postKey: key, postData: postDict)
                                
                                self.posts.append(post)
                            }
                        }
                    }
                }
                self.postsCollectionView.reloadData()
        })
    }
    
    
    
    /* Change profile functionality  */
    //Change profile photo button pressed
    @IBAction func changePhotoPressed(_ sender: Any) {
         present(imagePicker, animated: true, completion: nil)
    }
    
    //Image Picker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            profilePhoto.image = image
            selectedImage = image
            imageSelected = true
        }
        else{
            print("a valid picture wasnt selected")
        }
        imagePicker.dismiss(animated: true, completion: nil )
        
        guard imageSelected == true else{
            print("image needs to be selected")
            
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
                            //Post the image selected to firebase
                            self.postToFirebase(imgUrl: url)
                        }
                    }
                }
                )}
        }
        
    }
    
    //Post the new image to Firbase
    func postToFirebase(imgUrl: String){
        
        let userID = Auth.auth().currentUser?.uid
        
        _ = Database.database().reference().root.child("users").child(userID!).updateChildValues(["profile-image": imgUrl])
        
        self.imageSelected = false
        
    }
    
    
    
    /* Load content for profile */
    func loadProfileInfoFromDB(){
        if let userID = self.userID{
            Database.database().reference().child("users").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
                
                let data = snapshot.value as! Dictionary<String, AnyObject>
                
                //Accessing information from the DB for current user
                let username = data["username"] as? String
                let url = data["profile-image"] as? String
                
                //assign the username label and userID
                self.usernameLabel.text = username!
                
                //using the url retrive it from storage and set it up as ui image
                let ref = Storage.storage().reference(forURL: url!)
                    ref.getData(maxSize:  10000000, completion: { (data, error) in
                        if error != nil{
                            print("couldnt load img")
                        } else {
                            if let imgData = data {
                                if let img = UIImage(data: imgData){
                                    
                                    //sets profie photo from data
                                    self.profilePhoto.image = img
                                }
                            }
                        }
        
                    })
            })
        }

        
    }
    
    
    
    
    /*Location manager */
    //Location manager 
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){

        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {

            self.manager.stopUpdatingLocation()

            print("longitude = \(location.coordinate.longitude), latitude = \(location.coordinate.latitude)")

            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)

            //let params : [String : String] = ["lat" : latitude, "lon" : longitude, "appid" : APP_ID]

        }
    }
    
    //Write the didFailWithError method here:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        
    }
    
    
    
    
    
    /*Collection View Set Up*/
    //Number of sections
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    //number of items
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    //CellForItemAt 
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let  cell = postsCollectionView.dequeueReusableCell(withReuseIdentifier: "PostProfileCollectionViewCell", for: indexPath) as! PostProfileCollectionViewCell
        
        cell.configCell(post: posts[indexPath.row])
        return cell
    }

    
    
    
    
    //Sign out 
    @IBAction func signOut(_ sender: Any) {
        try! Auth.auth().signOut()
        
        KeychainWrapper.standard.removeObject(forKey: "uid")
        dismiss(animated: true, completion: nil)
    }
    
 
    
    
    
   

}
