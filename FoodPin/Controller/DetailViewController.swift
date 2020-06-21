//
//  DetailViewController.swift
//  FoodPin
//
//  Created by TANG,QI-RONG on 2020/5/13.
//  Copyright © 2020 Steven. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var restaurantDetail: RestaurantMO!
    
    // Chapter 14
       @IBOutlet var tableView: UITableView!
       @IBOutlet var headerView: detailHeaderView!
       
       @IBOutlet var restaurantImageView: UIImageView!
       @IBOutlet var nameOfRestaurant: UILabel!
       @IBOutlet var locationOfRestaurant: UILabel!
       @IBOutlet var typeOfRestaurant: UILabel!
    
    // Chapter 15
    override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
          
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.setNavigationBarHidden(false, animated: true)
      }
    // Status bar configuration
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
// MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int{
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row{
            
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailIconTextCell.self), for: indexPath) as! RestaurantDetailIconTextCell
            
            cell.iconImageView.image = UIImage(systemName: "phone")?.withTintColor(#colorLiteral(red: 1, green: 0.4934554561, blue: 0.5243053216, alpha: 1), renderingMode: .alwaysOriginal)
            cell.shortTextLabel.text = restaurantDetail.phone
            cell.selectionStyle = .none
            
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailIconTextCell.self), for: indexPath) as! RestaurantDetailIconTextCell
            
            cell.iconImageView.image = UIImage(systemName: "map")?.withTintColor(#colorLiteral(red: 1, green: 0.4934554561, blue: 0.5243053216, alpha: 1), renderingMode: .alwaysOriginal)
            cell.shortTextLabel.text = restaurantDetail.location
            cell.selectionStyle = .none
            
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailTextCell.self), for: indexPath) as! RestaurantDetailTextCell
            
            cell.descriptionLabel.text = restaurantDetail.summary
            cell.selectionStyle = .none
            
            return cell
            
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: String (describing: DetailSeparatorCell.self), for: indexPath) as! DetailSeparatorCell
            
            cell.titleLabel.text = "想要到達目的地?"
            cell.selectionStyle = .none
            
            return cell
            
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DetailMapCell.self), for: indexPath) as! DetailMapCell
            
            if let restaurantLocation = restaurantDetail.location {
                cell.configure(location: restaurantLocation)
            }
            
            return cell
            
        default:
            fatalError("Failed to instantiate the table view cell for detail view controller")
        }
    }
    
    
    
//MARK: - Send data to MapView
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "showMap" {
            let destinationController = segue.destination as! MapViewController
            destinationController.MapRestaurant = restaurantDetail
                
//MARK: - Send data to ReviewController
            
            } else if segue.identifier == "showReview" {
               
                let destinationController = segue.destination as! ReviewController
                destinationController.ReviewRestaurant = restaurantDetail
           
            }

    }
    
//MARK: - Chapter 17 - closeButton
            
        @IBAction func closeForReview(segue: UIStoryboardSegue){
            dismiss(animated: true, completion: nil)
        }
  
    
        @IBAction func rateRestaurant(segue: UIStoryboardSegue) {
          
            dismiss(animated: true, completion: {
            if let rating = segue.identifier{
                self.restaurantDetail.rating = rating
                self.headerView.ratingImageView.image = UIImage(named: rating)
         //以上為取得退回的 identifier
                
                if let appdelegate = (UIApplication.shared.delegate as? AppDelegate){
                    appdelegate.saveContext()
                }
                
                let scaleTransform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
                self.headerView.ratingImageView.transform = scaleTransform
                self.headerView.ratingImageView.alpha = 0
              
                UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.7, options: [], animations: {
                   
                    self.headerView.ratingImageView.transform = .identity
                    self.headerView.ratingImageView.alpha = 1
                }, completion: nil)
            }
        })
            
            
    }
         
        
    

  
// MARK: - View controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerView.nameLabel.text = restaurantDetail.name
        headerView.typeLabel.text = restaurantDetail.type
        if let restaurantImage = restaurantDetail.image {
            headerView.headerImageView.image = UIImage(data: restaurantImage as Data)
        }
        headerView.heartImageView.isHidden = (restaurantDetail.isVisited) ? false : true
        
        navigationItem.largeTitleDisplayMode = .never
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        //Chapter 15
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 1, green: 0.7030856715, blue: 0.6947818178, alpha: 1)
        navigationController?.hidesBarsOnSwipe = false
        
        tableView.contentInsetAdjustmentBehavior = .never //消除最上方白色區塊
             
        //更新託管物件 儲存評價
        if let rating = restaurantDetail.rating {
            headerView.ratingImageView.image = UIImage(named: rating)
        }
        
    }
    
}


   

   





 
