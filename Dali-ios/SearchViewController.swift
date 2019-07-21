//
//  SearchViewController.swift
//  Dali-ios
//
//  Created by Or Milis on 21/07/2019.
//  Copyright © 2019 Or Milis. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var searchField: UITextField!
    
    var buffTimer: Timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    @IBAction func onTextChange(_ sender: UITextField) {
        self.buffTimer.invalidate()
        print("In")
        guard let text = searchField.text else { return }
        if(text == "") { return }
        self.buffTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: { _ in
            RestController.searchUsers(str: text, completion: { (res) in
                switch res {
                case .success(let genData):
                    genData.forEach({ (artist) in
                        print(artist.name)
                    })
                case .failure(let err):
                    print(err)
                }
            })
        })
    }
}
