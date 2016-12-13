//
//  SettingsViewController.swift
//  SphereSpace
//
//  Created by Victor Shurapov on 12/9/16.
//  Copyright © 2016 Victor Shurapov. All rights reserved.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController, UITextFieldDelegate {
    
    var tvc = TVC()
    
    @IBOutlet weak var userPic: UIImageView!
    @IBOutlet weak var userName: UITextField!
    @IBAction func logOut(_ sender: AnyObject) {
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
    }
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    //    func textFieldDidEndEditing(_ textField: UITextField) {
    //        userName.text = textField.text
    //    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userName.delegate = self
        userPic.image = aaa().image
        userName.text = aaa().username
    }
    
    func aaa() -> (image: UIImage?, username: String?) {
        let image = tvc.user().userPic
        let name = tvc.user().userName

        return (image, name)
    }
    
}
