//
//  PersonTableViewCell.swift
//  Eat Orgasm
//
//  Created by 지원구 on 2022/04/30.
//

import Foundation
import UIKit

class PersonTableViewCell : UITableViewCell {
    
    @IBOutlet var personImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        personImageView.layer.cornerRadius = personImageView.frame.width/2
        
    }
    
}
