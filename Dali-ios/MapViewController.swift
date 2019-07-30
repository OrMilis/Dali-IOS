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
    
    public static let navigationControllerIdentifier: String = "AppMainNavigationController"
    public static let identifier: String = "MapView"
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var ArViewBtn: UIButton!
    @IBOutlet weak var SearchViewBtn: UIButton!
    @IBOutlet weak var ProfileViewBtn: UIButton!
    
    let locationManager = CLLocationManager()
    
    var userProfile: Artist?
    var artworks: [Artwork] = [Artwork]()
    
    override func viewWillAppear(_ animated: Bool) {
        locationManager.requestWhenInUseAuthorization()
        getUserProfileData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        ArViewBtn.imageView?.setRoundedImage()
        ArViewBtn.setShadow(color: UIColor(red: 0, green: 0, blue: 0, alpha: 1.0).cgColor, offset: CGSize(width: 0.0, height: 3.0), opacity: 0.25, radius: 10.0)
        
        SearchViewBtn.imageView?.setRoundedImage()
        SearchViewBtn.setShadow(color: UIColor(red: 0, green: 0, blue: 0, alpha: 1.0).cgColor, offset: CGSize(width: 0.0, height: 3.0), opacity: 0.25, radius: 10.0)
        
        ProfileViewBtn.imageView?.setRoundedImage()
        ProfileViewBtn.setShadow(color: UIColor(red: 0, green: 0, blue: 0, alpha: 1.0).cgColor, offset: CGSize(width: 0.0, height: 3.0), opacity: 0.25, radius: 10.0)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
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
    
    func getUserProfileData() {
        RestController.getProfileById(id: RestController.userID, completion: { res in
            switch res {
            case .success(let profile):
                self.userProfile = profile
            case .failure(let err):
                print(err)
            }
        })
    }
    
    @IBAction func openARView(_ sender: Any) {
        guard let profile = userProfile else { return }
        if self.artworks.count > 0 {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            guard let arViewController = storyBoard.instantiateViewController(withIdentifier: ArViewController.identifier) as? ArViewController else { return }
            arViewController.setDataForView(artworks: self.artworks, likedArtworks: profile.likedArtwork)
            self.navigationController?.pushViewController(arViewController, animated: true)
        }
    }
    
    @IBAction func openSearchView(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let searchViewController = storyBoard.instantiateViewController(withIdentifier: SearchViewController.identifier) as? SearchViewController else { return }
        self.navigationController?.pushViewController(searchViewController, animated: true)
    }
    
    @IBAction func openUserProfile(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let profileViewController = storyBoard.instantiateViewController(withIdentifier: ProfileViewController.identifier) as? ProfileViewController else { return }
        guard let profile = userProfile else { return }
        profileViewController.profileData = profile
        profileViewController.profileType = .UserProfile
        self.navigationController?.pushViewController(profileViewController, animated: true)
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
        if userProfile == nil {
            getUserProfileData()
        }
        
        RestController.getArtworkByLocation(latitude: location.latitude, longitude: location.longitude, completion: { (res) in
            switch res {
            case .success(let genData):
                self.artworks = genData.filter({ $0.path.hasSuffix(".zip") })
                self.artworks.forEach({ artwork in
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
