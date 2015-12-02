//
//  ViewController.swift
//  Chatalyst
//
//  Created by Abheyraj Singh on 01/12/15.
//  Copyright © 2015 Abheyraj. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var currentUser:String?
    var participantUser:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func abheyrajTapped(sender: AnyObject) {
        currentUser = "Batman"
        participantUser = "Robin"
        performSegueWithIdentifier("showConversation", sender: nil)
    }
    
    @IBAction func vibhasTapped(sender: AnyObject) {
        currentUser = "Robin"
        participantUser = "Batman"
        performSegueWithIdentifier("showConversation", sender: nil)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "showConversation"){
            let toViewController = segue.destinationViewController as! ConversationViewController
            toViewController.userID = currentUser
            toViewController.participantID = participantUser
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.navigationBarHidden = true
    }
    
}

