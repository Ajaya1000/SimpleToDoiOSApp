//
//  FirebaseHelper.swift
//  ToDo App
//
//  Created by Ajaya Mati on 27/06/22.
//

import Foundation
import FirebaseAuth

class User{
    
    static var email: String?
    
    static func signup(email:String,password:String){
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            guard let error = error as? NSError else{
                print("Signup successful")
                let newUserInfo = Auth.auth().currentUser
                User.email = newUserInfo?.email
                return
            }
            
            switch AuthErrorCode(_nsError: error).code{
            case .operationNotAllowed:
                  print("Operation not allowed")
            case .emailAlreadyInUse:
                print("Operation not allowed")
            case .invalidEmail:
                print("Operation not allowed")
            case .weakPassword:
                print("Operation not allowed")
            default:
                print("Error: \(error.localizedDescription)")
                
            }
        }
    }
    
    static func signin(email:String,password:String){
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            guard let error = error as? NSError else{
                print("Signup successful")
                let newUserInfo = Auth.auth().currentUser
                User.email = newUserInfo?.email
                return
            }
            
            switch AuthErrorCode(_nsError: error).code{
                
            case .operationNotAllowed:
                  print("Operation not allowed")
            case .userDisabled:
                print("Operation not allowed")
            case .wrongPassword:
                print("Operation not allowed")
            case .invalidEmail:
                print("Operation not allowed")
            default:
                print("Error: \(error.localizedDescription)")
                
            }
        }
    }
    
    static func signout(){
        do {
          try Auth.auth().signOut()
          email = nil
        } catch {
          print("Sign out error")
        }
    }
    
    static func isUserLoggedIn() -> Bool {
      return Auth.auth().currentUser != nil
    }
}
