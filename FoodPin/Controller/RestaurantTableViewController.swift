//
//  RestaurantTableTableViewController.swift
//  FoodPin
//
//  Created by TANG,QI-RONG on 2020/4/26.
//  Copyright © 2020 Steven. All rights reserved.
//

import UIKit
import CoreData

class RestaurantTableTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, UISearchResultsUpdating{
    
    var fetchResultController: NSFetchedResultsController<RestaurantMO>!
    var restaurants:[RestaurantMO] = []
    
    var searchController: UISearchController!
    var searchResults: [RestaurantMO] = []
    
    @IBOutlet var emptyRestaurantView: UIView!
    
    override func viewDidLayoutSubviews() {
        searchController.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "我要找餐廳！", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(1.0) ])
    }
 
    override func viewDidDisappear(_ animated: Bool) {
        /*searchController.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "我要找餐廳！", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(1.0) ])*/
        
            //還是會有些問題
    }
    
    // MARK: - View controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
    // 顯示導覽畫面
        if UserDefaults.standard.bool(forKey: "hasViewe０dWalkthrough") {
             return
         }
         
         let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
         if let startReadingViewController = storyboard.instantiateViewController(withIdentifier: "startReadingViewController") as? startReadingViewController {
             
             present(startReadingViewController, animated: true, completion: nil)
         }
       
        
        // Prepare the empty view
        tableView.backgroundView = emptyRestaurantView
        tableView.backgroundView?.isHidden = true
        
       // (for iPad) 讓 cell 符合適當比例
        tableView.cellLayoutMarginsFollowReadableWidth = true
       
        //ios13 大標題
        navigationController?.navigationBar.prefersLargeTitles = true
        
        //Chapter 15 - 自訂導覽列
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .compact)
        navigationController?.hidesBarsOnSwipe = true
        
        navigationController?.navigationBar.shadowImage = UIImage() //差一條線
        if let custFont = UIFont(name: "Snell Roundhand", size: 40.0){
            navigationController?.navigationBar.largeTitleTextAttributes = [
                NSAttributedString.Key.foregroundColor: UIColor(red: 252.0/255.0, green: 135.0/255.0, blue: 145.0/255.0, alpha: 1.0), NSAttributedString.Key.font: custFont
            ]
            
            
        }
        
