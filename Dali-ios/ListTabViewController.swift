//
//  ListTabViewController.swift
//  Dali-ios
//
//  Created by Or Milis on 25/07/2019.
//  Copyright © 2019 Or Milis. All rights reserved.
//

import UIKit

class ListTabViewController: UIViewController {

    var profileData: Artist?
    var profileType: ProfileType?
    @IBOutlet weak var artworkList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //self.artworkList.contentInset.bottom = self.tabBarController?.tabBar.frame.height ?? 0
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

extension ListTabViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let type = profileType else { return 0 }
        guard let data = profileData else { return 0 }
        switch type {
        case .ArtistProfile:
            return data.artworks.count
        case .UserProfile:
            return data.likedArtwork.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let type = profileType else { return UITableViewCell() }
        guard let data = profileData else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: GenericTableViewCell.identifier, for: indexPath) as! GenericTableViewCell
        
        var cellData: Artwork
        
        switch type {
        case .ArtistProfile:
            cellData = data.artworks[indexPath.row]
            cell.profilePicture.image = UIImage(named: "artworks_icon")
            let artworkGenere: String = cellData.generes.count > 0 ? cellData.generes[0] : ""
            cell.SubText.text = artworkGenere
        case .UserProfile:
            cellData = data.likedArtwork[indexPath.row]
            cell.profilePicture.image = UIImage(named: "liked_artwork")
            cell.SubText.text = cellData.artistName
        }
        
        
        cell.MainText.text = cellData.name
        
        cell.profilePicture.setRoundedImage()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
