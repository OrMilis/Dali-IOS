//
//  Models.swift
//  Dali-ios
//
//  Created by Or Milis on 17/07/2019.
//  Copyright © 2019 Or Milis. All rights reserved.
//

import UIKit
import MapKit

public class Artwork: Decodable {
    let id: Int
    let path: String
    let name: String
    let artistId: String
    let lat: Double
    let lng: Double
    let dt_created: String
    let generes: [String]
    let generesIds: [Int]
    let info: String
    let artistName: String
    let artistPicture: String?
    
    public func getLocationCoordinate() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: lat, longitude: lng)
    }
}

public class Artist: Decodable {
    let id: String
    let pictureUrl: String?
    let name: String
    let generes: [String]
    let bio: String?
    let likedArtwork: [Artwork]
    let following: [String]
    let recommendedGeneres: [String]
    let recommendedArtists: [String]
    let artworks: [Artwork]
    let followers: [String]
}


public enum ProfileType {
    case ArtistProfile, UserProfile
}
