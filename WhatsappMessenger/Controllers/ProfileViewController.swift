//
//  ProfileViewController.swift
//  WhatsappMessenger
//
//  Created by Jawad Abbasi on 13/11/2020.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import GoogleSignIn

class ProfileViewController: UIViewController {

    @IBOutlet var tableView : UITableView!
    
    let data = ["Log out"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }

}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = data[indexPath.row]
        
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = .red
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let alert = UIAlertController(title: "Do you really want to logiut?", message: "", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Log out", style: .destructive, handler:
                                        {
                                          [weak self]  _ in
                                            
                                            guard let strongSelf = self else {
                                                return
                                            }
                                            
                                            FBSDKLoginKit.LoginManager().logOut()
                                            
                                            GIDSignIn.sharedInstance()?.signOut()
                                            
                                            do {
                                                try FirebaseAuth.Auth.auth().signOut()
                                                
                                                let vc = LoginViewController()

                                                let nav = UINavigationController(rootViewController: vc)

                                                nav.modalPresentationStyle = .fullScreen

                                                strongSelf.present(nav, animated: true)
                                            }
                                            catch {
                                                print("Failed to log out.")
                                            }
                                        }
        ))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true)
        
    }
    
}
