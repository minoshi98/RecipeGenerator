//
//  getRestaurantMap.swift
//  classProject
//
//  Created by Minoshi K on 11/25/19.
//  Copyright © 2019 Minoshi K. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

class getRestaurantMap {
    
    
    func showArea(area:String, mapView:MKMapView) {
        let geoCoder = CLGeocoder()
        
        
       
        CLGeocoder().geocodeAddressString(area, completionHandler:
            {
                (placemarks, error) in
                
                if error != nil
                {
                    print("Geocode failed: \(error!.localizedDescription)")
                }
                else if placemarks!.count > 0
                {
                    
                    
                    let placemark = placemarks![0]
                    let location = placemark.location
                    let coords = location!.coordinate
                    
                    let span = MKCoordinateSpan.init(latitudeDelta: 0.05, longitudeDelta: 0.05)
                    let region = MKCoordinateRegion(center: placemark.location!.coordinate, span: span)
                    mapView.setRegion(region, animated: true)
                    let ani = MKPointAnnotation()
                    ani.coordinate = placemark.location!.coordinate
                    ani.title = placemark.locality
                    ani.subtitle = placemark.subLocality
                    
                    mapView.addAnnotation(ani)
                    
                    
                    
                } //end of else if
        } )//end of addressString
        
        
        }
        
        
        
    
    
    
    
    
    
    
    
}
