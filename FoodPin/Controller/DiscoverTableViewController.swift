//
//  DiscoverTableViewController.swift
//  FoodPin
//
//  Created by TANG,QI-RONG on 2020/6/24.
//  Copyright © 2020 Steven. All rights reserved.
//

import UIKit
import CloudKit

class DiscoverTableViewController: UITableViewController {

    var DiscoverRestaurant: [CKRecord] = []
    var spinner = UIActivityIndicatorView()
    
    private var imageCache = NSCache<CKRecord.ID, NSURL>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        spinner.style = .medium
        spinner.hidesWhenStopped = true
        view.addSubview(spinner)
        
        //定義旋轉指示器的佈局條件
        spinner.translatesAutoresizingMaskIntoConstraints = false
        
       //self.spinner.center = self.view.center
        
        let horizontalConstraint = NSLayoutConstraint(item: spinner,attribute:.centerX,
        relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1,
        constant: 0)
        
        let verticalConstraint = NSLayoutConstraint(item: spinner, attribute: .centerY,
        relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1,
        constant: -120)
        
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint])
        
        //啟用 UIActivityIndicatorView
        spinner.startAnimating()
        
        tableView.cellLayoutMarginsFollowReadableWidth = true
        navigationController?.navigationBar.prefersLargeTitles = true
        
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        if let customFont = UIFont(name: "Snell Roundhand", size: 40.0) {
            navigationController?.navigationBar.largeTitleTextAttributes = [
                NSAttributedString.Key.foregroundColor: UIColor(red: 252, green: 102, blue: 115),
                NSAttributedString.Key.font: customFont
            ]
        }
        fetchRecordsFromCloud()
        
        // Pull To Refresh Control
        refreshControl = UIRefreshControl()
        refreshControl?.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        refreshControl?.tintColor = #colorLiteral(red: 1, green: 0.7030856715, blue: 0.6947818178, alpha: 1)
        refreshControl?.addTarget(self, action: #selector(fetchRecordsFromCloud), for: UIControl.Event.valueChanged)
        
    }

    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return DiscoverRestaurant.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DiscoverCell", for: indexPath)

        //設定Cell
        
        let restaurant = DiscoverRestaurant[indexPath.row]
        cell.textLabel?.text = restaurant.object(forKey: "name") as? String
        
        //設定預設圖片
        cell.imageView?.image = UIImage(named: "photo")
        
        //檢查圖片資料是否儲已經在快取中
        if let  imagefileURL = imageCache.object(forKey: restaurant.recordID) {
            //從快取取出資料
            print("從快取取出資料")
            if let imageData = try? Data.init(contentsOf: imagefileURL as URL) {
                cell.imageView?.image = UIImage(data: imageData)
            }
        }
        
        //在背景中取得雲端上的圖片
        let publicDatabase = CKContainer(identifier: "iCloud.com.Steven-QI.FoodPin").publicCloudDatabase
        let fetchRecordsImageOperation = CKFetchRecordsOperation(recordIDs: [restaurant.recordID])
        
        fetchRecordsImageOperation.desiredKeys = ["image"]
        fetchRecordsImageOperation.queuePriority = .veryHigh
        fetchRecordsImageOperation.perRecordCompletionBlock = { (record, recordID, error) -> Void in
            
            if let error = error {
                print("於iCloud取得資料失敗 - \(error.localizedDescription)")
                return
            }
            
            if let restaurantRecord = record,
                let image = restaurantRecord.object(forKey: "image"),
                let imageAsset = image as? CKAsset {
               
                print("成功2")

                
                if let imageData = try? Data.init(contentsOf: imageAsset.fileURL!) {
                    
                    //將佔位符改成實際圖片
                    DispatchQueue.main.async {
                        print("成功3")
                        cell.imageView?.image = UIImage(data: imageData)
                        cell.setNeedsLayout()
                        
                    }
                    //加入圖片URL至快取
                    self.imageCache.setObject(imageAsset.fileURL! as NSURL, forKey: restaurant.recordID)
                    
                }
            }
            
            
        }
        
        publicDatabase.add(fetchRecordsImageOperation)
        
        return cell
    }

    // MARK: - iCloud methods

    @objc func fetchRecordsFromCloud() {

        DiscoverRestaurant.removeAll()
        tableView.reloadData()
        
        //使用便利型API取得資料
        let cloudContainr = CKContainer(identifier: "iCloud.com.Steven-QI.FoodPin")
        let publicDatabase = cloudContainr.publicCloudDatabase
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Restaurant", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        // 用Query建立查詢操作
        let queryOperation = CKQueryOperation(query: query)
        queryOperation.desiredKeys = ["name","type"]
        queryOperation.queuePriority = .veryHigh
        queryOperation.resultsLimit = 50
        queryOperation.recordFetchedBlock = { (recodee) -> Void in
            //將每筆回傳資料夾加入到 DiscoverRestaurant
            self.DiscoverRestaurant.append(recodee)
        }
        queryOperation.queryCompletionBlock = { [unowned self] (cursor, error)
            -> Void in
            
            if let error = error {
                print("於iCloud取得資料失敗 - \(error.localizedDescription)")
                return
            }
            print("於iCloud取得資料成功")
            DispatchQueue.main.async {
                print("成功4")
                self.spinner.stopAnimating()
                self.tableView.reloadData()
                
                if let refreshControl = self.refreshControl {
                    if refreshControl.isRefreshing {
                        refreshControl.endRefreshing()
                    }
                }
            }
        }
        //執行查詢
        publicDatabase.add(queryOperation)
        
        
    }
    
     // MARK: - Table view data source
    
 
    
    
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
