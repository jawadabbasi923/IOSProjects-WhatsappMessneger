//
//  DatabaseManager.swift
//  WhatsappMessenger
//
//  Created by Jawad Abbasi on 13/11/2020.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
}

// Mark - Account Management

extension DatabaseManager {
    
    public func userExists(with email: String, complition: @escaping((Bool)) -> Void)
    {
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        
        database.child(safeEmail).observeSingleEvent(of: .value, with: {
            snapshot in
            
            guard snapshot.value as? String != nil else {
                complition(false)
                return
            }
            
            complition(true)
            
        })
    }
    
    /// insert new user to database
    public func insertUser(with user: WhatsappUser){
        
        database.child(user.safeEmail).setValue(
            [
                "First_Name" : user.firstName,
                "Last_Name" : user.lastName
            ]
        )
        
    }
    
}

struct WhatsappUser {
    let firstName : String
    let lastName : String
    let emailAddress : String
    
    var safeEmail : String {
        
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        
        return safeEmail
        
    }
}
