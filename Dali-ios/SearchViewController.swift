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
        searchField.setPadding()
        searchField.setBottomBorder()

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
        self.buffTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: { _ in
            self.sendSearchText()
        })
    }
    
    func sendSearchText() {
        print("In")
        guard let text = searchField.text else { return }
        if(text == "") { return }
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
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.searchField.resignFirstResponder()
        self.buffTimer.invalidate()
        self.sendSearchText()
        return true
    }
}

extension UITextField {
    func setPadding() {
        let paddingView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setBottomBorder() {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect.init(x: 0, y: self.frame.size.height - 1, width: self.frame.size.width, height: 1)
        bottomLine.backgroundColor = UIColor.darkGray.cgColor
        self.borderStyle = UITextField.BorderStyle.none
        self.layer.addSublayer(bottomLine)
    }
}
