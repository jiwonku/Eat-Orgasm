//
//  PersonViewController.swift
//  Eat Orgasm
//
//  Created by 지원구 on 2022/04/30.
//

import Foundation
import UIKit
import FirebaseStorage
import Firebase
import GoogleSignIn
import FirebaseUI
import FirebaseFirestoreSwift


class PersonViewController : UIViewController
{
    @IBOutlet weak var googleLogin: GIDSignInButton!
    @IBOutlet weak var googleLogout: UIButton!
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var userInformationView: UIView!
    
    var isLogged : Bool?
    var db : Firestore!
    let user = Auth.auth().currentUser

    override func viewDidLoad() {
        super .viewDidLoad()

        self.isLogged = false;
        db = Firestore.firestore()
        
        self.googleLogout.isHidden = true
        
        registerAuthStateDidChangeEvent()
        
        //클릭 가능하도록 설정
        self.userInformationView.isUserInteractionEnabled = true
        //제쳐스 추가
        self.userInformationView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.viewTapped)))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    @objc func viewTapped(_ sender: UITapGestureRecognizer) {
        
        let storyboard = UIStoryboard(name: "PersonInformation", bundle: nil)
        let pushVC = storyboard.instantiateViewController(withIdentifier: "CPersonInformationViewController")
        let navVC = UINavigationController(rootViewController:pushVC)
        navVC.modalPresentationStyle = .overFullScreen
        self.present(navVC, animated: true, completion:nil)
    }
    
    @IBAction func googleLoginButtonTouched(_ sender: GIDSignInButton) {
        // 구글 인증
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        
        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { user, error in
            guard error == nil else { return }
                        
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
                guard let email = Auth.auth().currentUser?.email else {return}
                guard let displayName = Auth.auth().currentUser?.displayName else {return}
                
//                guard let user = result?.user else { return } // 파이어베이스 유저 객체를 가져옴
                
                self.userNameLabel.text = displayName
                self.userEmailLabel.text = email
                
                
                guard let userAuth = Auth.auth().currentUser else { return }
                // 전달할 데이터
                let data = ["email": "JTestEmail@gmail.com",
                            "age": "42",
                            "fullName": "Jason2 wonku ji"
                ]
                
                // 가입에 성공하면 그 유저의 uid를 파이어베이스가 생성해준다.
                // 그렇기 때문에 이 uid를 기준으로 특정한 유저 데이터를 저장해야 한다.
                self.db.collection("users").document(userAuth.uid).setData(data) { error in
                    if let error = error {
                        print("DEBUG: \(error.localizedDescription)")
                        return
                    }
                    UserDefaults.standard.set(true, forKey: "isSignIn")
                    NotificationCenter.default.post(name: .authStateDidChange, object: nil)
                    self.navigationController?.dismiss(animated: true, completion: nil)
                    
                }
                // If sign in succeeded, display the app's main content View.
            }
        }
    }

    @IBAction func googleLogout(_ sender: Any) {
        
    }
    
    private func registerAuthStateDidChangeEvent() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(checkLoginIn),
                                               name: .authStateDidChange,
                                               object: nil)
    }
    
    @objc private func checkLoginIn() {
        let isSignIn = UserDefaults.standard.bool(forKey: "isSignIn") == true
        if isSignIn {
            setHome()
        } else {
            routeToLogin()
        }
    }
    
    @IBAction func loginButtonTouched(_ sender: Any) {
        routeToLogin()
    }
    
    private func setHome() {
        self.googleLogout.isHidden = false
        guard let userAuth = Auth.auth().currentUser else { return }
    }
    
    private func routeToLogin() {
        let storyboard = UIStoryboard(name: "LogIn", bundle: nil)
        let pushVC = storyboard.instantiateViewController(withIdentifier: "CLogInViewController")
        let navVC = UINavigationController(rootViewController:pushVC)
        navVC.modalPresentationStyle = .overFullScreen
        self.present(navVC, animated: true, completion:nil)
    }

}

/*
extension PersonViewController : GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        // handle login

        if let authenication = user.authentication {
            print("google sign in \(authenication.idToken)")
            logInButton.isHidden = true
            
        }
        
        guard error == nil else { return }
        
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
            
            //                guard let user = result?.user else { return } // 파이어베이스 유저 객체를 가져옴
            
            
            guard let userAuth = Auth.auth().currentUser else { return }
            // 전달할 데이터
            let data = ["email": "JTestEmail@gmail.com",
                        "age": "40",
                        "fullName": "Jason2 wonku ji"
            ]
            
            // 가입에 성공하면 그 유저의 uid를 파이어베이스가 생성해준다.
            // 그렇기 때문에 이 uid를 기준으로 특정한 유저 데이터를 저장해야 한다.
            self.db.collection("users").document(userAuth.uid).setData(data) { error in
                if let error = error {
                    print("DEBUG: \(error.localizedDescription)")
                    return
                }
                
                UserDefaults.standard.set(true, forKey: "isSignIn")
                NotificationCenter.default.post(name: .authStateDidChange, object: nil)
                self.navigationController?.dismiss(animated: true, completion: nil)
                
            }
            // If sign in succeeded, display the app's main content View.
        }
    }
}
*/
