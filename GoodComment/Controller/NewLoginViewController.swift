//
//  NewLoginViewController.swift
//  GoodComment
//
//  Created by 橋本晃矢 on 2021/06/26.
//

import UIKit
import Firebase
import PKHUD

class NewLoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var dontHaveAccountButton: UIButton!
    @IBAction func tappedDontHaveAccountButton(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let LoginViewController = storyBoard.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
        present(LoginViewController, animated: true, completion: nil)
    }
    @IBAction func tappedLoginButton(_ sender: Any) {
        HUD.show(.progress, onView:  self.view)
        print("tapped Login Button")
        
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { (res, err) in
            if let err = err {
                print("ログイン情報の取得に失敗しました。", err)
                return
            }
            
            print("ログインに成功しました")
            
            guard let uid = Auth.auth().currentUser?.uid else { return }
            let userRef = Firestore.firestore().collection("users").document(uid)
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
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let TabBarController = storyBoard.instantiateViewController(identifier: "TabBar") as! TabBarController
        TabBarController.modalPresentationStyle = .fullScreen
        TabBarController.selectedIndex = 1
        present(TabBarController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.layer.cornerRadius = 10
        loginButton.isEnabled = false
        loginButton.backgroundColor = UIColor.rgb(red: 255, green: 221, blue: 187)
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
}
extension NewLoginViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            
            if email.isEmpty || password.isEmpty{
                loginButton.isEnabled = false
                loginButton.backgroundColor = UIColor.rgb(red: 255, green: 221, blue: 187)
            } else {
                loginButton.isEnabled = true
                loginButton.backgroundColor = UIColor.rgb(red: 255, green: 141, blue: 0)
            }
        }
    }
}


/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destination.
 // Pass the selected object to the new view controller.
 }
 */

