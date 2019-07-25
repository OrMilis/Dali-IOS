//
//  MapTabViewController.swift
//  Dali-ios
//
//  Created by Or Milis on 25/07/2019.
//  Copyright © 2019 Or Milis. All rights reserved.
//

import UIKit
import MapKit

class MapTabViewController: UIViewController {

    var profileData: Artist?
    @IBOutlet weak var artworkMap: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard profileData != nil else { return }
        profileData?.artworks.forEach({ artwork in
            let annotation = MKPointAnnotation();
            annotation.coordinate = artwork.getLocationCoordinate()
            annotation.title = artwork.name
            annotation.subtitle = artwork.generes.count > 0 ? artwork.generes[0] : ""
            self.artworkMap.addAnnotation(annotation)
        })
        // Do any additional setup after loading the view.
    }
    
    func setProfileData(artist: Artist) {
        self.profileData = artist
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
