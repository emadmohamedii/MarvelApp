//
//  CharacterDetailComicsTCell.swift
//  MApp
//
//  Created by Emad Habib on 16/09/2023.
//
import UIKit
import Common


enum CharacterDetailCollectionCells: String {
    case CharacterDetailComicVCell
}

final class CharacterDetailComicsTCell: UITableViewCell {
    
    @IBOutlet private weak var categoryNameLabel: UILabel!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    private var collectionViewDataSource: CollectionViewCustomDataSource<CharacterMediaModel>?
    weak var delegate: CollectionViewCustomDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        categoryNameLabel.text = nil
    }
}

extension CharacterDetailComicsTCell {
    
    private func setupCollectionView() {
        categoryCollectionView.register(
            UINib(nibName: CharacterDetailCollectionCells.CharacterDetailComicVCell.rawValue, bundle: nil),
            forCellWithReuseIdentifier: CharacterDetailCollectionCells.CharacterDetailComicVCell.rawValue
        )
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100, height: 200)
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        categoryCollectionView.dataSource = collectionViewDataSource
        categoryCollectionView.setCollectionViewLayout(layout, animated: false)
        categoryCollectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    func setupParameters(itemlist: [CharacterMediaModel], type: MediaType) {
        if categoryCollectionView.dataSource == nil {
            // Create and assign the custom data source for the collection view
            collectionViewDataSource = CollectionViewCustomDataSource.displayData(for: itemlist, delegate: delegate)
            categoryCollectionView.dataSource = collectionViewDataSource
            categoryCollectionView.delegate = collectionViewDataSource
            DispatchQueue.main.async {
                self.categoryNameLabel.text = type.title
                self.categoryCollectionView.reloadData()
            }
        }
    }
}
