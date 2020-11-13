//
//  ViewController.swift
//  WhatsappMessenger
//
//  Created by Jawad Abbasi on 06/11/2020.
//

import UIKit

class ConversationsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       
        view.backgroundColor = .red
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {

        print("View Did appear Notes view controller")
        
        let isLoggedIn = UserDefaults.standard.bool(forKey: "Logged_in")
        
        if !isLoggedIn
        {
            let vc = LoginViewController()
            
            let nav = UINavigationController(rootViewController: vc)
            
            nav.modalPresentationStyle = .fullScreen
            
            present(nav, animated: false)
            
        }

    }


}

