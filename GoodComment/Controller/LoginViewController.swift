//
//  LoginViewController.swift
//  GoodComment
//
//  Created by 橋本晃矢 on 2021/06/12.
//

import UIKit
import Firebase
import SVProgressHUD
import PKHUD

class DataManeger {
    static let shared = DataManeger()
    var user:User?
}
//ユーザーのモデル
struct User {
    let name: String
    let createdAt: Timestamp
    let email: String
    
    init(dic: [String: Any]) {
        self.name = dic["name"] as! String
        self.createdAt = dic["createdAt"] as! Timestamp
        self.email = dic["email"] as! String
    }
}

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBAction func tappedRegisterButton(_ sender: Any) {
        handleAuthToFirebase()
    }
    @IBAction func tappedAlreadyHaveAccountButton(_ sender: Any) {
        
        let storyBoard = UIStoryboard(name: "Login", bundle: nil)
        let NewLoginViewController = storyBoard.instantiateViewController(identifier: "NewLoginViewController") as! NewLoginViewController
            present(NewLoginViewController, animated: true, completion: nil)
    }
    
    private func handleAuthToFirebase() {
        HUD.show(.progress, onView: view)
        guard let password = passwordTextField.text  else {return}
        guard let email = emailTextField.text else {return}
        
        Auth.auth().createUser(withEmail: email, password: password) { res, err in
            if let err = err {
                print("認証情報の保存に失敗しました。\(err)")
                HUD.hide { (_) in
                    HUD.flash(.error, delay: 1)
                }
                return
            }
            self.addUserinfoToFirestore(email: email)
        }
    }
    
    private func addUserinfoToFirestore(email : String) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        guard let name = self.usernameTextField.text else {return}
        
        let docData = ["email": email, "name": name, "createdAt" : Timestamp()] as [String : Any]
        let userRef = Firestore.firestore().collection("users").document(uid)
        
        userRef.setData(docData) { err in
            if let err = err {
                print("Firestoreへの保存に失敗しました。\(err)")
                HUD.hide { (_) in
                    HUD.flash(.error, delay: 1)
                }
                return
            }
            print("Firestoreへの保存に成功しました。")
            
            UserDefaults.standard.set(self.usernameTextField.text, forKey: "userName")
            
            userRef.getDocument { (snapshot, err) in
                if let err = err {
                    print("ユーザー情報の取得に失敗しました。\(err)")
                    HUD.hide { (_) in
                        HUD.flash(.error, delay: 1)
                    }
                }
                
                guard let data = snapshot?.data() else {return}
                let user = User.init(dic: data)
                DataManeger.shared.user = user
                print("ユーザー情報の取得ができました。\(user.name)")
                HUD.hide { (_) in
                    HUD.flash(.success, onView: self.view, delay: 1) { (_) in
                        self.presentToTabBarController()
                        
                    }
                }
            }
        }
    }
    
    private func presentToTabBarController() {
        let TabBarController = self.storyboard?.instantiateViewController(withIdentifier: "TabBar") as! UITabBarController
        TabBarController.modalPresentationStyle = .fullScreen
        TabBarController.selectedIndex = 1
        self.present(TabBarController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerButton.isEnabled = false
        registerButton.backgroundColor = UIColor.rgb(red: 255, green: 221, blue: 187)
        registerButton.layer.cornerRadius = 10
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        usernameTextField.delegate = self
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(showKeybord), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc func showKeybord() {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        if let email = emailTextField.text, let password = passwordTextField.text, let username = usernameTextField.text {
            
            if email.isEmpty || password.isEmpty || username.isEmpty {
                registerButton.isEnabled = false
                registerButton.backgroundColor = UIColor.rgb(red: 255, green: 221, blue: 187)
            } else {
                registerButton.isEnabled = true
                registerButton.backgroundColor = UIColor.rgb(red: 255, green: 141, blue: 0)
            }
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // キーボードを閉じる
        textField.resignFirstResponder()
        return true
    }
}
