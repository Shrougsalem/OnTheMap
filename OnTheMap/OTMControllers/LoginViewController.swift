//
//  LoginViewController.swift
//  On The Map
//
//  Created by Shroog Salem on 03/12/2019.
//  Copyright © 2019 Shroug Salem. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    //MARK: - Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //for keyboard adjustments
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailTextField.text = ""
        passwordTextField.text = ""
        self.subscribeToKeyboardNotifications()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }
    
    //MARK: - Actions
    @IBAction func Login(_ sender: Any) {
        //view.endEditing(true)
        self.showSpinner()
        let email = emailTextField.text!.trimmingCharacters(in: .whitespaces)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespaces)
        if  (!emailTextField.text!.isEmpty && !passwordTextField.text!.isEmpty) {
            UdacityAPI.postSession(email: email, password: password) { (error) in
                if error != nil {
                    self.removeSpinner()
                    self.alert(title: "Error", message: error!)
                    return
                }
                UdacityAPI.getPublicUserData(completion: { (error) in
                    self.removeSpinner()
                    if error != nil {
                        self.alert(title: "Error", message: error!)
                        return
                    }
                    DispatchQueue.main.async {
                        self.emailTextField.text = ""
                        self.passwordTextField.text = ""
                        self.performSegue(withIdentifier: "toTabBarViewController", sender: self)
                    }
                })
            }
        } else {
            self.alert(title: "Error", message: "Please fill both textfields")
            self.removeSpinner()
            return
        }
    }
    @IBAction func signUp(_ sender: Any) {
        guard let url = URL(string: "https://auth.udacity.com/sign-up") else {
            print ("The URL is Invalid")
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

}
