//
//  MapViewController.swift
//  FoodPin
//
//  Created by TANG,QI-RONG on 2020/5/25.
//  Copyright © 2020 Steven. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet var mapView: MKMapView!
    var MapRestaurant: RestaurantMO!
    
        // Status bar configuration
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // Do any additional setup after loading the view.
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(MapRestaurant.location ?? "", completionHandler: { placemarks, error in
            if let error = error {
                print(error)
                return
            }
            
            
            if let placemarks = placemarks {
                // Get the first placemark
                let placemark = placemarks[0]
                
                //add annotation
                let annotation = MKPointAnnotation()
                annotation.title = self.MapRestaurant.name
                annotation.subtitle = self.MapRestaurant.type
                
                if let location = placemark.location {
                    annotation.coordinate = location.coordinate
                   
                    // Display the annotation
                    self.mapView.showAnnotations([annotation], animated: true)
                    self.mapView.selectAnnotation(annotation, animated: true)
                }
            }
            
        })
   
        // Configure map view
        mapView.delegate = self
        mapView.showsScale = true
        mapView.showsTraffic = true
        
      //mapView.showsCompass = true (指北針系統似乎已有自己內建)
        
    
    }
 // MARK: - Map View Delegate methods
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let identifier = "MyMarker"
        if annotation.isKind(of: MKUserLocation.self){
            
            return nil
        }
        
        //如果可行，則在重複使用標記
        var annotationView: MKMarkerAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        
        annotationView?.glyphText = "🍜"
        annotationView?.markerTintColor = #colorLiteral(red: 1, green: 0.4934554561, blue: 0.5243053216, alpha: 1)
        
        return annotationView
    }
    
   
}
