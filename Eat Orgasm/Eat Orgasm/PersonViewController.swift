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
//    @IBOutlet var personTableView: UITableView!
    @IBOutlet weak var logInButton: UIButton!
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var updateButton: UIButton!
    
    var isLogged : Bool?
    
    private lazy var imagePicker: UIImagePickerController = {
            let picker = UIImagePickerController()
            picker.delegate = self
            return picker
        }()
    
//    static let shared = PersonViewController()
    
    override func viewDidLoad() {
        super .viewDidLoad()
        
//        personTableView.delegate = self
//        personTableView.dataSource = self
//
//        let personTableViewCell = UINib(nibName: "PersonTableViewCell", bundle: nil)
//        self.personTableView.register(personTableViewCell, forCellReuseIdentifier: "PersonTableViewCell")
        
        registerAuthStateDidChangeEvent()
        
        self.isLogged = false;
        
        self.nameTextField.isEnabled = false
        self.emailTextField.isEnabled = false
        self.ageTextField.isEnabled = false
        self.updateButton.isEnabled = false
        
        
        //어떤 버튼 눌렸는지 구분하기 위함
        profileImage.tag = 1004
        //클릭 가능하도록 설정
        self.profileImage.isUserInteractionEnabled = true
        //제쳐스 추가
        self.profileImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.viewTapped)))
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
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
    
    private func setHome() {
        
        self.logInButton.setTitle("LogOut", for: .normal)
        self.isLogged = true
        
        self.nameTextField.isEnabled = true
        self.emailTextField.isEnabled = true
        self.ageTextField.isEnabled = true
        self.updateButton.isEnabled = true
        
        guard let userAuth = Auth.auth().currentUser else { return }
        
        
        
//        Firestore.firestore().collection("user").document(userAuth.uid).getDocument { snapshot, error in
//            guard let userData = try? snapshot?.data(as: User.self) else { return } // 매핑(FirebaseFirestoreSwift 라이브러리를 추가해야 사용가능)
//            
//            self.currentUser = userData
//        }
//        
//        Firestore.firestore().collection("user").getDocuments { snapshot, error in
//                if let error = error {
//                    print("DEBUG: \(error.localizedDescription)")
//                    return
//                }
//
//                guard let documents = snapshot?.documents else { return } // document들을 가져옴
//
//                let users = documents.compactMap( { try? $0.data(as: User.self) }) // User 구조체로 전부 매핑
//            }
//        }
        
//        if let profiledata = userAuth.profile {
//
//            let userId : String = userAuth.userID ?? ""
//            let givenName : String = profiledata.givenName ?? ""
//            let familyName : String = profiledata.familyName ?? ""
//            let email : String = profiledata.email
//
//            if let imgurl = userAuth.profile?.imageURL(withDimension: 100) {
//                let absoluteurl : String = imgurl.absoluteString
//                //HERE CALL YOUR SERVER API
//            }
//        }
        
        didTapLoadImageFromFirebaseButton()
        
    }
    
    @IBAction func loginButtonTouched(_ sender: Any) {
        routeToLogin()
    }
    
    @objc func viewTapped(_ sender: UITapGestureRecognizer) {
        print("\(sender.view!.tag) 클릭됨")
        
        present(imagePicker, animated: true)
                
    }
    
    private func routeToLogin() {
        let storyboard = UIStoryboard(name: "LogIn", bundle: nil)
        let pushVC = storyboard.instantiateViewController(withIdentifier: "CLogInViewController")
        let navVC = UINavigationController(rootViewController:pushVC)
        navVC.modalPresentationStyle = .overFullScreen
        self.present(navVC, animated: true, completion:nil)
    }
    
    @objc private func didTapLoadImageFromFirebaseButton() {
        guard let urlString = UserDefaults.standard.string(forKey: "imageURL") else { return }
        
        FirebaseStorageManager.downloadImage(urlString: urlString) { [weak self] image in
            self?.profileImage.image = image
        }
    }
}

extension PersonViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage,
              let user = Auth.auth().currentUser else { return }
        
        FirebaseStorageManager.uploadImage(image: selectedImage, pathRoot: user.uid) { url in
            if let url = url {
                UserDefaults.standard.set(url.absoluteString, forKey: "imageURL")
                
                guard let userAuth = Auth.auth().currentUser else { return }
                // 전달할 데이터
                let data = ["email": "JTestEmail@gmail.com",
                            "age": "40",
                            "fullName": "Jason2 wonku ji",
                            "imageURL" : url.absoluteString
                ]
                
                Firestore.firestore().collection("users").document(userAuth.uid).setData(data) { error in
                    if let error = error {
                        print("DEBUG: \(error.localizedDescription)")
                        return
                    }
                }
                
                self.didTapLoadImageFromFirebaseButton()
            }
        }
        
        picker.dismiss(animated: true)                
    }
}


//extension PersonViewController : UITableViewDelegate
//{
////    // MARK: UITableViewDelegate delegate
////    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
////        <#code#>
////    }
//
//}
//
//
//extension PersonViewController : UITableViewDataSource
//{
//    
//    // MARK: UITableViewDataSource delegate
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1;
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = personTableView.dequeueReusableCell(withIdentifier: "PersonTableViewCell", for: indexPath) as! PersonTableViewCell
//        
//        
//        
//        
//        return cell
//    }
//}
