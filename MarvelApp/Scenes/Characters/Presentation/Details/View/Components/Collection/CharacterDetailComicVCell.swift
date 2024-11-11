//
//  CharacterDetailComicVCell.swift
//  MApp
//
//  Created by Emad Habib on 16/09/2023.
//

import UIKit

final class CharacterDetailComicVCell: UICollectionViewCell {

    @IBOutlet private weak var comicImageView: UIImageView!
    @IBOutlet private weak var comicNameLabel: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()
        comicNameLabel.text = nil
        comicImageView.image = nil
    }
    
    func configureCell(media:CharacterMediaModel) {
        DispatchQueue.main.async {
            self.comicNameLabel.text = media.name
            self.comicImageView.download(with: media.imageURL ?? "")
        }
    }
}
