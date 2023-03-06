//
//  ViewController.swift
//  DispatchWorkItem
//
//  Created by Sachin Daingade on 06/03/23.
//

import UIKit

class ViewController: UIViewController, UISearchResultsUpdating , UITableViewDataSource{
    
    
    @IBOutlet var searchTableView: UITableView!
    private var pendingRequestWorkItem: DispatchWorkItem?
    private let searchViewController = UISearchController()
    
    private var allResultData = ["Sachin","Rahul","Viru","Sourabh","MS Dhoni","Yuvraj", "V Kohli", "Zahir","Nehra","Kumble","Venky"]
    private var searchResult : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Search"
        navigationItem.searchController = searchViewController
        searchViewController.searchResultsUpdater = self
        searchResult = allResultData
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let searchText = searchController.searchBar.text else {
            return
        }
        pendingRequestWorkItem?.cancel()
        
        // Wrap our request in a work item
        let requestWorkItem = DispatchWorkItem { [weak self] in
            self?.loadNewResult(forQuery: searchText)
        }
        
        // Save the new work item and execute it after 250 ms
        pendingRequestWorkItem = requestWorkItem
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250),
                                      execute: requestWorkItem)
    }
    
    
    private func loadNewResult(forQuery: String) {
        searchResult = forQuery.isEmpty ? allResultData : allResultData.filter{$0.lowercased().contains(forQuery.lowercased())}
        DispatchQueue.main.async {  [weak self] in
            self?.searchTableView.reloadData()
        }
    }
    
    // Called when user selects one of the search suggestion buttons displayed under the keyboard on tvOS.
    // @available(iOS 16.0, *)
    //  func updateSearchResults(for searchController: UISearchController, selecting searchSuggestion: UISearchSuggestion)
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "\(searchResult[indexPath.row])"
        return cell
    }
    
}
