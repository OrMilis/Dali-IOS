//
//  LoginViewController.swift
//  Dali-ios
//
//  Created by Or Milis on 29/07/2019.
//  Copyright © 2019 Or Milis. All rights reserved.
//

import UIKit
import GoogleSignIn

class SignInViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {
    
    @IBOutlet weak var backgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layer = CAGradientLayer()
        layer.frame = view.bounds
        layer.colors = [UIColor(rgb: 0x12C2E9).cgColor, UIColor(rgb: 0xC471ED).cgColor, UIColor(rgb: 0xF64F59).cgColor]
        /*layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 1, y: 1)*/
        backgroundView.layer.addSublayer(layer)
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().clientID = "968539886024-2tt19rq70iqufk4f8dfst8l0sstg8u5n.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().signInSilently()
        // Do any additional setup after loading the view.
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            // Perform any operations on signed in user here.
            guard let userId = user.userID else { return }
            guard let name = user.profile.name else { return }
            let picture = user.profile.imageURL(withDimension: 100)?.absoluteString ?? ""
            
            RestController.userID = userId
            RestController.signInApp(id: userId, name: name, pictureUrl: picture, completion: { (res: Result<Bool, Error>) in
                switch res {
                case .success(let genData):
                    if genData {
                        print("Login successful")
                    } else {
                        print("Login Failed")
                    }
                case .failure(let err):
                    print(err)
                }
            })
            self.openMapView()
        }
    }
    
    func openMapView() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let mainAppNavigationController = storyBoard.instantiateViewController(withIdentifier: MapViewController.navigationControllerIdentifier) as? UINavigationController else { return }
        self.present(mainAppNavigationController, animated: true)
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
