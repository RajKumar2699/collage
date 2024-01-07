//
//  SignUpVC.swift
//  College Management
//
//  Created by ADMIN on 05/01/24.
//

import UIKit

class SignUpVC: UIViewController {

    @IBOutlet weak var branchTableView: UITableView!
    @IBOutlet weak var courseTableView: UITableView!
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var registrationTxt: UITextField!
    @IBOutlet weak var courseTxt: UITextField!
    @IBOutlet weak var semesterTxt: UITextField!
    @IBOutlet weak var branchTxt: UITextField!
    @IBOutlet weak var batchTxt: UITextField!
    @IBOutlet weak var mobileTxt: UITextField!
    @IBOutlet weak var addressTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var psswrdTxt: UITextField!
    
    
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var registrationView: UIView!
    @IBOutlet weak var courseView: UIView!
    @IBOutlet weak var semesterView: UIView!
    @IBOutlet weak var branchView: UIView!
    @IBOutlet weak var batchView: UIView!
    @IBOutlet weak var mobileView: UIView!
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var psswrdView: UIView!
    @IBOutlet weak var countryCodeView: UIView!
    
        // Array to store the courses fetched from the API
    var branches: [String] = []
        var courses: [Course] = []
        var isDropdownVisible = false

        override func viewDidLoad() {
            super.viewDidLoad()
            branchTableView.delegate = self
            branchTableView.dataSource = self
            branchTableView.isHidden = true
            courseTableView.delegate = self
            courseTableView.dataSource = self
            courseTableView.isHidden = true
            fetchAllCourses()
            cornerRadius()
            branchTableView.rowHeight = UITableView.automaticDimension
            branchTableView.estimatedRowHeight = 44.0
            courseTxt.delegate = self
            branchTxt.delegate = self
            courseTableView.register(UINib(nibName: "CourseTVC", bundle: nil), forCellReuseIdentifier: "CourseTVC")
            branchTableView.register(UINib(nibName: "CourseTVC", bundle: nil), forCellReuseIdentifier: "CourseTVC")
        }
    
    func cornerRadius(){
        nameView.layer.cornerRadius = 4
        nameView.layer.borderWidth = 0.1
        registrationView.layer.cornerRadius = 4
        registrationView.layer.borderWidth = 0.1
        courseView.layer.cornerRadius = 4
        courseView.layer.borderWidth = 0.1
        semesterView.layer.cornerRadius = 4
        semesterView.layer.borderWidth = 0.1
        branchView.layer.cornerRadius = 4
        branchView.layer.borderWidth = 0.1
        mobileView.layer.cornerRadius = 4
        mobileView.layer.borderWidth = 0.1
        addressView.layer.cornerRadius = 4
        addressView.layer.borderWidth = 0.1
        emailView.layer.cornerRadius = 4
        emailView.layer.borderWidth = 0.1
        psswrdView.layer.cornerRadius = 4
        psswrdView.layer.borderWidth = 0.1
        countryCodeView.layer.cornerRadius = 4
        countryCodeView.layer.borderWidth = 0.1
        
    }
    
    @IBAction func eyeBtnTapped(_ sender: UIButton) {
    }
    
    @IBAction func signUpBtnTapped(_ sender: UIButton) {
        signUpApi()
    }
    
    @IBAction func loginBtnTapped(_ sender: UIButton) {
        let Vc = self.storyboard?.instantiateViewController(identifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController(Vc, animated: true)
    }
    
    func signUpApi() {
        let parameters = ["name": nameTxt.text!, "registrationNumber": registrationTxt.text!, "course": courseTxt.text!,"semester": semesterTxt.text!,"branch": branchTxt.text!,"batch": branchTxt.text!,"address": addressTxt.text!,"mobile": mobileTxt.text!,"email": emailTxt.text!,"password": psswrdTxt.text!] as [String : Any]
          
        NetworkManager.shared.request(method: .post, endpoint: "/signup", parameters: parameters) { (result: Result<APIResponse, Error>) in
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
    
    
    func fetchAllCourses() {
            NetworkManager.shared.request(method: .get, endpoint: "/allcourse", parameters: nil) { (result: Result<APIResponse, Error>) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let apiResponse):

                        self.courses = apiResponse.response
                        
                        self.branches = self.courses.flatMap { $0.branches }

                        self.courseTableView.reloadData() 
                        self.branchTableView.reloadData()

                    case .failure(let error):
                        print("Error: \(error)")

                        // Handle the error as needed

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

extension SignUpVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case courseTableView:
            return courses.count
        case branchTableView:
            return branches.first?.count ?? 0
        default:
            return 0
        }
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier: String

        switch tableView {
        case courseTableView:
            cellIdentifier = "CourseTVC"
        case branchTableView:
            cellIdentifier = "CourseTVC"
        default:
            fatalError("Unexpected table view")
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CourseTVC

        switch tableView {
        case courseTableView:
            let course = courses[indexPath.row]
            cell.titleLbl.text = course.name
        case branchTableView:
            let branch = branches[indexPath.row]
            // Assuming your BranchTVC has a titleLbl property
            cell.titleLbl.text = branch
        default:
            break
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                switch tableView {
                case courseTableView:
                    let selectedCourse = courses[indexPath.row]
                    courseTxt.text = selectedCourse.name
                    toggleDropdown(for: courseTableView)
                    break

                case branchTableView:
                    let selectedBranch = branches[indexPath.row]
                    branchTxt.text = selectedBranch
                    toggleDropdown(for: branchTableView)
                    // Additional actions specific to the branch table view
                    break

                default:
                    break
                }
            }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch tableView {
        case courseTableView:
            return UITableView.automaticDimension
        case branchTableView:
            return UITableView.automaticDimension
        default:
            // Provide a default return value for other cases
            return 0.0
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        switch tableView {
        case courseTableView:
            return 44.0
        case branchTableView:
            return 44.0
        default:
            return 0.0
        }
    }

}

extension SignUpVC: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        switch textField {
        case courseTxt:
            toggleDropdown(for: courseTableView)
            return false

        case branchTxt:
            toggleDropdown(for: branchTableView)
            return false

        default:
            return true
        }
    }

    func toggleDropdown(for tableView: UITableView) {
        isDropdownVisible.toggle()

        if isDropdownVisible {
            tableView.isHidden = false
        } else {
            tableView.isHidden = true
        }
    }
}
