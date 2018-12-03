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
import MapKit
import CoreLocation

class MyProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, CLLocationManagerDelegate {
    
    
    
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var postsCollectionView: UICollectionView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    
  //  let manager = CLLocationManager()
    
    
    //tester
    var manager = CLLocationManager()
    var currentLocation: CLLocation!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //CollectionView for Posts
        postsCollectionView.delegate = self
        postsCollectionView.delegate = self
        
        
        //LocationManager for Location delegate
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()

        
    }
    
    
    
    
    
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
    //number of items
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    //CellForItemAt 
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
    
 

}
