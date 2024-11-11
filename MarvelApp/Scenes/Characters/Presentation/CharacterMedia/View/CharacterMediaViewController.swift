//
//  CharacterMediaViewController.swift
//  MarvelApp
//
//  Created by Emad Habib on 11/11/2024.
//

import UIKit
import CommonUI

enum CharacterMediaCollectionCells: String{
    case CharacterMediaVCell
}

final class CharacterMediaViewController: UIViewController {
    
    @IBOutlet private weak var mediaCollectionView: UICollectionView!
    @IBOutlet private weak var pagerLabel: UILabel!
    
    private var media: [CharacterMediaModel] = []
    
    init(media: [CharacterMediaModel]) {
        self.media = media
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        configureCollectionLayout()
        setDefaultPagerData()
    }
    
    private func setDefaultPagerData(){
        let totalPages = media.count
        pagerLabel.text = "1/\(totalPages)"
    }
    
    private func registerCell(){
        mediaCollectionView.register(
            UINib(nibName: CharacterMediaCollectionCells.CharacterMediaVCell.rawValue, bundle: nil),
            forCellWithReuseIdentifier: CharacterMediaCollectionCells.CharacterMediaVCell.rawValue
        )
        mediaCollectionView.dataSource = self
        mediaCollectionView.delegate = self
    }
    
    private func configureCollectionLayout() {
        // Initialize the CarouselFlowLayout
        let carouselLayout = CarouselFlowLayout()
        // Set item size to the width of the screen and a custom height
        carouselLayout.itemSize = CGSize(width: mediaCollectionView.bounds.width - 40, height: mediaCollectionView.bounds.height)
        carouselLayout.scrollDirection = .horizontal // Set horizontal scrolling
        carouselLayout.sideItemScale = 0.9 // Scale down side items
        carouselLayout.sideItemAlpha = 0.6 // Set the transparency of side items
        carouselLayout.spacingMode = .overlap(visibleOffset: 10) // Set spacing mode
        mediaCollectionView.collectionViewLayout = carouselLayout
    }
    
    @IBAction private func didTapClose(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}

extension CharacterMediaViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return media.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CharacterMediaCollectionCells.CharacterMediaVCell.rawValue,
            for: indexPath
        ) as? CharacterMediaVCell, let item = media[safe: indexPath.row] else {return UICollectionViewCell()}
        
        cell.configure(media: item)
        return cell
    }
}

extension CharacterMediaViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let witdh = scrollView.frame.width - (scrollView.contentInset.left*2)
        let index = scrollView.contentOffset.x / witdh
        let roundedIndex = round(index)
        let totalPages = media.count
        pagerLabel.text = "\(Int(roundedIndex) + 1)/\(totalPages)"
    }
}
