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
    var profileType: ProfileType?
    @IBOutlet weak var artworkMap: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let data = profileData else { return }
        guard let type = profileType else { return }
        
        let artworks = type == .ArtistProfile ? data.artworks : data.likedArtwork
        
        artworks.forEach({ artwork in
            let annotation = MKPointAnnotation();
            annotation.coordinate = artwork.getLocationCoordinate()
            annotation.title = artwork.name
            annotation.subtitle = artwork.generes.count > 0 ? artwork.generes[0] : ""
            self.artworkMap.addAnnotation(annotation)
        })
        // Do any additional setup after loading the view.
    }
    
    func setProfileData(artist: Artist, type: ProfileType) {
        self.profileData = artist
        self.profileType = type
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
