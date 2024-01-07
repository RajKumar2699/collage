//
//  HomeVC.swift
//  College Management
//
//  Created by ADMIN on 07/01/24.
//

import UIKit

class HomeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func logoutBtnTapped(_ sender: UIButton) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let Vc = storyBoard.instantiateViewController(identifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController(Vc, animated: true)
    }
}
