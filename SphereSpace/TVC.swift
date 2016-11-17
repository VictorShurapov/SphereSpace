//
//  TVC.swift
//  SphereSpace
//
//  Created by Victor Shurapov on 11/14/16.
//  Copyright © 2016 Victor Shurapov. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

struct File {
    let title: String!
    let message: String!
}

class TVC: UITableViewController {
    
    var ref: FIRDatabaseReference!
    
    var posts = [File]()
    
    //let userID = FIRAuth.auth()?.currentUser?.uid

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = FIRDatabase.database().reference()
        
        // Adding new streams
        ref.child("Test").queryOrderedByKey().observe(.childAdded, with: {
            snapshot in
            
            let value = snapshot.value as? [String: AnyObject]
            let title = value?["title"] as! String
            let message = value?["message"] as! String
            
            self.posts.insert(File(title: title, message: message), at: 0)
            self.tableView.reloadData()
        })
        
        //post()
        
    }
    
    
    //Post to Database
    
    func post() {
        let title = "Title"
        let message = "Message"
        
        let post = ["title": title, "message": message]
        
        
        ref.child("Test").childByAutoId().setValue(post)
        
    }
    

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        let label1 = cell?.viewWithTag(1) as! UILabel
        label1.text = posts[indexPath.row].title
        
        let label2 = cell?.viewWithTag(2) as! UILabel
        label2.text = posts[indexPath.row].message
        
        
        return cell!
    }
    
    // Movable Cells
    
//    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//        let movedObject = self.posts[sourceIndexPath.row]
//        posts.remove(at: sourceIndexPath.row)
//        posts.insert(movedObject, at: destinationIndexPath.row)
//    }
    
    //        dataBaseRef.child("liveStreams").child(userID!).observe(.childAdded, with: {
    //            // Getting user stream url
    //            snapshot in
    //
    //            let snap = snapshot.value as! [String: String]
    //            let streamUrl = snap["watchStreamUrl"]! as String
    //            self.streamUrlArray.insert(streamUrl, at: 0)
    //            self.tableView.reloadData()
    //
    //
    //        })
    
    //let userID = FIRAuth.auth()?.currentUser?.uid
 
    //        func getUid() -> String {
    //            return (FIRAuth.auth()?.currentUser?.uid)!
    //        }
    //
    //        func getQuery() -> FIRDatabaseQuery {
    //            return (dataBaseRef.child("user-posts").child(getUid()))
    //        }
}
