//
//  ChatViewController.swift
//  Chatalyst
//
//  Created by Abheyraj Singh on 01/12/15.
//  Copyright © 2015 Abheyraj. All rights reserved.
//

import UIKit
import LayerKit

class ChatViewController: UIViewController{

    var layerClient:LYRClient?
    var conversation:LYRConversation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchConversation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchConversation(){
        
    }
    
}
