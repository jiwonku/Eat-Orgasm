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
            
            self.idInputTextField.placeholder = "Input ID"
            self.pwInputTextField.placeholder = "Input PW"
                        
        }
    }
    
    
    
    
    @IBAction func logInButtonTouched(_ sender: Any) {
                        
        Auth.auth().signIn(withEmail: self.idInputTextField.text!, password: self.pwInputTextField.text!) { (user, error) in
            
            if user != nil {
                print("login success")
                let alert = UIAlertController(title: "success", message: "login success", preferredStyle: UIAlertController.Style.alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    
                }
                alert.addAction(okAction)
                self.present(alert, animated: false, completion: nil)
            }
            else {
                print("login fail")
            }
        }
    }
    
    @IBAction func registerButtonTouched(_ sender: Any) {

//        let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "CRegisterAccountViewController")
//        self.navigationController?.pushViewController(pushVC!, animated: true)
        
//        let storyboard = UIStoryboard(name: "LogIn", bundle: nil)
//        let logInVC = storyboard.instantiateViewController(withIdentifier: "CRegisterAccountViewController")
//        logInVC.modalTransitionStyle = .coverVertical
//        logInVC.modalPresentationStyle = .fullScreen
//        self.present(logInVC, animated: true, completion: nil)
        
        let storyboard = UIStoryboard(name: "LogIn", bundle: nil)
        let pushVC = storyboard.instantiateViewController(withIdentifier: "CRegisterAccountViewController")
        let navVC = UINavigationController(rootViewController:pushVC)
        navVC.modalPresentationStyle = .overFullScreen
        self.present(navVC, animated: true, completion:nil)
        
    }
}
