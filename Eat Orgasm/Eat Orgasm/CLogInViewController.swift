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
import FirebaseStorage
import FirebaseUI
import FirebaseFirestoreSwift

class CLogInViewController :UIViewController {
    
    @IBOutlet weak var idInputTextField: UITextField!
    @IBOutlet weak var pwInputTextField: UITextField!
    @IBOutlet weak var googleLogin: GIDSignInButton!
    @IBOutlet weak var personalInformaion: UIButton!
    //    let db = Storage.storage().reference()
    
    var db : Firestore!
    
    let user = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
                       
        if (user != nil) {            
            self.idInputTextField.placeholder = "Input ID"
            self.pwInputTextField.placeholder = "Input PW"
        }
        
        db = Firestore.firestore()
        
        self.personalInformaion.isHidden = true
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
                
                
                self.personalInformaion.isHidden = false
                
                
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
                    
//                    self.userSession = user // 가입하면 바로 로그인 되도록 세션 등록
                    
//                    Firestore.firestore().collection("users").document(userAuth.uid).getDocument { snapshot, error in
//                        guard let userData = try? snapshot?.data(as: User.self) else { return } // 매핑(FirebaseFirestoreSwift 라이브러리를 추가해야 사용가능)
//                        
//                        self.currentUser = userData
//                    }
                }
                
//                if let profiledata = userAuth.profile {
//
//                    let userId : String = userAuth.userID ?? ""
//                    let givenName : String = profiledata.givenName ?? ""
//                    let familyName : String = profiledata.familyName ?? ""
//                    let email : String = profiledata.email
//
//                    if let imgurl = userAuth.profile?.imageURL(withDimension: 100) {
//                        let absoluteurl : String = imgurl.absoluteString
//                        //HERE CALL YOUR SERVER API
//                    }
//                }
                
                UserDefaults.standard.set(true, forKey: "isSignIn")
                NotificationCenter.default.post(name: .authStateDidChange, object: nil)
                self.navigationController?.dismiss(animated: true, completion: nil)
                
            }
            // If sign in succeeded, display the app's main content View.
        }
    }
    
    @IBAction func personalInformationButtonTouched(_ sender: Any) {
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
