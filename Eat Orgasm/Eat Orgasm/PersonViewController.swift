//
//  PersonViewController.swift
//  Eat Orgasm
//
//  Created by 지원구 on 2022/04/30.
//

import Foundation
import UIKit


class PersonViewController : UIViewController
{
    @IBOutlet var personTableView: UITableView!
    
    static let shared = PersonViewController()
    
    override func viewDidLoad() {
        super .viewDidLoad()
        
        personTableView.delegate = self
        personTableView.dataSource = self
                
        let personTableViewCell = UINib(nibName: "PersonTableViewCell", bundle: nil)
        self.personTableView.register(personTableViewCell, forCellReuseIdentifier: "PersonTableViewCell")
        
        registerAuthStateDidChangeEvent()
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
//            setHome()
        } else {
            routeToLogin()
        }
    }
    
    @IBAction func loginButtonTouched(_ sender: Any) {
        routeToLogin()
    }
    
    private func routeToLogin() {
        let storyboard = UIStoryboard(name: "LogIn", bundle: nil)
        let pushVC = storyboard.instantiateViewController(withIdentifier: "CLogInViewController")
        let navVC = UINavigationController(rootViewController:pushVC)
        navVC.modalPresentationStyle = .overFullScreen
        self.present(navVC, animated: true, completion:nil)
    }
}


extension PersonViewController : UITableViewDelegate
{
    
    
}


extension PersonViewController : UITableViewDataSource
{
    
    // MARK: UITableViewDataSource delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = personTableView.dequeueReusableCell(withIdentifier: "PersonTableViewCell", for: indexPath) as! PersonTableViewCell
        
        
        
        
        return cell
    }
}
