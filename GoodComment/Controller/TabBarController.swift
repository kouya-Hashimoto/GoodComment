//
//  TabBarController.swift
//  GoodComment
//
//  Created by 橋本晃矢 on 2021/06/14.
//

import UIKit
import Firebase

let userDefaults = UserDefaults.standard

class TabBarController: UITabBarController {
    var isTutorialEnd = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !isTutorialEnd {
            let tutorial = self.storyboard?.instantiateViewController(withIdentifier: "tutorial")
            tutorial?.modalPresentationStyle = .fullScreen
            self.present(tutorial!, animated: true, completion: nil)
            
            return
        }
        //currentUserがnilならログインしていない
        if Auth.auth().currentUser == nil {
            //ログインしていない時の処理
            let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
            self.present(loginViewController!, animated: true, completion: nil)
            
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
