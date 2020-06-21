//
//  DetailMapCell.swift
//  FoodPin
//
//  Created by TANG,QI-RONG on 2020/5/25.
//  Copyright © 2020 Steven. All rights reserved.
//

import UIKit
import MapKit

class DetailMapCell: UITableViewCell {

    @IBOutlet var mapView: MKMapView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func  configure(location: String) {
        //取得位置(CLGeocoder)
        let geoCoder = CLGeocoder()
        
        print(location)
        geoCoder.geocodeAddressString(location, completionHandler: { placemarks, error in
            if let error = error{
                print(error.localizedDescription)
                return
            }
            
            if let placemarks = placemarks{
               
                //取得第一個(陣列0)地點標記
                let placemark = placemarks[0]
                //加上標記
                let annotation = MKPointAnnotation()
                
                if let location = placemark.location {
                    //顯示標記
                    annotation.coordinate = location.coordinate
                    self.mapView.addAnnotation(annotation)
                    
                    //設定縮放程度
                    let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 250, longitudinalMeters: 250)
                    
                    self.mapView.setRegion(region, animated: false)
                }
                
            }
        })
    }

}
