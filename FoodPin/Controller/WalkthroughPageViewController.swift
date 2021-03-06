//
//  WalkthroughPageViewController.swift
//  FoodPin
//
//  Created by TANG,QI-RONG on 2020/6/18.
//  Copyright © 2020 Steven. All rights reserved.
//

import UIKit

//自己定義protocal
protocol WalkthroughPageViewControllerDelegate: class{
    func didUpdatePageIndex(currentIndex: Int)
}

class WalkthroughPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    
    
    var pageHeadings = ["CREATE YOUR OWN FOOD GUIDE", "SHOW YOU THE LOCATION", "DISCOVER GREAT RESTAURANTS"]
    var pageImages = ["onboarding-1", "onboarding-2", "onboarding-3"]
    var pageSubHeadings = ["Pin your favorite restaurants and create your own food guide","Search and locate your favourite restaurant on Maps",
        "Find restaurants shared by your friends and other foodies"]

    //weak 防止記憶體洩漏
    weak var walkthroughDelegate: WalkthroughPageViewControllerDelegate?
    var currentIndex = 0
    
    override func viewDidLoad() {
           super.viewDidLoad()

            delegate = self
        
           //將資料源設定為自己
           dataSource = self
           
           //建立第一個導覽畫面
           if let startingViewController = contentViewController(at: 0) {
               setViewControllers([startingViewController], direction: .forward, animated: true, completion: nil)
           }
        
       }
    
    // MARK: - UIPageViewControllerDataSource methods
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! WalkthroughContentViewController).index
        index -= 1
        
        return contentViewController(at: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! WalkthroughContentViewController).index
        index += 1
        
        return contentViewController(at: index)
    }
    

    func contentViewController(at index: Int) -> WalkthroughContentViewController? {
        if index < 0 || index >= pageHeadings.count {
            return nil
        }
        
        //建立新的視圖控制器並傳遞適合的資料
        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
        if let pageContentViewController = storyboard.instantiateViewController(withIdentifier: "WalkthroughContentViewController") as? WalkthroughContentViewController {
            
            pageContentViewController.imageFile = pageImages[index]
            pageContentViewController.heading = pageHeadings[index]
            pageContentViewController.subHeading = pageSubHeadings[index]
            pageContentViewController.index = index
            
            return pageContentViewController
        }
        return nil
    }
   
    
    //MARK: - 顯示在下一個導覽畫面
    
    func forwardPage() {
        currentIndex += 1
        if let nextViewController = contentViewController(at: currentIndex) {
            setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
   // MARK: - UIPageViewControllerDelegate methods

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if completed {
            
            if let contentViewController = pageViewController.viewControllers?.first as? WalkthroughContentViewController {
                
                currentIndex = contentViewController.index
                
                walkthroughDelegate?.didUpdatePageIndex(currentIndex: contentViewController.index)
            }
        }
    }
    



}
