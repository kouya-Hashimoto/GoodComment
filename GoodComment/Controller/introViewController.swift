//
//  introViewController.swift
//  GoodComment
//
//  Created by 橋本晃矢 on 2021/06/11.
//

import UIKit
import Lottie

class introViewController: UIViewController,UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    
    var onboardArray = ["1","2","3"]
    
    var onbordStringArray = ["テーマに対して自分が思い付いたものを投稿します。","投稿されたものには他のユーザからグッドボタンが押されることがあります。","そのグッド数に応じてランキング形式でテーマに適した投稿がランクインします。",]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.isPagingEnabled = true
        
        setUpScroll()
        
        for i in 0...2{
            
            let animationView = AnimationView()
            let animetion = Animation.named(onboardArray[i])
            animationView.frame = CGRect(x: CGFloat(i) * view.frame.size.width, y: view.frame.size.height, width: view.frame.size.width, height: view.frame.size.height)
            
            animationView.animation = animetion
            animationView.contentMode = .scaleAspectFit
            animationView.loopMode = .loop
            animationView.play()
            scrollView.addSubview(animationView)
        }
        
    }
    
    func setUpScroll() {
        
        scrollView.delegate = self
        
        scrollView.contentSize = CGSize(width: view.frame.size.width * 3, height: scrollView.frame.size.height)
        
        for i in 0...2{
            
            let onboardLabel = UILabel(frame: CGRect(x: CGFloat(i) * view.frame.size.width, y: view.frame.size.height/3, width: scrollView.frame.width, height: view.frame.size.height))
            
            onboardLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
            onboardLabel.textAlignment = .center
            onboardLabel.text = onbordStringArray[i]
            scrollView.addSubview(onboardLabel)
            
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
