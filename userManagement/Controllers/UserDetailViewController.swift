//
//  UserDetailViewController.swift
//  userManagement
//
//  Created by USER on 2022/10/21.
//

import UIKit

class UserDetailViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    //UserLisrControllerから値を受け取る
    var argString: User?
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitView()
    }
    private func setInitView() {
        //　 入力フィールド　ー　年齢
        ageTextField.delegate = self
        ageTextField.isEnabled = false
        //　 入力フィールド　ー　名前
        nameTextField.delegate = self
        nameTextField.isEnabled = false
        
        saveButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //受け取って値を代入
        nameTextField.text = argString?.name
        ageTextField.text = String(describing: argString!.age)
    }
    
    @IBAction func editPressed(_ sender: UIButton) {
        ageTextField.isEnabled = true
        nameTextField.isEnabled = true
        nameTextField.becomeFirstResponder()
        saveButton.isEnabled = true
    }
    
    @IBAction func savePressed(_ sender: UIButton) {
        let nameString = nameTextField.text ?? ""
        let ageString = ageTextField.text ?? ""
        
        if argString?.name != nameString  {
            //入力されない場合
            if nameTextField.text == ""{
                showAlert(title: "Alert", messenger: Constants.Warning.WARNING_NAME)
                return
            }
            argString?.name = nameTextField.text!
        }

        if argString!.age != Int(ageString)  {
            //number - regex
            if !checkForm(ageString: ageString) {
                showAlert(title: "Error", messenger: Constants.Warning.WARNING_NUMBER_1)
                ageTextField.textColor = .red
                ageTextField?.becomeFirstResponder()
                return
            }
            argString?.age = Int(ageString) ?? 0
        }
        if DBService.shared.updateData(user: argString!) {
            print(Constants.Alert.ALERT_UPDATE)
            ageTextField.isEnabled = false
            nameTextField.isEnabled = false
            ageTextField.textColor = .black
            showAlert(title: "Alert", messenger: Constants.Alert.ALERT_EDIT)
        }else {
            print(Constants.Error.ERROR_UPDATE)
        }
    }
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        ageTextField.isEnabled = false
        nameTextField.isEnabled = false
        nameTextField.text = argString?.name
        ageTextField.text = String(describing: argString!.age)
    }
    
    func showAlert(title: String, messenger: String) {
        let alert = UIAlertController(title: title, message: messenger, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    func checkForm(ageString: String) -> Bool {
        //age regex
        let testString = ageString
        let range = NSRange(location: 0, length: testString.utf16.count)
        let regex = try! NSRegularExpression(pattern: "^(0?[1-9]|[1-9][0-9]|[1][1-9][1-9]|200)$")
        if regex.firstMatch(in: testString, options: [], range: range) == nil {
            return false
        }
        return true
    }
}
