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
    @IBOutlet weak var artworkList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //self.artworkList.contentInset.bottom = self.tabBarController?.tabBar.frame.height ?? 0
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

extension ListTabViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileData?.artworks.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellData = profileData?.artworks[indexPath.row] else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: GenericTableViewCell.identifier, for: indexPath) as! GenericTableViewCell
        
        cell.MainText.text = cellData.name
        
        if let profilePicUrl: String = self.profileData?.pictureUrl {
            cell.profilePicture.loadFromUrl(urlString: profilePicUrl)
            cell.profilePicture.setRoundedImage()
        }
        
        let artworkGenere: String = cellData.generes.count > 0 ? cellData.generes[0] : ""
        cell.SubText.text = artworkGenere
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
