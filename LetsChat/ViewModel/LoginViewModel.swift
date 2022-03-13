//
//  LoginViewModel.swift
//  LetsChat
//
//  Created by wahid tariq on 13/03/22.
//

import Foundation
import UIKit
import Firebase


class LoginViewModel: ObservableObject{
    
    @Published var isLoginPage = false
    @Published var email = ""
    @Published var password = ""
    @Published var loginStatusMessage = ""
    @Published var shouldShowImagePicker = false
    @Published var image: UIImage?
    
    
    //    As per segmentControl if picker selection login then login page or create new account the create new account page
    
    func handleAction(){
        if isLoginPage{
            loginExistingUser()
        }else{
            createNewAccount()
        }
    }
    
    func createNewAccount(){
        
        let isValidFields = checkEmailAndPasswordFieldIsEmpty()
        if isValidFields{
            FirebaseManager.shared.auth.createUser(withEmail: email, password: password) { [ weak self ]result, error in
                guard let self = self else { return }
                if let e = error{
                    self.loginStatusMessage = "failed to create user \(e.localizedDescription)"
                    return
                }
                self.loginStatusMessage = "Successfully created user \(result?.user.uid ?? "no Uid found")"
                self.persisImageToFirebaseStorage()
            }
        }else {
            loginStatusMessage = "Username and password Missing"
            clearStatusMessage()
        }
    }
    
    
    func loginExistingUser(){
        
        let isValidFields = checkEmailAndPasswordFieldIsEmpty()
        
        if isValidFields{
            FirebaseManager.shared.auth.signIn(withEmail: email, password: password) { [weak self] result, error in
                guard let self = self else { return }
                if let err = error{
                    self.loginStatusMessage = "failed to login \(err.localizedDescription)"
                    return
                }
                self.loginStatusMessage = "Hello \(result?.user.displayName ?? "Anonymous")"
            }
        }else {
            loginStatusMessage = "Username and password Missing"
            clearStatusMessage()
        }
    }
    
    func checkEmailAndPasswordFieldIsEmpty() -> Bool {
        guard email.isEmpty, password.isEmpty else { return true }
        return false
    }
    
    func clearStatusMessage(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.loginStatusMessage = ""
        }
    }
    func persisImageToFirebaseStorage(){
        
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        let storageRefrence = FirebaseManager.shared.storage.reference(withPath: uid)
        
        guard let data = image?.jpegData(compressionQuality: 0.5) else { return }
        
        
        storageRefrence.putData(data, metadata: nil) { [weak self] metadata, error in
            guard let self = self else { return }
            if let err = error {
                self.loginStatusMessage = "failed to push image to storage \(err)"
                return
            }
            storageRefrence.downloadURL { url, error in
                if let err = error{
                    self.loginStatusMessage = "failed to download the url of image form firebase \(err.localizedDescription)"
                }
                self.loginStatusMessage = "success! \(String(describing: url?.absoluteURL))"
                
                guard let safeUrl = url else { return }
                self.storeUserInformation(imageProfileURl: safeUrl)
            }
        }
    }
    
    func storeUserInformation(imageProfileURl: URL){
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        let userData = ["email": email, "uid": uid, "profileUrl": imageProfileURl.absoluteString]
        
        FirebaseManager.shared.firestore.collection("users")
            .document(uid).setData(userData) { [weak self]error in
                guard let self = self else { return }
                if let err = error{
                    self.loginStatusMessage = "cannot save data into firestore \(err)"
                return
            }
                print("success!")
        }
    }
}
