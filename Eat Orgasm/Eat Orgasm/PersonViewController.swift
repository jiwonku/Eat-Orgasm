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
    
    
    override func viewDidLoad() {
        super .viewDidLoad()
        
        personTableView.delegate = self
        personTableView.dataSource = self
                
        let personTableViewCell = UINib(nibName: "PersonTableViewCell", bundle: nil)
        self.personTableView.register(personTableViewCell, forCellReuseIdentifier: "PersonTableViewCell")
    }
    
    
    
    
    
    @IBAction func loginButtonTouched(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "LogIn", bundle: nil)
        let logInVC = storyboard.instantiateViewController(withIdentifier: "LogInViewController")
        logInVC.modalTransitionStyle = .coverVertical
        self.present(logInVC, animated: true, completion: nil)
        
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
