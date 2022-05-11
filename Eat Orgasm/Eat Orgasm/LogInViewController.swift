//
//  LogInViewController.swift
//  Eat Orgasm
//
//  Created by 지원구 on 2022/05/11.
//

import Foundation
import UIKit

import Firebase

class LogInViewController :UIViewController {
    
    @IBOutlet weak var idInputTextField: UITextField!
    @IBOutlet weak var pwInputTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = Auth.auth().currentUser {
            
            self.idInputTextField.placeholder = "Aleady login"
            self.pwInputTextField.placeholder = "Aleady login"
                        
        }
    }
    
    
    
    
    @IBAction func logInButtonTouched(_ sender: Any) {
                        
        Auth.auth().signIn(withEmail: self.idInputTextField.text!, password: self.pwInputTextField.text!) { (user, error) in
            
            if user != nil {
                print("login success")
            }
            else {
                print("login fail")
            }
        }
    }
    
    @IBAction func registerButtonTouched(_ sender: Any) {
        
    }
}
