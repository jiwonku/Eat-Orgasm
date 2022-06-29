//
//  CPersonInformationViewController.swift
//  Eat Orgasm
//
//  Created by 지원구 on 2022/06/26.
//

import Foundation
import UIKit

import Firebase
import GoogleSignIn
import FirebaseStorage
import FirebaseUI
import FirebaseFirestoreSwift

class CPersonInformationViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var updateButton: UIButton!
    
    let user = Auth.auth().currentUser
    
    private lazy var imagePicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.delegate = self
        return picker
    }()
    
    
    
    override func viewDidLoad() {
        super .viewDidLoad()
        
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
        
        setHome()
        
    }
    
    private func setHome() {
        
        self.nameTextField.isEnabled = true
        self.emailTextField.isEnabled = true
        self.ageTextField.isEnabled = true
        self.updateButton.isEnabled = true
        
        guard let userAuth = Auth.auth().currentUser else { return }        
        guard let email = userAuth.email else {return}
        guard let displayName = userAuth.displayName else {return}
        self.nameTextField.text = displayName
        self.emailTextField.text = email
        
        didTapLoadImageFromFirebaseButton()
    }
    
    @objc func viewTapped(_ sender: UITapGestureRecognizer) {
        print("\(sender.view!.tag) 클릭됨")
        
        present(imagePicker, animated: true)
        
    }
    
    @objc private func didTapLoadImageFromFirebaseButton() {
        guard let urlString = UserDefaults.standard.string(forKey: "imageURL") else { return }
        
        FirebaseStorageManager.downloadImage(urlString: urlString) { [weak self] image in
            self?.profileImage.image = image
        }
    }
}


extension CPersonInformationViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage,
              let user = Auth.auth().currentUser else { return }
        
        self.profileImage.image = selectedImage
        
        
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
