//
//  TabBarController.swift
//  GoodComment
//
//  Created by 橋本晃矢 on 2021/06/14.
//

import UIKit
import Firebase


class TabBarController: UITabBarController {
    var isTutorialEnd = false
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        Firestore.firestore().collection("users").document(uid).getDocument { (snapshot, err) in
            if let err = err {
                print("ユーザー情報の取得に失敗しました。\(err)")
            }
            
            guard let data = snapshot!.data() else {return}
            let user = User.init(dic: data)
            DataManeger.shared.user = user
            print("ユーザー情報の取得ができました。\(user.name)")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        userDefaults.register(defaults: ["tutorial": true])
        
        let tutorialUnend = userDefaults.bool(forKey: "tutorial")
        
        if tutorialUnend {
            let tutorial = self.storyboard?.instantiateViewController(withIdentifier: "tutorial")
            tutorial?.modalPresentationStyle = .fullScreen
            self.present(tutorial!, animated: true, completion: nil)
            userDefaults.set(false, forKey: "tutorial")
            print("チュートリアルを終了した")
            return
        } else {
            print("チュートリアルは終えています")
            
        }
        //currentUserがnilならログインしていない
        if Auth.auth().currentUser == nil {
            //ログインしていない時の処理
            let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController")
            self.present(loginViewController!, animated: true, completion: nil)
        }else {
            selectedIndex = 1
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
    
}

