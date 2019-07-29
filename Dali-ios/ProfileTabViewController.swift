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
        
        self.delegate = self
        
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

extension ProfileTabViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        print("Switch!")
        guard let fromView = selectedViewController?.view, let toView = viewController.view else {
            return false // Make sure you want this as false
        }
        
        if fromView != toView {
            UIView.transition(from: fromView, to: toView, duration: 0.3, options: [.transitionCrossDissolve], completion: nil)
        }
        
        return true
    }
}
