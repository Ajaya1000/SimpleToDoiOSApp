//
//  ViewController.swift
//  ToDo App
//
//  Created by Ajaya Mati on 27/06/22.
//

import UIKit
import FirebaseAuthUI
import FirebaseEmailAuthUI

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onLoginButtonTap(_ sender: Any) {
        
        let providers: [FUIAuthProvider] = [
          FUIEmailAuth(),
        ]
        // get the default auth ui
        guard let authUI = FUIAuth.defaultAuthUI() else{
            return
        }
        
        //set ourselves as the delegate
        authUI.delegate = self
        authUI.providers = providers
        
        //get a reference to the auth ui view controller
        let authUIViewController = authUI.authViewController()
        authUIViewController.modalPresentationStyle = .fullScreen
        present(authUIViewController, animated: true)
    }
    
}

extension ViewController: FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, url: URL?, error: Error?) {
        if error != nil {
            print("error \(String(describing: error?.localizedDescription))")
            return
        }
        
        let homeVC = storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeViewController
        navigationController?.pushViewController(homeVC, animated: true)
        
    }
}
