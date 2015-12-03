//
//  ConversationViewController.swift
//  Chatalyst
//
//  Created by Abheyraj Singh on 01/12/15.
//  Copyright © 2015 Abheyraj. All rights reserved.
//

import UIKit
import LayerKit
import Parse
class ConversationViewController: UIViewController, LYRClientDelegate {
    
    var layerClient: LYRClient?
    var userID: String?
    var participantID: String?
    @IBOutlet var chatIndicator: UIScrollView!
    @IBOutlet var conversationsContainer: UIScrollView!
    var chatControllers: Array<ChatViewController> = Array<ChatViewController>()
    var defaultConversation: LYRConversation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let threadQuery = PFQuery(className: "Thread")
        threadQuery.findObjectsInBackgroundWithBlock { (threads, error) -> Void in
            self.createViewControllers(threads!)
        }
    }
    
    func createViewControllers(threads:[PFObject])
    {
        var i=CGFloat(0)
        for thread in threads
        {
            if let chatController = storyboard?.instantiateViewControllerWithIdentifier("ChatViewController") as? ChatViewController
            {
                
                chatController.thread = thread
                //            chatController.conversation = defaultConversation
                //            self.navigationController?.pushViewController(chatController, animated: true)
                chatController.view.bounds = conversationsContainer.bounds
                var frame = chatController.view.frame
                frame.origin.x = 0+i*view.frame.width
                frame.origin.y = 0
                frame.size.width = conversationsContainer.frame.width
                frame.size.height = conversationsContainer.frame.size.height
                chatController.view.frame = frame
                chatControllers.append(chatController)
                conversationsContainer.addSubview(chatController.view)
            }
            
            i+=1
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.navigationBarHidden = false
    }
    
    override func viewDidDisappear(animated: Bool) {
//        layerClient?.deauthenticateWithCompletion(nil)
    }
    
    func initializeConversationView(){
        if let chatController = storyboard?.instantiateViewControllerWithIdentifier("ChatViewController") as? ChatViewController
        {
            chatController.layerClient = self.layerClient
//            chatController.conversation = defaultConversation
//            self.navigationController?.pushViewController(chatController, animated: true)
            chatController.view.bounds = conversationsContainer.bounds
            var frame = chatController.view.frame
            frame.origin.x = 0
            frame.origin.y = 0
            frame.size.width = conversationsContainer.frame.width
            frame.size.height = conversationsContainer.frame.size.height
            chatController.view.frame = frame
            chatControllers.append(chatController)
            conversationsContainer.addSubview(chatController.view)
        }
    }
    
    
    func authenticateLayerWithUserId(userId:String, completion: ((success:Bool, error: NSError?) -> Void)) {
        if let authenticationID = layerClient?.authenticatedUserID{
            print("layer has been authenticated as user \(authenticationID)")
            completion(success: true,error: nil)
            return
        }
        
        layerClient?.requestAuthenticationNonceWithCompletion({ (nonce, error) -> Void in
            if nonce == nil{
                completion(success: false, error: error)
                return;
            }
            
            self.requestIdentityTokenForUserID(userId, appID: AppId, nonce: nonce, completion: { (identityToken, error) -> Void in
                if(identityToken.isEmpty){
                    completion(success: false, error: error)
                    return
                }
                
                self.layerClient?.authenticateWithIdentityToken(identityToken, completion: { (authenticatedUserId, error) -> Void in
                    if((authenticatedUserId) != nil){
                        completion(success: true, error: nil)
                        print("Layer authenticated as user \(authenticatedUserId)")
                    }else{
                        completion(success: false, error: error)
                    }
                    
                })
                
            })
            
        })
    }
    
    func requestIdentityTokenForUserID(userID: String, appID:String, nonce: String, completion: ((identityToken:String, error:NSError?)->Void)){
        let identityTokenURL = NSURL(string: "https://layer-identity-provider.herokuapp.com/identity_tokens")
        let request = NSMutableURLRequest(URL: identityTokenURL!)
        request.HTTPMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let parameters = ["app_id":appID, "user_id":userID, "nonce":nonce]
        var requestBody:NSData
        do{
            requestBody = try NSJSONSerialization.dataWithJSONObject(parameters, options: .PrettyPrinted)
            request.HTTPBody = requestBody
        }
        catch _ {

        }
        
        let sessionConfiguration = NSURLSessionConfiguration.ephemeralSessionConfiguration()
        let session = NSURLSession(configuration: sessionConfiguration)
        session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            if (error != nil){
                completion(identityToken: "", error: error!)
                return
            }
            do{
                let responseObject:NSDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as! NSDictionary
                if((responseObject["error"] == nil)){
                    let identityToken = responseObject["identity_token"] as! String
                    completion(identityToken: identityToken, error: nil)
                }else{
                    print("error")
                }
            }
            catch _ {
                
            }
            
        }.resume()
        
    }
    
    //MARK: Layer Delegate
    
    func layerClient(client: LYRClient!, didAuthenticateAsUserID userID: String!) {
        print("Layer client did receive authentication nonce")
    }
    
    func layerClient(client: LYRClient!, didReceiveAuthenticationChallengeWithNonce nonce: String!) {
        print("Did receive authentication challenge with nonce \(nonce)")
    }
    
    func layerClientDidDeauthenticate(client: LYRClient!) {
        print("Did deauthenticate")
    }
    
    func layerClient(client: LYRClient!, didFinishSynchronizationWithChanges changes: [AnyObject]!) {
        print("did finish synchronization")
    }
    
    func layerClient(client: LYRClient!, didFailSynchronizationWithError error: NSError!) {
        print("did fail synchronization with error \(error)")
    }
    
    func layerClient(client: LYRClient!, willAttemptToConnect attemptNumber: UInt, afterDelay delayInterval: NSTimeInterval, maximumNumberOfAttempts attemptLimit: UInt) {
        print("Will attempt to connect")
    }
    
    func layerClientDidConnect(client: LYRClient!) {
        print("did connect")
    }
    
    func layerClient(client: LYRClient!, didLoseConnectionWithError error: NSError!) {
        print("did lose connection")
    }
    
    func layerClientDidDisconnect(client: LYRClient!) {
        print("did disconnect")
    }
}
