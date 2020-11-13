//
//  ViewController.swift
//  WhatsappMessenger
//
//  Created by Jawad Abbasi on 06/11/2020.
//

import UIKit
import FirebaseAuth

class ConversationsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       
        view.backgroundColor = .red
        
        //DatabaseManager.shared.test()
        
        
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {

        print("View Did appear view controller")
        
        validateFromFireBase()
        
//        let isLoggedIn = UserDefaults.standard.bool(forKey: "Logged_in")

    }
    
    func validateFromFireBase()  {
        
        if FirebaseAuth.Auth.auth().currentUser == nil
        {
            let vc = LoginViewController()

            let nav = UINavigationController(rootViewController: vc)

            nav.modalPresentationStyle = .fullScreen

            present(nav, animated: false)

        }
        
    }


}

