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
        fetchConversation()
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
        thread?.refreshInBackgroundWithBlock({ (thread, error) -> Void in
            self.thread = thread
            PFObject.fetchAllIfNeededInBackground(thread!["messages"] as? [PFObject], block:
                { (messages, error) -> Void in
                    self.messages = messages as? [PFObject]
                    self.tableView.reloadData()
            })
        })
        


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
    
    func fetchConversation(){
        
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
        msg["threadID"] = thread
        var mutableThreadMessages = thread!["messages"] as! [PFObject]
        mutableThreadMessages.append(msg)
        thread!["messages"] = mutableThreadMessages
        msg.saveInBackgroundWithBlock { (success, error) -> Void in
            print(success)
            do{
                try self.thread?.save()
                self.fetchMessages()
            }catch _{
                
            }
        }
    }
    
}
