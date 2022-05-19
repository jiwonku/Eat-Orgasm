//
//  CLogInViewController.swift
//  Eat Orgasm
//
//  Created by 지원구 on 2022/05/11.
//

import Foundation
import UIKit

import Firebase
import GoogleSignIn

class CLogInViewController :UIViewController {
    
    @IBOutlet weak var idInputTextField: UITextField!
    @IBOutlet weak var pwInputTextField: UITextField!
    @IBOutlet weak var googleLogin: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user = Auth.auth().currentUser
        
        if (user != nil) {            
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
    
    @IBAction func googleLoginButtonTouched(_ sender: GIDSignInButton) {
        // 구글 인증
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        
        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { user, error in
            guard error == nil else { return }
                        
//            print("login success")
//            let alert = UIAlertController(title: "success", message: "login success", preferredStyle: UIAlertController.Style.alert)
//            let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
//                
//            }
//            alert.addAction(okAction)
//            self.present(alert, animated: false, completion: nil)
            
            
            // 인증을 해도 계정은 따로 등록을 해주어야 한다.
            // 구글 인증 토큰 받아서 -> 사용자 정보 토큰 생성 -> 파이어베이스 인증에 등록
            guard
                let authentication = user?.authentication,
                let idToken = authentication.idToken
            else {
                return
            }
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: authentication.accessToken)
            
            // 사용자 정보 등록
            Auth.auth().signIn(with: credential) { _, _ in
                // 사용자 등록 후에 처리할 코드
//                guard let email = Auth.auth().currentUser?.email else {return}
                
                if let profiledata = user?.profile {
                    
                    let userId : String = user?.userID ?? ""
                    let givenName : String = profiledata.givenName ?? ""
                    let familyName : String = profiledata.familyName ?? ""
                    let email : String = profiledata.email
                    
                    if let imgurl = user?.profile?.imageURL(withDimension: 100) {
                        let absoluteurl : String = imgurl.absoluteString
                        //HERE CALL YOUR SERVER API
                    }
                }
                
                UserDefaults.standard.set(true, forKey: "isSignIn")
                NotificationCenter.default.post(name: .authStateDidChange, object: nil)

                self.navigationController?.dismiss(animated: true, completion: nil)
                
            }
            // If sign in succeeded, display the app's main content View.
        }
    }
    
    @IBAction func logOutButtonTouched(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("로그아웃 Error발생:", signOutError)
        }
    }
    
    @IBAction func registerButtonTouched(_ sender: Any) {
        let storyboard = UIStoryboard(name: "LogIn", bundle: nil)
        let pushVC = storyboard.instantiateViewController(withIdentifier: "CRegisterAccountViewController")
//        let navVC = UINavigationController(rootViewController:pushVC)
//        navVC.modalPresentationStyle = .overFullScreen
        self.present(pushVC, animated: true, completion:nil)
        
    }
        
    // 다음 함수 추가
    // 로그인 및 사용자 등록에만은 필요 없는 코드
    // 인증이 끝나고 앱이 받는 url을 처리
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        var handled: Bool
        
        handled = GIDSignIn.sharedInstance.handle(url)
        if handled {
            // Handle other custom URL types.
                        
            return true
        }
        
        // If not handled by this app, return false.
        return false
    }

}
