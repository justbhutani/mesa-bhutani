//
//  OnboardingVC.swift
//  Mesa
//
//  Created by Vibes on 5/20/17.
//  Copyright © 2017 PZRT. All rights reserved.
//

import UIKit

class OnboardingVC: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var dots: UIView!
    
    @IBOutlet weak var blackDot: UIView!
    
    var images = [ "onboardingDummy" , "onboardingDummy" , "split" ]
    
    @IBOutlet weak var welcomeButtonLayer: UIButton!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    @IBAction func welcomeButton(_ sender: Any) {
        
        UIView.animate(withDuration: 0.75, animations: {
            self.dots.alpha = 0
            self.welcomeButtonLayer.alpha = 0
            self.scrollView.alpha = 0
        }) { (true) in
            self.performSegue(withIdentifier: "welcome", sender: Any?.self)
        }
    }
    
    var obText = ["Order from your phone at your favorite restaurants",
                  "Beautiful pictures of everything on the menu",
                  "Split the cheque with your friends"]

    override func viewDidLoad() {
        super.viewDidLoad()
        welcomeButtonLayer.alpha = 0
        welcomeButtonLayer.isEnabled = false
        scrollView.delegate = self
        setupScrollView()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupScrollView() {
        
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        scrollView.contentSize = CGSize(width: view.frame.width * 3, height: view.frame.height)
        
        scrollView.isPagingEnabled = true
    
        
        for i in 0...2 {
            
            let obView:OnboardingView = Bundle.main.loadNibNamed("OnboardingView", owner: self, options: nil)?.first as! OnboardingView
            
            obView.image.image = UIImage(named: images[i])
            obView.text.text = obText[i]
            
            obView.frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
            
            scrollView.addSubview(obView)
            
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let relativePosition = scrollView.contentOffset.x/view.frame.width
        
        blackDot.transform = CGAffineTransform(translationX: relativePosition*23, y: 0)
        
        if relativePosition == 2.0 {
            
            UIView.animate(withDuration: 0.3, animations: { 
                self.welcomeButtonLayer.alpha = 1
            })
            
            self.welcomeButtonLayer.isEnabled = true
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
