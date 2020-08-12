//
//  restaurantViewController.swift
//  classProject
//
//  Created by Minoshi K on 11/24/19.
//  Copyright © 2019 Minoshi K. All rights reserved.
//

import UIKit
import CoreFoundation
import MapKit


class restaurantViewController: UIViewController {
    @IBOutlet var areaText: UITextField?
    
    
    @IBOutlet var restaurantMapView: MKMapView!
   
    @IBOutlet var submit: UIButton!
    
    @IBOutlet var itemField: UITextField!
    var textName:String = ""
    var r:recipes!
   
   
    
    override func viewDidLoad() {
      itemField.text = textName
      
      
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
   
   
    
    @IBAction func submitAction(_ sender: Any) {
     
        
        
        let addressString = areaText!.text!
        CLGeocoder().geocodeAddressString(addressString, completionHandler:
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
                    self.restaurantMapView.setRegion(region, animated: true)
                    let ani = MKPointAnnotation()
                    ani.coordinate = placemark.location!.coordinate
                    ani.title = placemark.locality
                    ani.subtitle = placemark.subLocality
                    
                    self.restaurantMapView.addAnnotation(ani)
                    
                    
                    
                } //end of else if
        } )//end of addressString
        
 
        
     
        
      
        
        
        
        
        
        
        
        
    }
    
    @IBAction func restaurantAction(_ sender: Any) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = self.itemField.text
        
        request.region = restaurantMapView!.region
        let search = MKLocalSearch(request: request)
        
        search.start { response, _ in
            guard let response = response else {
                return
            }
            print( response.mapItems )
            var matchingItems:[MKMapItem] = []
            matchingItems = response.mapItems
            for i in 1...matchingItems.count - 1
            {
                let place = matchingItems[i].placemark
                print(place.location?.coordinate.latitude)
                print(place.location?.coordinate.longitude)
                print(place.name)
                
                
                
                let location = place.location
                let coords = location!.coordinate
                
                let span = MKCoordinateSpan.init(latitudeDelta: 0.05, longitudeDelta: 0.05)
                let region = MKCoordinateRegion(center: place.location!.coordinate, span: span)
                
                let ani = MKPointAnnotation()
                ani.coordinate = place.location!.coordinate
                ani.title = place.name
                ani.subtitle = place.subLocality
                
                
                self.restaurantMapView!.addAnnotation(ani)
                
                
            }
            
        }
        
        
        
        
    }
 
       
    
    
    
   
}
    

