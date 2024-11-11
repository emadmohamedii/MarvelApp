//
//  SearchCharactersViewController.swift
//  MarvelApp
//
//  Created by Emad Habib on 08/11/2024.
//

import UIKit
import Combine
import Common
import CommonUI

// Enum for Table View Cells identifiers
enum SearchCharactersTableCells: String {
    case SearchCharacterCell
}

final class SearchCharactersViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var charactersTableView: UITableView!
    @IBOutlet private weak var searchBar: SearchTextField!
    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var errorLabel: UILabel!
    
    // MARK: - Private Properties
    private let willDisplayCellSubject = PassthroughSubject<IndexPath, Never>()
    private var willDisplayCellPublisher: AnyPublisher<IndexPath, Never> {
        willDisplayCellSubject.eraseToAnyPublisher()
    }
    private var isFirstLoad = true // To track if it's the first load of the table view
    private var cancellables: Set<AnyCancellable> = []
    private let viewModel: CharactersListViewModel
    private weak var flow: CharacterCoordinator?
    private let limitOfFirstPage = 9

    // MARK: - Initializer (Dependency Injection)
    init(viewModel: CharactersListViewModel, flow: CharacterCoordinator) {
        self.viewModel = viewModel
        self.flow = flow
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableSources()
        bindViewModel()
        setupSearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showNavigationBar()
    }
    
    // MARK: - Actions
    @IBAction private func cancelButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Setup Methods
    /// Sets up the search bar appearance and behavior.
    private func setupSearchBar(){
        searchBar.attributedPlaceholder = NSAttributedString(
            string: "Search...",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        // Set the delegate
        searchBar.delegate = self
    }
    
    /// Registers the table view cell and sets the data source and delegate.
    private func setTableSources(){
        charactersTableView.register(
            UINib(nibName: SearchCharactersTableCells.SearchCharacterCell.rawValue, bundle: nil),
            forCellReuseIdentifier: SearchCharactersTableCells.SearchCharacterCell.rawValue
        )
        charactersTableView.dataSource = self
        charactersTableView.delegate = self
    }
    
    // MARK: - Bind ViewModel
    /// Binds the ViewModel properties to the UI elements.
    private func bindViewModel() {
        // Bind characters array to table view
        viewModel.$characters
            .receive(on: DispatchQueue.main)
            .sink { [weak self] characters in
                guard let self else {return}
                self.charactersTableView.reloadData()
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

// MARK: - UITableViewDataSource Methods
extension SearchCharactersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.characters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SearchCharactersTableCells.SearchCharacterCell.rawValue,
            for: indexPath
        ) as? CharacterCell, let character = viewModel.characters[safe: indexPath.row] else {
            return UITableViewCell()
        }
        cell.configureCell(with: character)
        return cell
    }
}

// MARK: - UITableViewDelegate Methods
extension SearchCharactersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView.isLastThreeItemsInLastSection(by: indexPath) && !viewModel.isLoading && viewModel.characters.count > limitOfFirstPage {
            isFirstLoad = false
            viewModel.callNextPage.send(())
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        flow?.navigateToCharacterDetail(
            with: viewModel.characters[indexPath.row],
            from: self
        )
    }
}

// MARK: - UISearchBarDelegate Methods
extension SearchCharactersViewController: UITextFieldDelegate {
    
    // UITextFieldDelegate method - called when search button is tapped
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Close the keyboard
        textField.resignFirstResponder()
        // Perform the search action
        if let searchText = textField.text, !searchText.isEmpty {
            performSearch(with: searchText)
        }
        return true
    }
    
    // Define the search action
    private func performSearch(with query: String) {
        viewModel.clearSearchResult()
        guard let query = searchBar.text, query.isNotNullOrEmpty else {return}
        self.viewModel.fetchCharacterList(with: CharactersRequest(name: query))
    }
}
