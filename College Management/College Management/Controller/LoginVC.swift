//
//  LoginVC.swift
//  College Management
//
//  Created by ADMIN on 05/01/24.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var psswrdTxt: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func forgotPsswrdBtnTapped(_ sender: UIButton) {
        // Implement forgot password functionality if needed
    }

    @IBAction func loginBtnTapped(_ sender: UIButton) {
        loginApi()
    }

    @IBAction func signUpBtnTapped(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(identifier: "SignUpVC") as! SignUpVC
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func loginApi() {
            guard let email = emailTxt.text, let password = psswrdTxt.text else {
                print("Invalid email or password")
                return
            }

            let parameters = ["email": email, "password": password]

            NetworkManager.shared.request(method: .post, endpoint: "/login", parameters: parameters) { (result: Result<APIResponse, Error>) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let apiResponse):
                        
                        let StoryBoard = UIStoryboard(name: "HomeStoryBoard", bundle: nil)
                        let Vc = StoryBoard.instantiateViewController(identifier: "HomeVC") as! HomeVC
                        self.navigationController?.pushViewController(Vc, animated: true)
                        
                        print("Received API response: \(apiResponse)")
                        // You can parse the apiResponse and handle accordingly
                    case .failure(let error):
                        print("Error: \(error)")

                        if let apiError = error as? NetworkManager.APIError {
                            switch apiError {
                            case .unauthorized:
                                print("Unauthorized access. Check credentials.")
                            default:
                                break
                            }
                        }
                    }
                }
            }
        }
    }
