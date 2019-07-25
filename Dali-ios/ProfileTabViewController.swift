//
//  ProfileTabViewController.swift
//  Dali-ios
//
//  Created by Or Milis on 25/07/2019.
//  Copyright © 2019 Or Milis. All rights reserved.
//

import UIKit

class ProfileTabViewController: UITabBarController {
    
    var profileData: Artist?

    override func viewDidLoad() {
        super.viewDidLoad()
        if profileData != nil {
            self.viewControllers?.forEach({ view in
                if let subView = view as? ListTabViewController {
                    subView.setProfileData(artist: profileData!)
                } else if let subView = view as? MapTabViewController {
                    subView.setProfileData(artist: profileData!)
                }
            })
        }
        // Do any additional setup after loading the view.
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
