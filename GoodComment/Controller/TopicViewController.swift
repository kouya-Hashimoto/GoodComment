//
//  TopicViewController.swift
//  GoodComment
//
//  Created by 橋本晃矢 on 2021/06/12.
//

import UIKit
import Firebase
import EMAlertController

class TopicViewController: UIViewController {
    
    
    //DBの場所を指定
    let db1 = Firestore.firestore().collection("Odai").document("YgYiIYfPek8bdFAzIZmb")
    
    let db2 = Firestore.firestore()
    
    var userName = String()
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var odaiLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.object(forKey: "userName") != nil{
            
            userName = UserDefaults.standard.object(forKey: "userName") as! String
            
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
        //ロード
        loadQuestionData()
    }
    
    func loadQuestionData() {
        db1.getDocument { (snapShot, error) in
            if let error = error {
                return
            }
            
            let data = snapShot?.data()
            self.odaiLabel.text = data!["odaiText"] as! String
        }
    }
    @IBAction func send(_ sender: Any) {
        
        db2.collection("Answers").document().setData(["answer": textView.text as Any ,"userName":userName,"postDate": Timestamp()])
        
        //アラート
        let alert = EMAlertController(icon: UIImage(named: "check"), title: "投稿完了！", message: "みんなの回答を見てみよう！")
        let doneAction = EMAlertAction(title: "OK", style: .normal)
        alert.addAction(doneAction)
        present(alert, animated: true, completion: nil)
        textView.text = ""
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


