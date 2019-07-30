//
//  ProfileViewController.swift
//  Dali-ios
//
//  Created by Or Milis on 24/07/2019.
//  Copyright © 2019 Or Milis. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    public static let identifier: String = "ProfileViewController"
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var artistMainGenere: UILabel!
    @IBOutlet weak var artistBio: UILabel!
    
    var profileData: Artist?
    var profileType: ProfileType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if profileData != nil {
            artistName.text = profileData!.name
            if let bio = profileData!.bio {
                artistBio.text = bio
            } else {
                artistBio.text = ""
            }
            
            if let pictureUrl = profileData?.pictureUrl {
                profilePicture.loadFromUrl(urlString: pictureUrl)
                profilePicture.setRoundedImage()
            }
            
            artistMainGenere.text = profileData!.generes.count > 0 ? profileData!.generes[0] : ""
        }

        // Do any additional setup after loading the view.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        guard let vc = segue.destination as? ProfileTabViewController, segue.identifier == "ProfileTabViewControllerSegue" else { return }
        vc.profileData = self.profileData
        vc.profileType = self.profileType
    }
    

}
