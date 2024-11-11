//
//  CharacterDetailComicVCell.swift
//  MApp
//
//  Created by Emad Habib on 16/09/2023.
//

import UIKit

class CharacterDetailComicVCell: UICollectionViewCell {

    @IBOutlet weak var comicImgV:UIImageView!
    @IBOutlet weak var comicNameLbl:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(comic:ComicModel) {
        self.comicNameLbl.text = comic.name
        self.comicImgV.download(with: comic.image,placeholderImage: UIImage(named: "test"))
    }
}
