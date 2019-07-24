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
    @IBOutlet weak var searchTableView: UITableView!
    
    var buffTimer: Timer = Timer()
    var searchDataList: [Artist] = [Artist]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchField.setPadding()
        searchField.setBottomBorder()
        
        searchTableView.rowHeight = UITableView.automaticDimension
        searchTableView.estimatedRowHeight = 600

        /*testImage.loadFromUrl(urlString: "https://twistedsifter.files.wordpress.com/2012/09/trippy-profile-pic-portrait-head-on-and-from-side-angle.jpg")
        testImage.setRoundedImage()*/
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
        if(text == "") {
            self.searchDataList = [Artist]()
            self.searchTableView.reloadData()
            return
        }
        RestController.searchUsers(str: text, completion: { (res) in
            switch res {
            case .success(let genData):
                genData.forEach({ (artist) in
                    print(artist.name)
                })
                
                DispatchQueue.main.async {
                    self.searchDataList = genData
                    self.searchTableView.reloadData()
                }
            case .failure(let err):
                print(err)
            }
        })
    }
    
    func openArtistProfile(artist: Artist) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
        guard let profileViewController = storyBoard.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController else { return }
        
        profileViewController.profileData = artist
        
        self.navigationController?.pushViewController(profileViewController, animated: true);
    }
}

extension SearchViewController: UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    //UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.searchField.resignFirstResponder()
        if(self.buffTimer.isValid) {
            self.buffTimer.invalidate()
            self.sendSearchText()
        }
        return true
    }
    
    //UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchDataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GenericTableViewCell.identifier, for: indexPath) as! GenericTableViewCell
        let cellData = searchDataList[indexPath.row]
        
        cell.MainText.text = cellData.name
        
        if let profilePicUrl: String = cellData.pictureUrl {
            cell.profilePicture.loadFromUrl(urlString: profilePicUrl)
            cell.profilePicture.setRoundedImage()
        }
        
        let userGenere: String = cellData.generes.count > 0 ? cellData.generes[0] : ""
        cell.SubText.text = userGenere
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.openArtistProfile(artist: self.searchDataList[indexPath.row])
    }
}

