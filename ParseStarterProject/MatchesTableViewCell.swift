//
//  MatchesTableViewCell.swift
//  ParseStarterProject-Swift
//
//  Created by orlando arzola on 06.09.16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class MatchesTableViewCell: UITableViewCell {

    
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var matchImageView: UIImageView!
    
    @IBAction func sendMessage(_ sender: AnyObject) {
        
        print(messageTextField.text)
        
        let message = PFObject(className: "Messages")
        
        
        
        if messageTextField.text != "" {
            
            message["message"] = messageTextField.text
            
            message["sender"] = PFUser.current()?.objectId
            
            message["recipient"] = userIdLabel.text
        }
        
        message.saveInBackground()
        
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func createAlert (title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        
        
    }

}
