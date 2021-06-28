//
//  SettingViewController.swift
//  GoodComment
//
//  Created by 橋本晃矢 on 2021/06/12.
//

import UIKit
import Firebase

class SettingViewController: UIViewController {
    
    //値が入った場合起動する
    var user: User? {
        didSet {
            print("user?.name" , user?.name)
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var LogoutButton: UIButton!
    @IBAction func tappedLogoutButton(_ sender: Any) {
        handleLogout()
    }
    
    private func handleLogout() {
        do {
            try Auth.auth().signOut()
            let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController")
            self.present(loginViewController!, animated: true, completion: nil)
        } catch (let err) {
            print("ログアウトに失敗しました: \(err)")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        LogoutButton.layer.cornerRadius = 10
        
        if Auth.auth().currentUser != nil {
            user = DataManeger.shared.user
            if let user = user {
                nameLabel.text = user.name + "さんようこそ"
                emailLabel.text = user.email
                let dateString = dateFormatterForcreatedAt(date: user.createdAt.dateValue())
                dateLabel.text = "作成日:    " + dateString
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //confirmLoggedInUser()
    }
    
    private func confirmLoggedInUser() {
        if Auth.auth().currentUser?.uid == nil || user == nil {
            let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController")
            self.present(loginViewController!, animated: true, completion: nil)
        }
        
    }
    
    private func dateFormatterForcreatedAt(date: Date) -> String {
        let fomatter = DateFormatter()
        fomatter.dateStyle = .long
        fomatter.timeStyle = .none
        fomatter.locale = Locale(identifier: "ja_JP")
        return fomatter.string(from: date)
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
