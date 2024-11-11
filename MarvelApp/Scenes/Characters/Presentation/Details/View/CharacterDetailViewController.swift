//
//  CharacterDetailViewController.swift
//  MarvelApp
//
//  Created by Emad Habib on 09/11/2024.
//

import UIKit
import Combine

final class CharacterDetailViewController: UIViewController {
    
    @IBOutlet private weak var characterDetailTableView: UITableView!
    private var viewModel: CharacterDetailViewModel
    private var cancellables: Set<AnyCancellable> = []
    private var sections: [CharDetailSectionOfCustomData] = []
    
    init(viewModel: CharacterDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        setSectionsData()
        bindViewModel()
        customizeNavigationBarForBackButton()
    }
    
    private func registerCells() {
        characterDetailTableView.register(
            UINib(nibName: CharacterDetailTableCells.CharacterDetailHeaderTCell.rawValue, bundle: nil),
            forCellReuseIdentifier: CharacterDetailTableCells.CharacterDetailHeaderTCell.rawValue
        )
        characterDetailTableView.register(
            UINib(nibName: CharacterDetailTableCells.CharacterDetailComicsTCell.rawValue, bundle: nil),
            forCellReuseIdentifier: CharacterDetailTableCells.CharacterDetailComicsTCell.rawValue
        )
    }
    
    private func setSectionsData() {
        characterDetailTableView.rowHeight = UITableView.automaticDimension
        characterDetailTableView.dataSource = self
    }
    
    private func bindViewModel() {
        viewModel.$sections
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newSections in
                guard let self else {return}
                self.sections.append(contentsOf: newSections)
                
                // Create an IndexSet for the sections you want to insert
                let sectionIndexes = (self.sections.count - newSections.count..<self.sections.count)
                    .map { $0 } // Convert range into an array of section indexes
                
                // Perform table view updates for section insertion
                self.characterDetailTableView.beginUpdates()
                self.characterDetailTableView.insertSections(IndexSet(sectionIndexes), with: .fade)
                self.characterDetailTableView.endUpdates()
            }
            .store(in: &cancellables)
        
        // Bind loading state to activity indicator
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                guard let self else {return}
                isLoading ? characterDetailTableView.showLoadingFooter() : characterDetailTableView.hideLoadingFooter()
            }
            .store(in: &cancellables)
    }
}

extension CharacterDetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[safe: section]?.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = sections[safe: indexPath.section]?.items[safe: indexPath.row] else {
            return UITableViewCell()
        }
        switch section.type {
        case .header:
            return configureHeaderCell(for: indexPath, item: section)
        case .comics, .series, .stories, .events:
            return configureMediaCell(for: indexPath, item: section)
        default:
            return UITableViewCell()
        }
    }
        
    private func configureHeaderCell(for indexPath: IndexPath, item: CharDetailSection) -> UITableViewCell {
        guard let cell = characterDetailTableView.dequeueReusableCell(
            withIdentifier: CharacterDetailTableCells.CharacterDetailHeaderTCell.rawValue,
            for: indexPath
        ) as? CharacterDetailHeaderTCell else {
            return UITableViewCell()
        }
        cell.configure(image: item.image, name: item.name, desc: item.desc)
        return cell
    }
    
    private func configureMediaCell(for indexPath: IndexPath, item: CharDetailSection) -> UITableViewCell {
        guard let cell = characterDetailTableView.dequeueReusableCell(
            withIdentifier: CharacterDetailTableCells.CharacterDetailComicsTCell.rawValue,
            for: indexPath
        ) as? CharacterDetailComicsTCell else {
            return UITableViewCell()
        }
        
        switch item.type {
        case .comics:
            cell.config(media: item.comics ?? [], mediaType: .comics)
        case .series:
            cell.config(media: item.series ?? [], mediaType: .series)
        case .stories:
            cell.config(media: item.stories ?? [], mediaType: .stories)
        case .events:
            cell.config(media: item.events ?? [], mediaType: .events)
        default:
            break
        }
        
        return cell
    }
}
