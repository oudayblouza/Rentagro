//
//  MapAfterDetailViewController.swift
//  RentAGRO
//
//  Created by Blouza Ouday on 18/12/2017.
//  Copyright © 2017 Blouza Ouday. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps

class MapAfterDetailViewController: UIViewController {
    
    var annonces = Annonces()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let camera = GMSCameraPosition.camera(withLatitude: annonces.latitude!, longitude: annonces.longitude!, zoom: 6.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.isMyLocationEnabled = true
        view = mapView
        
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: annonces.latitude!, longitude: annonces.longitude!)
        
        
        let location = CLLocation(latitude: annonces.latitude!, longitude: annonces.longitude!)
        
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
            //        // Place details
            var placeMark: CLPlacemark?
            placeMark = placemarks?[0]
            
            let locationName = placeMark?.locality ?? "Could not find city"
            
            marker.title = locationName
            
            // Country
            guard let country = placeMark?.addressDictionary?["Country"] as? String else {
                marker.snippet = "could not find country"
                return
            }
            
            marker.snippet = country
            
        })
        
        marker.map = mapView
        
      
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
