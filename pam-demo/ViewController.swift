//
//  ViewController.swift
//  pam-demo
//
//  Created by narongrit kanhanoi on 2/3/2564 BE.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Pam.askNotificationPermission(mediaAlias: "ios-noti", options:  [.alert, .sound, .badge])
       
        
        Pam.track(event: "pageview", payload: ["pageName":"test"])
    }


}

