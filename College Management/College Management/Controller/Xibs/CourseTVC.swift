//
//  CourseTVC.swift
//  College Management
//
//  Created by ADMIN on 07/01/24.
//

import UIKit

class CourseTVC: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var courseView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        courseView.layer.cornerRadius = 4
        courseView.layer.borderWidth = 0.1
      //  courseView.backgroundColor = UIColor(hex: 0xDFDFDF)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
