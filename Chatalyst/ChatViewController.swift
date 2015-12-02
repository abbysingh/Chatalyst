//
//  ChatViewController.swift
//  Chatalyst
//
//  Created by Abheyraj Singh on 01/12/15.
//  Copyright © 2015 Abheyraj. All rights reserved.
//

import UIKit
import Atlas

class ChatViewController: ATLConversationViewController, ATLConversationViewControllerDataSource, ATLConversationViewControllerDelegate{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
//        self.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func conversationViewController(conversationViewController: ATLConversationViewController!, participantForIdentifier participantIdentifier: String!) -> ATLParticipant! {
        let participant = ChatParticipant()
        if(participantIdentifier == nil){
            return nil
        }
        if(participantIdentifier == "Robin"){
            participant.firstName = "Robin"
            participant.lastName = "DC"
            participant.fullName = "Robin DC"
            participant.avatarInitials = "R"
            participant.participantIdentifier = "Robin"
        }else{
            participant.firstName = "Batman"
            participant.lastName = "DC"
            participant.fullName = "Batman DC"
            participant.avatarInitials = "B"
            participant.participantIdentifier = "Batman"
        }
        return participant
    }
 
    func conversationViewController(conversationViewController: ATLConversationViewController!, attributedStringForDisplayOfDate date: NSDate!) -> NSAttributedString! {
        return NSAttributedString(string: "\(date)")
    }
    
    func conversationViewController(conversationViewController: ATLConversationViewController!, attributedStringForDisplayOfRecipientStatus recipientStatus: [NSObject : AnyObject]!) -> NSAttributedString! {
        return NSAttributedString(string: "Received")
    }
    
    
}
