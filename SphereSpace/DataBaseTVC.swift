////
////  ProtectedPageTVC.swift
////  SphereSpace
////
////  Created by Victor Shurapov on 9/9/16.
////  Copyright © 2016 Victor Shurapov. All rights reserved.
////
//
//import UIKit
//import Firebase
//
//struct dataBaseStruct {
//    let title: String!
//    let message: String!
//}
//
//class DataBaseTVC: UITableViewController {
//    
//    var files = [dataBaseStruct]()
//    
//    var streamUrlArray = [String]()
//    
//    var dataBaseRef: FIRDatabaseReference!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        //        tableView.delegate = self
//        //        tableView.dataSource = self
//       // post()
//        
//        
//        let dataBaseRef = FIRDatabase.database().reference()
//        let userID = FIRAuth.auth()?.currentUser?.uid
//
//        dataBaseRef.child("liveStreams").child(userID!).observe(.childAdded, with: {
//            // Getting user stream url
//            snapshot in
//            
//            let streamUrl = snapshot.value!["watchStreamUrl"] as! String
//            self.streamUrlArray.insert(streamUrl, at: 0)
//            self.tableView.reloadData()
//
//
//        })
//        
////        dataBaseRef.child("Test").queryOrderedByKey().observeEventType(.ChildAdded, withBlock: {
////            snapshot in
////            
////            let title = snapshot.value!["title"] as! String
////            let message = snapshot.value!["message"] as! String
////            
////            self.files.insert(dataBaseStruct(title: title, message: message), atIndex: 0)
////            self.tableView.reloadData()
////        })
//        
//    }
//    
//    
////    // POST TO DATABASE
////    func post() {
////        let title = "Title"
////        let message = "Message"
////        
////        let post: [String: AnyObject] = ["title": title, "message": message]
////        
////        
////        self.dataBaseRef = FIRDatabase.database().reference()
////        //let dataBaseRef = FIRDatabase.database().reference
////        
////        dataBaseRef.child("Test").childByAutoId().setValue(post)
////        
////    }
//    
//    
//    // MARK: - Table view data source
//    
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }
//    
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return streamUrlArray.count
//        //return files.count
//    }
//    
//    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
//        
//        let label1 = cell?.viewWithTag(1) as! UILabel
//        //label1.text = files[indexPath.row].title
//        label1.text = streamUrlArray[(indexPath as NSIndexPath).row]
//        
//        
//        let label2 = cell?.viewWithTag(2) as! UILabel
//        label2.text = "Check it out! :-)"
////        label2.text = files[indexPath.row].message
//        
//        return cell!
//    }
//    
//    
//    /*
//     // Override to support conditional editing of the table view.
//     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
//     // Return false if you do not want the specified item to be editable.
//     return true
//     }
//     */
//    
//    /*
//     // Override to support editing the table view.
//     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//     if editingStyle == .Delete {
//     // Delete the row from the data source
//     tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
//     } else if editingStyle == .Insert {
//     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//     }
//     }
//     */
//    
//    /*
//     // Override to support rearranging the table view.
//     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
//     
//     }
//     */
//    
//    /*
//     // Override to support conditional rearranging of the table view.
//     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
//     // Return false if you do not want the item to be re-orderable.
//     return true
//     }
//     */
//    
//    /*
//     // MARK: - Navigation
//     
//     // In a storyboard-based application, you will often want to do a little preparation before navigation
//     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//     // Get the new view controller using segue.destinationViewController.
//     // Pass the selected object to the new view controller.
//     }
//     */
//    
//    
//    
//    //        func getUid() -> String {
//    //            return (FIRAuth.auth()?.currentUser?.uid)!
//    //        }
//    //
//    //        func getQuery() -> FIRDatabaseQuery {
//    //            return (dataBaseRef.child("user-posts").child(getUid()))
//    //        }
//    //
//    //        print(getQuery())
//    
//    
//    
//}
//
//
