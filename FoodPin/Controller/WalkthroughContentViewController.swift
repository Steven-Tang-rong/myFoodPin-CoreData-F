//
//  WalkthroughtViewController.swift
//  FoodPin
//
//  Created by TANG,QI-RONG on 2020/6/18.
//  Copyright © 2020 Steven. All rights reserved.
//

import UIKit

class WalkthroughContentViewController: UIViewController {

    @IBOutlet var HeadingLabel: UILabel! {
        didSet{
            HeadingLabel.numberOfLines = 0
        }
    }
    
    @IBOutlet var SubheadingLabel: UILabel! {
        didSet{
            SubheadingLabel.numberOfLines = 0
        }
    }
    
    @IBOutlet var contentImageView: UIImageView!
    
    var index = 0
    var heading = ""
    var subHeading = ""
    var imageFile = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        HeadingLabel.text = heading
        SubheadingLabel.text = subHeading
        contentImageView.image = UIImage(named: imageFile)
        
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
