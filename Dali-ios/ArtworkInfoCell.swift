//
//  ArtworkInfoCellCollectionViewCell.swift
//  Dali-ios
//
//  Created by Or Milis on 27/07/2019.
//  Copyright © 2019 Or Milis. All rights reserved.
//

import UIKit

class ArtworkInfoCell: UICollectionViewCell {
    @IBOutlet weak var artworkName: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var artistPicture: UIImageView!
    @IBOutlet weak var likeBtn: UIButton!
    
    var artworkId: Int?
    var isLiked: Bool?
    
    @IBAction func onLikeClick(_ sender: UIButton) {
        guard let id = artworkId else { return }
        guard let liked = isLiked else { return }
        
        if liked { //Btn is unlike
            RestController.unlikeArtwork(artworkId: id, completion: { (res: Result<Bool, Error>) in
                self.isLiked = false
                DispatchQueue.main.async {
                    self.likeBtn.tintColor = UIColor.white
                }
            })
        } else { //Btn is like
            RestController.likeArtwork(artworkId: id, completion: { (res: Result<Bool, Error>) in
                self.isLiked = true
                DispatchQueue.main.async {
                    self.likeBtn.tintColor = UIColor.red
                }
            })
        }
    }
}
