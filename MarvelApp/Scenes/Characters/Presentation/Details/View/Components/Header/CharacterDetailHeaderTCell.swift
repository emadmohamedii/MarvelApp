//
//  CharacterDetailHeaderTCell.swift
//  MApp
//
//  Created by Emad Habib on 16/09/2023.
//

import UIKit

enum CharacterDetailTableCells :String{
    case CharacterDetailHeaderTCell
    case CharacterDetailComicsTCell
}

final class CharacterDetailHeaderTCell: UITableViewCell {
    
    @IBOutlet private weak var charImageView: UIImageView!
    @IBOutlet private weak var charNameLabel: UILabel!
    @IBOutlet private weak var charDescLabel: UILabel!
    @IBOutlet private weak var charDescStackView: UIStackView!

    override func prepareForReuse() {
        super.prepareForReuse()
        charNameLabel.text = nil
        charDescLabel.text = nil
        charImageView.image = nil
    }
        
    func configure(image:String?,name:String?,desc:String?){
        DispatchQueue.main.async {
            self.charNameLabel.text = name
            if let desc = desc , !desc.isEmpty {
                self.charDescLabel.text = desc
                self.charDescStackView.isHidden = false
            }
            else {
                self.charDescStackView.isHidden = true
            }
            self.charImageView.download(with: image ?? "")
        }
    }
}
