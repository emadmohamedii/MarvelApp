//
//  CharacterDetailComicsTCell.swift
//  MApp
//
//  Created by Emad Habib on 16/09/2023.
//

import UIKit
import RxSwift

enum CharacterDetailCollectionCells :String{
    case CharacterDetailComicVCell
}

class CharacterDetailComicsTCell: UITableViewCell {

    @IBOutlet weak var categoryNameLbl:UILabel!
    @IBOutlet weak var categoryCollectionView:UICollectionView!
    
    private var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupCollectionView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension CharacterDetailComicsTCell {
    private func setupCollectionView(){
        self.categoryCollectionView.register(UINib(nibName: CharacterDetailCollectionCells.CharacterDetailComicVCell.rawValue, bundle: nil), forCellWithReuseIdentifier: CharacterDetailCollectionCells.CharacterDetailComicVCell.rawValue)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100, height: 200)
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        self.categoryCollectionView.setCollectionViewLayout(layout, animated: false)
        self.categoryCollectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    func config(viewModel: CharacterDetailComicsViewModel) {
        self.categoryNameLbl.text = "Comics" // JUST DEFAULT FOR TESTING
        viewModel.items.drive(categoryCollectionView.rx.items) { collectionView, index, element in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CharacterDetailComicVCell", for: IndexPath(row: index, section: 0)) as! CharacterDetailComicVCell
            cell.configureCell(comic: element)
            return cell
        }.disposed(by: disposeBag)
        viewModel.fetchData()
    }
}