//MARK: - Fetch data from data store

        let fetchRequest: NSFetchRequest<RestaurantMO> =
        RestaurantMO.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            
            do{
                try fetchResultController.performFetch()
                if let fetchedObjects = fetchResultController.fetchedObjects{
                    restaurants = fetchedObjects
                }
            }catch{
                print(error)
            }
        }
    
        //MARK: - Search controller
        // obscuresBackgroundDuringPresentation 的預設是 true
        //self.navigationItem.searchController = searchController
        
        
        searchController = UISearchController(searchResultsController: nil)
     
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.tintColor = #colorLiteral(red: 1, green: 0.7030856715, blue: 0.6947818178, alpha: 1)
        
        
        searchController.searchBar.searchTextField.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        searchController.searchBar.searchBarStyle = .prominent
        searchController.searchBar.barTintColor = #colorLiteral(red: 1, green: 0.8693864156, blue: 0.899294329, alpha: 1)
        
       // searchController.searchBar.backgroundImage = UIImage()
        
        
        tableView.tableHeaderView = searchController.searchBar
        
        
    }
    
    // MARK: - 更新 NSFetchedResultsController Data (Need practice)
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath {
                tableView.reloadRows(at: [indexPath], with: .fade)
            }
        default:
            tableView.reloadData()
        }
        
        if let fetchedObjects = controller.fetchedObjects {
            restaurants = fetchedObjects as! [RestaurantMO]
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
 //MARK: - viewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.hidesBarsOnSwipe = true

    }

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        if restaurants.count > 0 {
            tableView.backgroundView?.isHidden = true
            tableView.separatorStyle = .singleLine
        }else {
            tableView.backgroundView?.isHidden = false
            tableView.separatorStyle = .none
        }
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //用來判定出現的是收尋列還是導覽列
        if searchController.isActive{
            return searchResults.count
        }else{
            return restaurants.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "datacell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! RestaurantTableViewCell

        let restaurantSearch = (searchController.isActive) ?
            searchResults[indexPath.row] : restaurants[indexPath.row]
        
        // Configure the cell...
        cell.nameLabel.text = restaurantSearch.name
        cell.locationLabel.text = restaurantSearch.location
        cell.typeLabel.text = restaurantSearch.type
        if let restaurantImage = restaurantSearch.image {
            cell.thumbnailImageView.image = UIImage(data: restaurantImage as Data)
        }
      
        cell.accessoryType = restaurants[indexPath.row].isVisited ? .checkmark: .none
        
        return cell
    }
    

     //MARK: - 往左滑動打卡動作
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: NSLocalizedString("Delete", comment: "Delete")) { (action, sourceView, completionHandler) in
            
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            let restaurantToDelete = self.fetchResultController.object(at: indexPath)
            context.delete(restaurantToDelete)
            
            appDelegate.saveContext()            
            }
            
            // Call completion handler with true to indicate
            completionHandler(true)
        }
        
        let shareAction = UIContextualAction(style: .normal, title: NSLocalizedString("Share", comment: "Share")){
            (action, sourceView, completionHandler) in
            
            let defaultText = NSLocalizedString ("Just checking in at ", comment: "Just checking in at ") + self.restaurants[indexPath.row].name!
            let activityController: UIActivityViewController
            
            if let restaurantImage = self.restaurants[indexPath.row].image,
                let imageToShare = UIImage(data: restaurantImage as Data) {
            
                activityController = UIActivityViewController(activityItems: [defaultText, imageToShare], applicationActivities: nil)
            }else {
                activityController = UIActivityViewController(activityItems: [defaultText], applicationActivities: nil)
            }
            
            // For iPad
            if let popoverController = activityController.popoverPresentationController {
                if let cell = tableView.cellForRow(at: indexPath) {
                    popoverController.sourceView = cell
                    popoverController.sourceRect = cell.bounds
                }
            }
            self.present(activityController, animated: true, completion: nil)
            
            completionHandler(true)
        }
       
        // Customize the color
        deleteAction.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        deleteAction.image = UIImage(systemName: "trash")

        shareAction.backgroundColor = UIColor(red: 240.0/255.0, green: 175.0/255.0, blue: 135.0/255.0, alpha: 1.0)
        shareAction.image = UIImage(systemName: "square.and.arrow.up")
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
        
        return swipeConfiguration
        
    }
    
    //MARK: - 往右滑動打卡動作
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?{
        
        let rightCheckIn = UIContextualAction(style: .normal, title: NSLocalizedString("登記", comment: "Check-in")) {(action, sourceView, completionHandler) in
            
            let cell = tableView.cellForRow(at: indexPath) as! RestaurantTableViewCell
            self.restaurants[indexPath.row].isVisited = self.restaurants[indexPath.row].isVisited ? false : true
            cell.accessoryType = self.restaurants[indexPath.row].isVisited ? .checkmark : .none
            
            completionHandler(false)
        }
        let checkInIcon = restaurants[indexPath.row].isVisited ? "arrow.uturn.left" : "checkmark"
        
        // Customize the color
        rightCheckIn.backgroundColor = UIColor(red: 195, green: 221, blue: 112)
        rightCheckIn.image = UIImage(systemName: checkInIcon)
           
        
       let swipeConfiguration = UISwipeActionsConfiguration(actions: [rightCheckIn])
        
        return swipeConfiguration
    }
 
    //取消搜尋清單中的左右滑動選項
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if searchController.isActive {
            return false
        }else{
            return true
        }
    }
    
    
// MARK: - Navigation (主頁面到餐廳詳細資料)
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
        if segue.identifier == "showRestaurantDetail"{
            if let indexPath = tableView.indexPathForSelectedRow{
                
                // segue.destination 是用來取得目標控制器
                let destinationController =
                    segue.destination as! DetailViewController
               
                destinationController.restaurantDetail = (searchController.isActive) ? searchResults[indexPath.row] : restaurants[indexPath.row]
                
                
            }
        }
    }
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Search bar
    
    func filterContent (for searchText: String) {
        
        searchResults = restaurants.filter({ (restaurants) -> Bool in
            if let name = restaurants.name,
                let location = restaurants.location {
                
                let isMatch = name.localizedCaseInsensitiveContains(searchText) || location.localizedCaseInsensitiveContains(searchText)
                
                return isMatch
            }
            
            return false
        })
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterContent(for: searchText)
            tableView.reloadData()
        }
    }

}
