import UIKit

class CollectionViewCustomDataSource<Model>: NSObject, UICollectionViewDataSource {
    
    typealias CellConfigurator = (Model, UICollectionViewCell) -> Void
    var models: [Model]
    private let reuseIdentifier: String
    private let cellConfigurator: CellConfigurator
    
    init(models: [Model], reuseIdentifier: String, cellConfigurator: @escaping CellConfigurator) {
        self.models = models
        self.reuseIdentifier = reuseIdentifier
        self.cellConfigurator = cellConfigurator
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = models[indexPath.item]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? CharacterDetailComicVCell else {
            fatalError("Cell identifier mismatch or incorrect cell type")
        }
        cellConfigurator(model, cell)
        return cell
    }
}

extension CollectionViewCustomDataSource where Model == CharacterMediaModel {
    static func displayData(for itemLists: [CharacterMediaModel]) -> CollectionViewCustomDataSource {
        return CollectionViewCustomDataSource(models: itemLists, reuseIdentifier: "CharacterDetailComicVCell", cellConfigurator: { (data, cell) in
            if let itemCell = cell as? CharacterDetailComicVCell {
                itemCell.configureCell(media: data)
            } else {
                print("Error: Unable to cast cell")
            }
        })
    }
}
