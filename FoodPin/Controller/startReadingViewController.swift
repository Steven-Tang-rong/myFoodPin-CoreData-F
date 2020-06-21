//
//  startReadingViewController.swift
//  FoodPin
//
//  Created by TANG,QI-RONG on 2020/6/20.
//  Copyright © 2020 Steven. All rights reserved.
//

import UIKit

class startReadingViewController: UIViewController, WalkthroughPageViewControllerDelegate {
    

    

    var WalkthroughPageViewController: WalkthroughPageViewController?
   
    @IBOutlet var skipButton: UIButton!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var nextButton: UIButton!{
        didSet{
            nextButton.layer.cornerRadius = 25.0
            nextButton.layer.masksToBounds = true
        }
    }
    
    
    @IBAction func skipButtonTapped(sender: UIButton) {
        UserDefaults.standard.set(true, forKey: "hasViewedWalkthrough")
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextButtonTapped(sender: UIButton) {
        if let index = WalkthroughPageViewController?.currentIndex{
            switch index {
            case 0...1:
                WalkthroughPageViewController?.forwardPage()
                
            case 2:
                UserDefaults.standard.set(true, forKey: "hasViewedWalkthrough")
                dismiss(animated: true, completion: nil)
                
            default: break
                
            }
        }
        
        updateUI()
    }
    
    func updateUI(){
        
        if let index = WalkthroughPageViewController?.currentIndex{
            switch index {
            case 0...1:
                nextButton.setTitle("NEXT", for: .normal)
                skipButton.isHidden = false
              
            case 2:
                nextButton.setTitle("Get Started", for: .normal)
                skipButton.isHidden = true
                
            default: break
                
            }
            pageControl.currentPage = index
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Navigation WalkthroughPageViewController

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        if let pageViewController = destination as? WalkthroughPageViewController {
            WalkthroughPageViewController = pageViewController
            WalkthroughPageViewController?.walkthroughDelegate = self
        }
        
    }
    
    
    // MARK: - WalkthroughPageViewControllerDelegate method
    
    func didUpdatePageIndex(currentIndex: Int) {
        updateUI()
    }
}
