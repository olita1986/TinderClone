//
//  MatchesTableViewController.swift
//  ParseStarterProject-Swift
//
//  Created by orlando arzola on 06.09.16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class MatchesTableViewController: UITableViewController {
    
    var images = [UIImage]()
    var userIds = [String]()
    var messages = [String]()

    @IBAction func back(_ sender: AnyObject) {
        
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let query = PFUser.query()
        
        query?.whereKey("accepted", contains: PFUser.current()?.objectId)
        query?.whereKey("objectId", containedIn: PFUser.current()?["accepted"] as! [String])
        
        query?.findObjectsInBackground(block: { (objects, error) in
            
            if error != nil {
                
                print(error)
            } else {
                
                if let users = objects {
                    
                    for object in users {
                        
                        if let user = object as? PFUser {
                            
                            let imageFile = user["imageFile"] as! PFFile
                            
                            imageFile.getDataInBackground(block: { (data, error) in
                                if error != nil {
                                    
                                    print(error)
                                } else {
                                    
                                    if let imageData = data {
                                        
                                        
                                        
                                        let message = PFQuery(className: "Messages")
                                        
                                        message.whereKey("recipient", equalTo: (PFUser.current()?.objectId)!)
                                        
                                        message.whereKey("sender", equalTo: user.objectId!)
                                        
                                        message.findObjectsInBackground(block: { (objects, error) in
                                            
                                            var messageText = "No message from this user."
                                            if error != nil {
                                                
                                                print(error)
                                            } else {
                                                
                                                
                                                
                                                if let messages = objects {
                                                    
                                                    for message in messages {
                                                            
                                                            if let messageContent = message["message"] as? String {
                                                                
                                                                messageText = messageContent
                                                            }
                                                        
                                                    }
                                                }
                                                
                                                self.messages.append(messageText)
                                                
                                                self.images.append(UIImage(data: imageData)!)
                                                
                                                self.userIds.append(user.objectId!)
                                                
                                                self.tableView.reloadData()
                                                
                                            }
                                            
                                        })
                                        
                                       
                                    }
                                }
                            })
                            
                        }
                    }
                }
            }
        })
        
        
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return images.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MatchesTableViewCell

        //cell.sendButton.addTarget(self, action: #selector(MatchesTableViewController.printString), for: UIControlEvents.touchUpInside)
        
        cell.matchImageView.image = images[indexPath.row]
        cell.userIdLabel.text = userIds[indexPath.row]
        cell.messageLabel.text = messages[indexPath.row]
        
        

        return cell
    }
    
    /*
    func printString() {
        
        print("Hello")
    }
 */
   

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
