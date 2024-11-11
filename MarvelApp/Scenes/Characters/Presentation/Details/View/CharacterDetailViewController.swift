//
//  CharacterDetailViewController.swift
//  MarvelApp
//
//  Created by Emad Habib on 09/11/2024.
//

import UIKit
import Combine

final class CharacterDetailViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var characterDetailTableView: UITableView!
    
    // MARK: - Properties
    private var viewModel: CharacterDetailViewModel
    private var cancellables: Set<AnyCancellable> = []
    private var sections: [CharDetailSectionOfCustomData] = []
    private var coordinator: CharacterCoordinator?
    
    // MARK: - Initializer
    /// Initializes the view controller with a view model.
    /// - Parameter viewModel: The view model that provides character data.
    init(viewModel: CharacterDetailViewModel, coordinator: CharacterCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        setSectionsData()
        bindViewModel()
        customizeNavigationBarForBackButton()
    }
    
    // MARK: - Private Methods
    /// Registers the table view cells for reuse.
    private func registerCells() {
        characterDetailTableView.register(
            UINib(nibName: CharacterDetailTableCells.CharacterDetailHeaderTCell.rawValue, bundle: nil),
            forCellReuseIdentifier: CharacterDetailTableCells.CharacterDetailHeaderTCell.rawValue
        )
        //MARK: TableCell contains CollectionCell
        characterDetailTableView.register(
            UINib(nibName: CharacterDetailTableCells.CharacterDetailComicsTCell.rawValue, bundle: nil),
            forCellReuseIdentifier: CharacterDetailTableCells.CharacterDetailComicsTCell.rawValue
        )
    }
    
    /// Sets the table view's data source and row height.
    private func setSectionsData() {
        characterDetailTableView.rowHeight = UITableView.automaticDimension
        characterDetailTableView.dataSource = self
    }
    
    /// Binds the view model to the view controller to update the UI when data changes.
    private func bindViewModel() {
        // Bind the sections array to update the table view whenever new sections are received.
        viewModel.$sections
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newSections in
                guard let self else {return}
                updateTableView(newSections: newSections)
            }
            .store(in: &cancellables)
        
        viewModel.$updateSection
            .receive(on: DispatchQueue.main)
            .sink { [weak self] updatedSection in
                guard let self, let updatedSection = updatedSection else { return }
                updateTableSection(currentSection: updatedSection)
            }
            .store(in: &cancellables)
        
        // Bind the loading state to show or hide a loading footer.
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                guard let self else {return}
                isLoading ? characterDetailTableView.showLoadingFooter() : characterDetailTableView.hideLoadingFooter()
            }
            .store(in: &cancellables)
    }
}
// MARK: - Helper Table Methods
extension CharacterDetailViewController {
    private func updateTableView(newSections: [CharDetailSectionOfCustomData]){
        sections = newSections
        characterDetailTableView.reloadData()
    }
    
    private func updateTableSection(currentSection: CharDetailSectionOfCustomData){
        // Find the section with the matching headerType
        if let sectionIndex = self.sections.firstIndex(where: { $0.headerType == currentSection.headerType }) {
            // Update the items of the section
            self.sections[sectionIndex].items = currentSection.items
            self.characterDetailTableView.reloadSections(IndexSet(integer: sectionIndex), with: .automatic)
        }
    }
}

// MARK: - UITableViewDataSource Methods
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
}

// MARK: - Cell Configuration Methods
extension CharacterDetailViewController {
    private func configureHeaderCell(for indexPath: IndexPath, item: CharDetailSection) -> UITableViewCell {
        guard let cell = characterDetailTableView.dequeueReusableCell(
            withIdentifier: CharacterDetailTableCells.CharacterDetailHeaderTCell.rawValue,
            for: indexPath
        ) as? CharacterDetailHeaderTCell else { return UITableViewCell() }
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
        cell.delegate = self
        switch item.type {
        case .comics:
            cell.setupParameters(itemlist: item.comics ?? [], type: .comics)
        case .series:
            cell.setupParameters(itemlist: item.series ?? [], type: .series)
        case .stories:
            cell.setupParameters(itemlist: item.stories ?? [], type: .stories)
        case .events:
            cell.setupParameters(itemlist: item.events ?? [], type: .events)
        default:
            break
        }
        return cell
    }
}

extension CharacterDetailViewController: CollectionViewCustomDelegate{
    func didSelectItem<Model>(_ model: Model, fullMediaList: [Model]) {
        guard let media = fullMediaList as? [CharacterMediaModel] else { return }
        coordinator?.navigateToMediaDetail(with: media, from: self)
    }
}
