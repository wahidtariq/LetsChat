//
//  FirebaseManager.swift
//  LetsChat
//
//  Created by wahid tariq on 13/03/22.
//

import Foundation
import Firebase

class FirebaseManager: NSObject{
    let auth: Auth
    
    static let shared = FirebaseManager()
    
    override init() {
        FirebaseApp.configure()
        self.auth = Auth.auth()
        super.init()
    }
}
