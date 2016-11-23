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


class LoginViewController: UIViewController, UITextFieldDelegate, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBAction func loginCreateUser(_ sender: AnyObject) {
        
        let credential: FIRAuthCredential = FIREmailPasswordAuthProvider.credential(withEmail: email.text!, password: password.text!)
        
        if !self.userActive {
            FIRAuth.auth()?.createUser(withEmail: email.text!, password: password.text!, completion: {
                user, error in
                
                // if there is an error - user is already created -> we need to login
                if error != nil {
                    self.loginEmail()
                    
                } else {
                    print("User created via e-mail")
                    self.performSegue(withIdentifier: "signIn", sender: nil)
                }
            })
            
        } else {
            // user active
            FIRAuth.auth()?.currentUser!.link(with: credential) { (user, error) in
                if error != nil {
                    print(error!.localizedDescription)
                    
                } else {
                    print("User logged in via facebook first and now linked its account with email")
                    self.performSegue(withIdentifier: "signIn", sender: nil)
                }
            }
        }
    }
    
    
    @IBOutlet weak var fbLoginButton: FBSDKLoginButton!
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    
    var userActive = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle the text field’s user input through delegate callbacks.
        email.delegate = self
        password.delegate = self
        
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
    
    
    //     // VDL or VDA is best place for segue???
    //        override func viewDidAppear(_ animated: Bool) {
    //            if FIRAuth.auth()?.currentUser != nil {
    //                self.performSegue(withIdentifier: "signIn", sender: nil)
    //            }
    //        }
    
    // MARK: EMAIL LOGIN
    func loginEmail() {
        FIRAuth.auth()?.signIn(withEmail: email.text!, password: password.text!, completion: {
            user, error in
            if error != nil {
                print(error!.localizedDescription)
                
            } else {
                print("==============================================User logged in via email!")
                self.performSegue(withIdentifier: "signIn", sender: nil)
            }
        })
    }
    
    // MARK: FB LOGIN
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error?) {

        if let error = error {
            print(error.localizedDescription)
        } else if result!.isCancelled {
            print("FBLogin cancelled")
        } else {
            // Getting an access token for the signed-in user(Facebook) and exchange it for a Firebase credential:
            let credential: FIRAuthCredential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            if !userActive {
                
                // Authentication with Firebase using the Firebase credential:
                FIRAuth.auth()?.signIn(with: credential) { (user, error) in
                    if error != nil {
                        print(error!.localizedDescription)
                    } else {
                        print("==============================================User created via fb")
                        self.performSegue(withIdentifier: "signIn", sender: nil)
                    }
                }
            } else {
                //user active
                FIRAuth.auth()?.currentUser!.link(with: credential) { (user, error) in
                    if error != nil {
                        print(error!.localizedDescription)
                        
                    } else {
                        print("==============================================User logged-in via email first and now linked its account with facebook")
                        self.performSegue(withIdentifier: "signIn", sender: nil)
                        
                    }
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
