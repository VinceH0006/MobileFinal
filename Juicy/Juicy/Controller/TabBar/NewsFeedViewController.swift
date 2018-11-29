//
//  NewsFeedViewController.swift
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


class NewsFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
        
    @IBOutlet weak var postsTableView: UITableView!
    
    var userUid: String!
    var posts = [Post]()
    var post:  Post!
    var imagePicker:UIImagePickerController!
    var imageSelected = false
    var selectedImage: UIImage!
    var username: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postsTableView.delegate = self
        postsTableView.dataSource = self
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        
        //accesses database "posts" and observes the data in a snapshot
        Database.database().reference().child("posts").observe(.value, with:
            {(snapshot) in
                
                if let snapshot = snapshot.children.allObjects as? [DataSnapshot]{
                    
                    //clears the posts array so that when we add a new one it doesn't show them all again
                    self.posts.removeAll()
                    
                    //Runs through all the data in a for loop and appends it to posts
                    for data in snapshot {
                        print(data)
                        print("This is the data")
                        if let postDict = data.value as? Dictionary<String, AnyObject>{
                            let key = data.key
                            let post = Post(postKey: key, postData: postDict)
                            
                            self.posts.append(post)
                        }
                        print("MADE IT TO THE SNAPSHOT OF DATABASE")
                    }
                }
                self.postsTableView.reloadData()
              })
        
    }
    
    /*Table View Set up*/
    //Tableview loading
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //Get number of rows from online data base
        return posts.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = postsTableView.dequeueReusableCell(withIdentifier: "PostNewsfeedTableViewCell", for: indexPath) as! PostNewsfeedTableViewCell
        
        //Fill cell with data from pulled database data
        let post = posts[indexPath.row]
        
        cell.configCell(post: post)
        
        print("Loading cell")
        
        return cell
        
    }
    
    
    
    
    
    
    
    //Additional functions
    @IBAction func postTapped(_ sender: Any) {
        
        present(imagePicker, animated: true, completion: nil )
        
        print("tapped")
        
    }
    
    
    //Image Picker Controller
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
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
                            //Post the image selected to firebase
                            self.postToFirebase(imgUrl: url)
                        }
                    }
                }
                )}

                
            }



    }
    
    //Create post and upload it to firebase
    func postToFirebase(imgUrl: String){
        
        let userID = Auth.auth().currentUser?.uid
        
        Database.database().reference().child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let data = snapshot.value as! Dictionary<String, AnyObject>
            
            let username = data["username"]
            
            let post: Dictionary<String, AnyObject> = [
                "userId": userID as AnyObject,
                "username": username!,
                "imgUrl":  imgUrl as AnyObject,
                "caption": "Beautiful sunny day" as AnyObject
            ]
            
            let firebasePost = Database.database().reference().child("posts").childByAutoId()
            
            firebasePost.setValue(post)
            
            self.imageSelected = false
            
            self.postsTableView.reloadData()
            
        })
    }
   
}
