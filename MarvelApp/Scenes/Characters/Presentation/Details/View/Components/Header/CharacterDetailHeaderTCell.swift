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

class CharacterDetailHeaderTCell: UITableViewCell {
    
    @IBOutlet weak var charImgV:UIImageView!
    @IBOutlet weak var charNameLbl:UILabel!
    @IBOutlet weak var charDescLbl:UILabel!
    @IBOutlet weak var charDescStack:UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configure(image:String?,name:String?,desc:String?){
        self.charNameLbl.text = name
        if let desc = desc , !desc.isEmpty {
            self.charDescLbl.text = desc
            self.charDescStack.isHidden = false
        }
        else {
            self.charDescStack.isHidden = true
        }
        self.charImgV.downloadImageWithCaching(with: image ?? "",placeholderImage: UIImage(named: "test"))
    }
    
}
