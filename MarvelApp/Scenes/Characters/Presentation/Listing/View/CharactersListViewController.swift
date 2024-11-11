//
//  CharactersListViewController.swift
//  MarvelApp
//
//  Created by Emad Habib on 08/11/2024.
//

import UIKit
import Combine
import Common
import CommonUI

// MARK: - Collection View Cell Identifier Enum
enum CharacterListCollectionCells: String {
    case CharacterCell
}

// MARK: - CharactersListViewController
final class CharactersListViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var charactersTableView: UITableView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var errorLabel: UILabel!
    
    // MARK: - Properties
    private let willDisplayCellSubject = PassthroughSubject<IndexPath, Never>()
    private var willDisplayCellPublisher: AnyPublisher<IndexPath, Never> {
        willDisplayCellSubject.eraseToAnyPublisher()
    }
    private var isFirstLoad = true // To track if it's the first load of the table view
    private var cancellables: Set<AnyCancellable> = []
    private let viewModel: CharactersListViewModel
    private weak var flow: CharacterCoordinator?
    private var characters: [CharacterModel] = []
    
    // MARK: - Initializer
    /// Dependency injection initializer for injecting the view model and flow coordinator
    /// - Parameters:
    ///   - viewModel: ViewModel responsible for character list data and actions
    ///   - flow: Coordinator for handling navigation actions
    init(viewModel: CharactersListViewModel, flow: CharacterCoordinator) {
        self.viewModel = viewModel
        self.flow = flow
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableSources()
        bindViewModel()
        viewModel.fetchCharacterList(with: .init())
        customizeNavigationBar(
            withImage: "icn-nav-marvel",
            searchAction: #selector(searchButtonTapped)
        )
    }
    
    // MARK: - Actions
    @objc private func searchButtonTapped() {
        flow?.navigateToSearchCharacters(from: self)
    }
    
    // MARK: - Setup Methods
    
    /// Configures the table view’s data source, delegate, and registers cell.
    private func setTableSources(){
        charactersTableView.register(
            UINib(nibName: CharacterListCollectionCells.CharacterCell.rawValue, bundle: nil),
            forCellReuseIdentifier: CharacterListCollectionCells.CharacterCell.rawValue
        )
        charactersTableView.dataSource = self
        charactersTableView.delegate = self
    }
    
    /// Binds the view model’s data and state to the view components (table view, activity indicator, and error label).
    private func bindViewModel() {
        // Bind characters array to table view
        viewModel.$characters
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newCharacters in
                guard let self else {return}
                updateTableView(newCharacters: newCharacters)
            }
            .store(in: &cancellables)
        
        // Bind loading state to activity indicator
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                guard let self else {return}
                if isFirstLoad {
                    isLoading ? self.activityIndicator.startAnimating() :self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = !isLoading
                }
                else {
                    isLoading ? charactersTableView.showLoadingFooter() : charactersTableView.hideLoadingFooter()
                }
            }
            .store(in: &cancellables)
        
        // Bind error message to error label
        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                guard let self else {return}
                self.errorLabel.text = errorMessage
                self.errorLabel.isHidden = errorMessage == nil
            }
            .store(in: &cancellables)
    }
}

// MARK: - Table View Update
extension CharactersListViewController {
    
    /// Updates the table view by appending new characters to the data source
    /// and inserting new rows for each character.
    ///
    /// - Parameter newCharacters: An array of `CharacterModel` instances to append and display.
    ///
    /// This method appends `newCharacters` to the existing characters list,
    /// then calculates the appropriate `IndexPath` values for the newly added rows.
    /// It performs a batch update to insert the new rows with a fade animation.
    
    private func updateTableView(newCharacters: [CharacterModel]){
        // Append the new characters to the existing array
        self.characters.append(contentsOf: newCharacters)
        // Generate index paths for the new characters
        let indexPaths = (self.characters.count - newCharacters.count..<self.characters.count)
            .map { IndexPath(row: $0, section: 0) }
        // Perform batch updates to insert the new rows with a fade animation
        self.charactersTableView.beginUpdates()
        self.charactersTableView.insertRows(at: indexPaths, with: .fade)
        self.charactersTableView.endUpdates()
    }
}

// MARK: - UITableViewDataSource
extension CharactersListViewController: UITableViewDataSource {
    
    /// Returns the number of rows in the table view section.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters.count
    }
    
    /// Configures and returns the cell for the given index path.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CharacterListCollectionCells.CharacterCell.rawValue,
            for: indexPath
        ) as? CharacterCell, let character = characters[safe: indexPath.row] else {
            return UITableViewCell()
        }
        cell.configureCell(with: character)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension CharactersListViewController: UITableViewDelegate {
    
    /// Called before a cell is displayed, used to trigger pagination when nearing the end of the list.
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView.isLastThreeItemsInLastSection(by: indexPath) && !viewModel.isLoading {
            isFirstLoad = false
            viewModel.callNextPage.send(())
        }
    }
    
    /// Handles the selection of a table view row, navigating to character details.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        flow?.navigateToCharacterDetail(
            with: characters[indexPath.row],
            from: self
        )
    }
}
