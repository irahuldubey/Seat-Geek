//
//  SearchViewController.swift
//  SeatGeek
//
//  Created by Rahul Dubey on 10/24/20.
//  Copyright © 2020 com.seatgeek.org. All rights reserved.
//

import UIKit

final class SearchViewController: UITableViewController, ActivityIndicatorProtocol {
    
    internal var activityIndicator = UIActivityIndicatorView()
    private var viewModel: SearchViewModel!
    private var currentSearchText: String = ""
    
    lazy var searchController: UISearchController  = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = Message.searchPlaceholder
        searchController.searchBar.delegate = self
        return searchController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = SearchViewModel.init(delegate: self)
        setUpView()
        setUpNavigationAndSearchBar()
    }
    
    private func setUpView() {
        self.view.backgroundColor = .white
        self.tableView.keyboardDismissMode = .onDrag
    }
    
    private func setUpNavigationAndSearchBar() {
        navigationItem.searchController = searchController
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationItem.largeTitleDisplayMode = .automatic
        definesPresentationContext = true
    }
    
    // MARK: - Button Action
    private func clearSearchResults() {
        searchController.searchBar.text = nil
        viewModel.removeAllEvents()
        self.tableView.reloadData()
        searchController.searchBar.resignFirstResponder()
    }
}

// MARK: TableView DataSource
extension SearchViewController {
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableView(tableView, heightForRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.totalSearchResultCount
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifiers.searchResultsCell, for: indexPath) as! SearchResultCell
        if isLoadingCell(for: indexPath) {
            // configure loading cell to show loading view like Facebook Feed...
        } else {
            let event = viewModel.event(at: indexPath.row)
            cell.setUp(with: event)
        }
        return cell
    }
}

// MARK: - Table view delegate
extension SearchViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexValue = viewModel.event(at: indexPath.row)
        performSegue(withIdentifier: SegueIdentifiers.detail, sender: indexValue)
    }
    
}

// MARK: UISearchBarDelegate
extension SearchViewController:  UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        loadSearchResults(text: searchBar.text!)
    }
}

// MARK: SearchViewModelDelegate
extension SearchViewController: SearchViewModelDelegate, SGAlertAction {
    
    func onFetchSuccess(with newIndexPathsToReload: [IndexPath]?) {
        self.removeLoadingIndicator()
        
        guard let newIndexPathsToReload = newIndexPathsToReload else {
            self.tableView.isHidden = false
            self.tableView.reloadData()
            return
        }
        let indexPathsToReload = self.visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
        self.tableView.reloadRows(at: indexPathsToReload, with: .automatic)
    }
    
    func onFetchFailure(with error: String) {
        self.removeLoadingIndicator()
        
        let action = UIAlertAction(title: Message.alert, style: .default)
        self.displayAlert(with: Message.ok , message: error, actions: [action])
    }
    
    func loadSearchResults(text: String?) {
        guard let searchText = text, searchText.count > 0 else {
            clearSearchResults()
            return
        }
        showLoadingIndicator(withSize: CGSize.init(width: 80, height: 80))
        self.currentSearchText = searchText
        viewModel.fetchResults(for: searchText)
    }
}

// MARK: UITableViewDataSourcePrefetching
extension SearchViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell), viewModel.currentCount > 0 {
            if !currentSearchText.isEmpty {
                viewModel.loadMoreResultsOnPagination()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        // This can be optimized more but temp just cancel the request which happens when the user scrolls up
        viewModel.cancelFetch()
    }
}

// MARK: Index Path Utilities
private extension SearchViewController {
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= self.viewModel.currentCount
    }
    
    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows ?? []
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
}

// MARK: Navigation
extension SearchViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueId = segue.identifier else {
            return
        }
        switch segueId {
        case SegueIdentifiers.detail:
            if let detailViewController = segue.destination as? DetailsViewController,
                let event = sender as? EventModel {
                detailViewController.detailDelegate = self
                detailViewController.setUpDetailView(identifier: event.identifier)
            }
        default:
            break
        }
    }
}

// MARK: Favorite Update
extension SearchViewController: DetailViewControllerDelegate {
    func updateFavoriteEvent(withIdentifier id: String, isFavorite: Bool) {
        if let indexPath = viewModel.eventIndexPath(for: id, isFavorite: isFavorite) {
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
}
