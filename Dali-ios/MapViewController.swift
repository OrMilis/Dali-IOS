//
//  MapViewController.swift
//  Dali-ios
//
//  Created by Or Milis on 17/07/2019.
//  Copyright © 2019 Or Milis. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager();
    
    override func viewWillAppear(_ animated: Bool) {
        locationManager.requestWhenInUseAuthorization();
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.mapView.showsUserLocation = true
        self.mapView.setUserTrackingMode(MKUserTrackingMode.follow, animated: true)
        
        let trackButton = MKUserTrackingBarButtonItem.init(mapView: mapView)
        self.navigationItem.rightBarButtonItem = trackButton
        
        if(CLLocationManager.locationServicesEnabled()) {
            locationManager.delegate = self;
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation();
        } else {
            print("No service")
        }
        
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

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        let calendar = Calendar.current;
        print(calendar)
        print(location)
        
        RestController.getArtworkByLocation(latitude: location.latitude, longitude: location.longitude, completion: { (res) in
            switch res {
            case .success(let genData):
                genData.forEach({ (artwork) in
                    let annotation = MKPointAnnotation();
                    annotation.coordinate = artwork.getLocationCoordinate()
                    annotation.title = artwork.name
                    annotation.subtitle = "By: " + artwork.artistName
                    self.mapView.addAnnotation(annotation)
                })
            case .failure(let err):
                print(err)
            }
        })
    }
}
