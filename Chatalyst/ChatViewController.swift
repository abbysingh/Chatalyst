//
//  ChatViewController.swift
//  Chatalyst
//
//  Created by Abheyraj Singh on 01/12/15.
//  Copyright © 2015 Abheyraj. All rights reserved.
//

import UIKit
import LayerKit
import Parse

class ChatViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet var tableView: UITableView!
    @IBOutlet var textInputBottomConstraint: NSLayoutConstraint!
    var layerClient:LYRClient?
    var conversation:LYRConversation?
    var thread:PFObject?
    var messages: [PFObject]?
    @IBOutlet var composeTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .None
        let tapGesture = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        fetchMessages()
        self.tableView.addGestureRecognizer(tapGesture)
        sendButton.addTarget(self, action: "sendMessage:", forControlEvents: .TouchUpInside)
    }
    func fetchMessages()
    {
        
        let relation = thread?.relationForKey("messages")
        relation?.query().findObjectsInBackgroundWithBlock({ (messages, error) -> Void in
            let descriptor = NSSortDescriptor(key: "createdAt", ascending: true)
            let sortDescriptors = NSArray(object: descriptor)
            let sorted = NSArray(array: messages!).sortedArrayUsingDescriptors(sortDescriptors as! [NSSortDescriptor])
            self.messages = sorted as? [PFObject]
            self.tableView.reloadData()
            for message in messages!
            {
                print(message["messageString"])
                print(message.createdAt)
            }
        })
//        thread?.refreshInBackgroundWithBlock({ (thread, error) -> Void in
//            self.thread = thread
//            PFObject.fetchAllIfNeededInBackground(thread!["messages"] as? [PFObject], block:
//                { (messages, error) -> Void in
//                    self.messages = messages as? [PFObject]
//                    self.tableView.reloadData()
//            })
//        })
        


    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillChangeFrame:"), name: UIKeyboardWillChangeFrameNotification, object: nil)
    }
    
    func keyboardWillChangeFrame(notification: NSNotification){
        var userInfo = notification.userInfo!
        let frameEnd = userInfo[UIKeyboardFrameEndUserInfoKey]!.CGRectValue
        let convertedFrameEnd = self.view.convertRect(frameEnd, fromView: nil)
        let heightOffset = self.view.bounds.size.height - convertedFrameEnd.origin.y
        self.textInputBottomConstraint.constant = heightOffset
        
        UIView.animateWithDuration(
            userInfo[UIKeyboardAnimationDurationUserInfoKey]!.doubleValue,
            delay: 0,
            options: .TransitionNone,
            animations: {
                self.view.layoutIfNeeded()
            },
            completion: nil
        )
    }
    
    func dismissKeyboard(){
        composeTextField.resignFirstResponder()
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let messages = self.messages{
            return messages.count
        }else{
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var identifier:String
        let currentObject = self.messages![indexPath.row] as! PFObject
        if(currentObject["sender"] as! Int == PFUser.currentUser()!["userID"] as! Int){
            identifier = "rightCell"
            let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! RightCell
            cell.messageLabel.text = currentObject["messageString"] as! String
            return cell
        }
        else
        {
            identifier = "leftCell"
            let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! LeftCell
            cell.messageLabel.text = currentObject["messageString"] as! String
            return cell
        }

    }
    
    func sendMessage(sender: UIButton)
    {
        let msg = PFObject(className: "Message")
        msg["messageString"] = self.composeTextField.text
        msg["sender"] = PFUser.currentUser()!["userID"] as! Int
        let threadRelation = msg.relationForKey("thread")
        threadRelation.addObject(thread!)
        let msgRelation = thread?.relationForKey("messages")
        msgRelation?.addObject(msg)
        msg.saveInBackgroundWithBlock { (completed, error) -> Void in
            thread?.saveInBackgroundWithBlock({ (completed, error) -> Void in
                print(error)
                self.fetchMessages()
            })
        }
        
    }
    
}
