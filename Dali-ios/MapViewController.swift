//
//  MapViewController.swift
//  Dali-ios
//
//  Created by Or Milis on 17/07/2019.
//  Copyright © 2019 Or Milis. All rights reserved.
//

import UIKit
import MapKit
import ZIPFoundation

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    var artworks: [Artwork] = [Artwork]()
    
    override func viewWillAppear(_ animated: Bool) {
        locationManager.requestWhenInUseAuthorization();
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        clearTempArtFiles()
        
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
    
    @IBAction func onBtnClick(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let searchViewController = storyBoard.instantiateViewController(withIdentifier: "SearchView") as? SearchViewController else { return }
        
        self.navigationController?.pushViewController(searchViewController, animated: true)
        
        /*if artworks.count > 0 {
            artworks.forEach({ artwork in
                getArtworkFiles(artwork: artwork)
            })
        }*/
    }
    
    func getArtworkFiles(artwork: Artwork) {
        guard let url = URL(string: "http://" + artwork.path) else { return }
        
        let task = URLSession.shared.downloadTask(with: url) { localURL, urlResponse, error in
            if let fileUrl = localURL {
                let tempArtworksPath = FileManager.default.temporaryDirectory.appendingPathComponent("tempArtworks") // FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                let destinationDirectoryURL = tempArtworksPath.appendingPathComponent(artwork.name)
                let destinationFileUrl = destinationDirectoryURL.appendingPathComponent(urlResponse?.suggestedFilename ?? fileUrl.lastPathComponent)
                
                try? FileManager.default.removeItem(at: destinationDirectoryURL)
                
                do {
                    try FileManager.default.createDirectory(at: destinationDirectoryURL, withIntermediateDirectories: true, attributes: nil)
                    try FileManager.default.copyItem(at: fileUrl, to: destinationFileUrl)
                    try FileManager.default.unzipItem(at: destinationFileUrl, to: destinationDirectoryURL)
                } catch let error {
                    print(error)
                }
            }
        }
        
        task.resume()
    }
    
    func clearTempArtFiles() {
        let tempArtworksPath = FileManager.default.temporaryDirectory.appendingPathComponent("tempArtworks")
        do {
            let filesUrl = try FileManager.default.contentsOfDirectory(at: tempArtworksPath, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            filesUrl.forEach({ url in
                try? FileManager.default.removeItem(at: url)
            })
        } catch let err {
            print(err)
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
        
        RestController.getArtworkByLocation(latitude: location.latitude, longitude: location.longitude, completion: { (res) in
            switch res {
            case .success(let genData):
                self.artworks = genData
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
