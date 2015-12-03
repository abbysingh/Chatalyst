//
//  ChatViewController.swift
//  Chatalyst
//
//  Created by Abheyraj Singh on 01/12/15.
//  Copyright © 2015 Abheyraj. All rights reserved.
//

import UIKit
import LayerKit

class ChatViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet var tableView: UITableView!
    @IBOutlet var textInputBottomConstraint: NSLayoutConstraint!
    var layerClient:LYRClient?
    var conversation:LYRConversation?
    @IBOutlet var composeTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchConversation()
        let tapGesture = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        self.tableView.addGestureRecognizer(tapGesture)
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
    
}
