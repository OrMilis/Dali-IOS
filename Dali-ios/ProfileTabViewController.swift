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
    var profileType: ProfileType?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        guard let data = profileData else { return }
        guard let type = profileType else { return }
        
        print("TYPE!!", type)
        
        self.viewControllers?.forEach({ view in
            if let subView = view as? ListTabViewController {
                subView.setProfileData(artist: data, type: type)
                switch type {
                case .ArtistProfile:
                    subView.tabBarItem.image = UIImage(named: "artworks_bar_icon")
                    subView.tabBarItem.title = "Artworks"
                case .UserProfile:
                    subView.tabBarItem.image = UIImage(named: "like_icon")
                    subView.tabBarItem.title = "Liked"
                }
            } else if let subView = view as? MapTabViewController {
                subView.tabBarItem.image = UIImage(named: "hollow_marker_icon")
                subView.setProfileData(artist: data, type: type)
            }
        })
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

extension ProfileTabViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let fromView = selectedViewController?.view, let toView = viewController.view else {
            return false // Make sure you want this as false
        }
        
        if fromView != toView {
            UIView.transition(from: fromView, to: toView, duration: 0.3, options: [.transitionCrossDissolve], completion: nil)
        }
        
        return true
    }
}
