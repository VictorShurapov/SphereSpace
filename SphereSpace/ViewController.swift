//
//  ViewController.swift
//  SphereSpace
//
//  Created by Victor Shurapov on 8/26/16.
//  Copyright © 2016 Victor Shurapov. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FBSDKCoreKit
import FBSDKLoginKit


class ViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBAction func loginCreateUser(_ sender: AnyObject) {
        let credential: FIRAuthCredential = FIREmailPasswordAuthProvider.credential(withEmail: email.text!, password: password.text!)
        
            if !self.userActive {
                FIRAuth.auth()?.createUser(withEmail: email.text!, password: password.text!, completion: {
                    user, error in
                    
                    // if there is an error - user is already created -> we need to login
                    if error != nil {
                        self.login()
                        
                    } else {
                        
                        print("User created via e-mail")
                        
                        
                    }
                })
                
            } else {
                // user active
                FIRAuth.auth()?.currentUser!.link(with: credential) { (user, error) in
                    if error != nil {
                        print(error!.localizedDescription)
                        
                    } else {
                        print("User logged in via facebook first and now linked its account with email")
                    }
                }
            }
    }
    
    
    @IBOutlet weak var fbLoginButton: FBSDKLoginButton!
    
    
    var userActive = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fbLoginButton.delegate = self
        fbLoginButton.readPermissions = ["public_profile", "email", "user_friends"]
        
        //Get the currently signed-in user
        FIRAuth.auth()?.addStateDidChangeListener { auth, user in
            if user != nil {
                // User is signed in.
                self.userActive = true
                print("viewDidLoad - USER ACTIVE")
                
            } else {
                // No user is signed in.
                self.userActive = false
                print("viewDidLoad - USER INACTIVE")
                
            }
        }
    }
    
    
//    // VDL or VRA is best place for segue???
//    override func viewDidAppear(_ animated: Bool) {
//        if FIRAuth.auth()?.currentUser != nil {
//            self.performSegue(withIdentifier: "signIn", sender: nil)
//        }
//    }
    
    // EMAIL LOGIN
    func login() {
        FIRAuth.auth()?.signIn(withEmail: email.text!, password: password.text!, completion: {
            user, error in
            if error != nil {
                print(error!.localizedDescription)
                
            } else {
                print("User logged in via email!")
            }
        })
    }
    
    // FB LOGIN
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        // Getting Credentials and signing/linking in
        
        let credential: FIRAuthCredential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        
            if !userActive {
                FIRAuth.auth()?.signIn(with: credential) { (user, error) in
                    if error != nil {
                        print(error!.localizedDescription)
                        
                    } else {
                        print("User created via fb")
                    }
                }
            } else {
                //user active
                FIRAuth.auth()?.currentUser!.link(with: credential) { (user, error) in
                    if error != nil {
                        print(error!.localizedDescription)
                        
                    } else {
                        print("User logged in via email first and now linked its account with facebook")
                        
                    }
                }
            }
    }
    
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        try! FIRAuth.auth()!.signOut()
        print("User logged out of facebook...")
    }
    
}
