//
//  ViewController.swift
//  Chatalyst
//
//  Created by Abheyraj Singh on 01/12/15.
//  Copyright © 2015 Abheyraj. All rights reserved.
//

import UIKit
import Parse
class ViewController: UIViewController {

    var currentUser:String?
    var participantUser:String?
    let password = "asdfghjkl"
    override func viewDidLoad()
    {
        super.viewDidLoad()
//        let query = PFQuery(className: "Message")
//        query.findObjectsInBackgroundWithBlock
//        { (messages, error) -> Void in
//            print(messages)
//            let threadQuery = PFQuery(className: "Thread")
//            threadQuery.findObjectsInBackgroundWithBlock({ (threads, error) -> Void in
//                let mainThread = threads![0]
//                mainThread["messages"] = messages
//                mainThread.saveInBackground()
//            })
//            
//        }
//        
        let threadQuery = PFQuery(className: "Thread")
        threadQuery.findObjectsInBackgroundWithBlock({ (threads, error) -> Void in
            let mainThread = threads![0]
            print(mainThread["messages"])
            PFObject.fetchAllIfNeededInBackground(mainThread["messages"] as? [PFObject], block:
            { (messages, error) -> Void in
                
                for message in messages!
                {
                    print(message["messageString"])
                }
            })
        })

        
        
    }

    @IBAction func abheyrajTapped(sender: AnyObject) {
        currentUser = "Batman"
        participantUser = "Robin"
        PFUser.logInWithUsernameInBackground(currentUser!, password: password) { (user, error) -> Void in
            print(self.currentUser! + "logged in")
        }
        performSegueWithIdentifier("showConversation", sender: nil)
    }
    
    @IBAction func vibhasTapped(sender: AnyObject) {
        currentUser = "Robin"
        participantUser = "Batman"
        PFUser.logInWithUsernameInBackground(currentUser!, password: password) { (user, error) -> Void in
            print(self.currentUser! + "logged in")
        }
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

