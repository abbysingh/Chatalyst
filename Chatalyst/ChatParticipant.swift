//
//  ChatParticipant.swift
//  Chatalyst
//
//  Created by Abheyraj Singh on 01/12/15.
//  Copyright © 2015 Abheyraj. All rights reserved.
//

import UIKit
import Atlas

class ChatParticipant: NSObject, ATLParticipant{
    /**
     @abstract The first name of the participant as it should be presented in the user interface.
     */
    var firstName: String!
    
    /**
     @abstract The last name of the participant as it should be presented in the user interface.
     */
    var lastName: String!
    
    /**
     @abstract The full name of the participant as it should be presented in the user interface.
     */
    var fullName: String!
    
    /**
     @abstract The unique identifier of the participant as it should be used for Layer addressing.
     @discussion This identifier is issued by the Layer identity provider backend.
     */
    var participantIdentifier: String!
    
    /**
     @abstract Returns the image URL for an avatar image for the receiver.
     */
    var avatarImageURL: NSURL!
    
    /**
     @abstract Returns the avatar image of the receiver.
     */
    var avatarImage: UIImage!
    
    /**
     @abstract Returns the avatar initials of the receiver.
     */
    var avatarInitials: String!
}
