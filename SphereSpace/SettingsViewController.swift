//
//  SettingsViewController.swift
//  SphereSpace
//
//  Created by Victor Shurapov on 12/9/16.
//  Copyright © 2016 Victor Shurapov. All rights reserved.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {
    
    
    @IBOutlet weak var userPic: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBAction func logOut(_ sender: AnyObject) {
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user()
        
        
    }
    
    
    func user() {
        let user = FIRAuth.auth()?.currentUser
        
//        let signInProvider = user?.providerID
        let userName = user?.displayName
//        let email = user?.email
//        let uid = user?.uid
        let photoURL = user?.photoURL
        
        if let imageData = NSData(contentsOf: photoURL!) {
            userPic.image = UIImage(data: imageData as Data)
        }
        do {
            
            let imageData = try Data.init(contentsOf: photoURL!)
            userPic.image = UIImage(data: imageData)
            
        } catch {
            print(error)
        }
        
        self.userName.text = userName!
    }
}
