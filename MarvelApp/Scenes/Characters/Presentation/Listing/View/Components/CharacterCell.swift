//
//  CharacterCell.swift
//  MarvelApp
//
//  Created by Emad Habib on 08/11/2024.
//

import UIKit
import CommonUI

class CharacterCell: UITableViewCell {
    
    @IBOutlet private weak var charImageView: UIImageView!
    @IBOutlet private weak var charNameLabel: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()
        charNameLabel.text = nil
        charImageView.image = nil
    }
    
    func configureCell(with character: CharacterModel) {
        DispatchQueue.main.async {
            self.charNameLabel.text = character.name
            self.charImageView.download(with: character.imageURL ?? "")
        }
    }
}
