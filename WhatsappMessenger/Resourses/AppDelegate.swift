//
//  AppDelegate.swift
//  WhatsappMessenger
//
//  Created by Jawad Abbasi on 06/11/2020.
//

import UIKit
import Firebase
import FBSDKCoreKit
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        guard error == nil else {
            if let error = error {
                print("Login failed with Goolde \(error)")
            }
            return
        }
        
        guard let user = user else {
            return
        }
        
        print("Did signin with google \(user)")
        
        guard let email = user.profile.email,
              let firstName = user.profile.givenName,
              let lastName = user.profile.familyName else {
            return
        }
        
        DatabaseManager.shared.userExists(with: email, complition:
                                            {
                                            exists in
                                                if !exists {
                                                    // Add to database
                                                    DatabaseManager.shared.insertUser(with: WhatsappUser(firstName: firstName, lastName: lastName, emailAddress: email))
                                                }
                                                
                                            }
        )
        
        guard let authentication = user.authentication else {
            print("Missing aut obejct of google user")
            return
            
        }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)

        FirebaseAuth.Auth.auth().signIn(with: credential, completion:
                                            {
                                                authResult, error in
                                                
                                                guard authResult != nil, error == nil else {
                                                    print("Failed to login with google credential")
                                                    return
                                                }
                                                
                                                print("Succesfully signin with google")
                                                NotificationCenter.default.post(name: .didLoginNotification, object: nil)
                                                
                                            }
        )
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
        print("Google User Disconnected")
        
    }
    
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        FirebaseApp.configure()
          
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        
        GIDSignIn.sharedInstance()?.clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance()?.delegate = self

        return true
    }
          
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {

        ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
        
        return GIDSignIn.sharedInstance().handle(url)

    }

}


