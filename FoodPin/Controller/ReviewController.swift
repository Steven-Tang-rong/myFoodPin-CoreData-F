//
//  ReviewController.swift
//  FoodPin
//
//  Created by TANG,QI-RONG on 2020/5/27.
//  Copyright © 2020 Steven. All rights reserved.
//

import UIKit

class ReviewController: UIViewController {

    @IBOutlet var backgroundImageView: UIImageView!
    var ReviewRestaurant: RestaurantMO!
    
    //使用陣列讓Outlet集合
    @IBOutlet var rateButtons: [UIButton]!
    @IBOutlet var xxxButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let restaurantImage = ReviewRestaurant.image {
            backgroundImageView.image = UIImage(data: restaurantImage as Data)
        }
        
        //let moveRightTransMove = CGAffineTransform.init(translationX: 600, y: 0)
        
        //按鈕隱藏
        let blurEffect = UIBlurEffect(style: .systemChromeMaterialDark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        backgroundImageView.addSubview(blurEffectView)
        
        //組合兩種變形效果
/*        let moveRightTransform = CGAffineTransform.init(translationX: 600, y: 0)
        let scaleUpTransform = CGAffineTransform.init(scaleX: 5.0, y: 5.0)
        let moveScaleTransform = scaleUpTransform.concatenating(moveRightTransform)
        let moveUpTransform = CGAffineTransform.init(translationX: 0, y: -600)
*/
        
        for RateButton in rateButtons {
            RateButton.alpha = 0
          //RateButton.transform = moveRightTransMove
        }
        self.xxxButton.alpha = 0
        
        
    }
    
    //按鈕逐漸顯示
    override func viewWillAppear(_ animated: Bool) {

        for animateIndex in 0...4 {
            UIView.animate(withDuration: 1.4, delay: (0.15 + 0.10 * Double(animateIndex)), options: [], animations: {
                self.rateButtons[animateIndex].alpha = 1.0
              //self.rateButtons[index].transform = .identity
            }, completion: nil)
        }
        
        UIView.animate(withDuration: 1.0, delay: 0.24, options: [], animations: {
            self.xxxButton.alpha = 1.0
            self.xxxButton.transform = .identity
        }, completion: nil)
        
        
/*
        // Damping = 阻尼
        
         for index in 0...4 {
            UIView.animate(withDuration: 1.4, delay: (0.15 + 0.10 * Double(index)), usingSpringWithDamping: 0.2, initialSpringVelocity: 0.3, options: [], animations: {
                self.rateButtons[index].alpha = 1.0
                self.rateButtons[index].transform = .identity
            }, completion: nil)
        }

       
        
        
 */

    }



}
