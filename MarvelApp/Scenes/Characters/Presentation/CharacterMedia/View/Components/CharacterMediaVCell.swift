//
//  CharacterMediaVCell.swift
//  MarvelApp
//
//  Created by Emad Habib on 11/11/2024.
//

import UIKit

final class CharacterMediaVCell: UICollectionViewCell {

    @IBOutlet private weak var mediaTitleLabel: UILabel!
    @IBOutlet private weak var mediaImageView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        mediaTitleLabel.text = nil
        mediaImageView.image = nil
    }
    
    func configure(media: CharacterMediaModel) {
        mediaTitleLabel.text = media.name
        mediaImageView.download(with: media.imageURL ?? "")
    }
}
