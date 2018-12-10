//
//  SearchViewController.swift
//  Juicy
//
//  Created by Will Morphy on 19/11/18.
//  Copyright © 2018 Will Morphy. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage



class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
   
    
    @IBOutlet weak var resultsTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var profiles = [Profile]()
    var currentProfiles = [Profile]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultsTableView.delegate = self
        resultsTableView.dataSource = self
        
        downloadPosts()
        
        searchBar.delegate = self

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(currentProfiles.count)
        return currentProfiles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = resultsTableView.dequeueReusableCell(withIdentifier: "SearchTabTableViewCell", for: indexPath) as! SearchTabTableViewCell
        
        cell.configCell(profile: currentProfiles[indexPath.row])
        
        return cell
    }
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            self.currentProfiles = self.profiles
            self.resultsTableView.reloadData()
            return
        }
        self.currentProfiles = self.profiles.filter({ (profile) -> Bool in
            return profile.username.contains(searchText)
        })
        self.resultsTableView.reloadData()
        
    }
    
    
    
    

    
    
    func downloadPosts(){
        //accesses database "users" and observes the data in a snapshot
        //Adds to profiles array
        Database.database().reference().child("users").observe(.value, with:
            {(snapshot) in
                
                
                if let snapshot = snapshot.children.allObjects as? [DataSnapshot]{
                    
                    //clears the posts array so that when we add a new one it doesn't show them all again
//                    self.profiles.removeAll()
                    
                    //Runs through all the data in a for loop and appends it to posts
                    for data in snapshot {
                        if let profileDict = data.value as? Dictionary<String, AnyObject>{
                            
                            let key = data.key
                            
                            let profile = Profile(profileKey: key, profileData: profileDict)
                            
                            self.profiles.append(profile)
                        
                        }
                    }
                }
                self.currentProfiles = self.profiles

                self.resultsTableView.reloadData()

        })
    }


}
