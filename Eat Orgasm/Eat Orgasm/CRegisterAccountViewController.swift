//
//  CRegisterAccountViewController.swift
//  Eat Orgasm
//
//  Created by 지원구 on 2022/05/12.
//

import Foundation
import UIKit
import Firebase


class CRegisterAccountViewController : UIViewController
{
    @IBOutlet weak var accountInputTextField: UITextField!
    @IBOutlet weak var pwInputTextField: UITextField!
    
    
    override func viewDidLoad() {
        
        self.modalPresentationStyle = .fullScreen
        
    }
    
    @IBAction func registerButtonTouched(_ sender: Any) {
        
        Auth.auth().createUser(withEmail: accountInputTextField.text!, password: pwInputTextField.text!) { (user, error) in
            
            if user !=  nil{                
                print("register success")
                
                let alert = UIAlertController(title: "success", message: "register success", preferredStyle: UIAlertController.Style.alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    
                }
                alert.addAction(okAction)
                self.present(alert, animated: false, completion: nil)
            }
            
            else{
                print("register failed")
                
                let alert = UIAlertController(title: "fail", message: "register failed", preferredStyle: UIAlertController.Style.alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    
                }
                alert.addAction(okAction)
                self.present(alert, animated: false, completion: nil)
            }
        }
    }
}
