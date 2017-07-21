//
//  LoginViewController.swift
//  Whale
//
//  Created by Eliel A. Gordon on 3/23/17.
//  Copyright © 2017 Eliel A. Gordon. All rights reserved.
//

import UIKit

protocol LoginDelegate {
    func loginPressed()
}

class LoginViewController: UIViewController {

    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    var loginDelegate: LoginDelegate?
    let loginViewModel = LoginViewModel()
    var authStatus: AuthStatus
    
    init(authStatus: AuthStatus, nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.authStatus = authStatus
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameField.delegate = self
        passwordField.delegate = self
        
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        loginViewModel.login(email: usernameField.text, password: passwordField.text) { result in
            switch result {
            case .loggedIn:
                let appDelegate = UIApplication.shared.delegate as? AppDelegate
                appDelegate?.window?.rootViewController = WhaleTabBarController()
            case let .error(message):
                self.presentAlert(title: message, message: message)
            }
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
}

extension UIViewController {
    func presentAlert(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        self.show(alertVC, sender: self)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            alertVC.dismiss(animated: true, completion: nil)
        }
    }
}
