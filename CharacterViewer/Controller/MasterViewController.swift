//
//  MasterViewController.swift
//  CharacterViewer
//
//  Created by Dhanesh K M on 05/02/20.
//  Copyright © 2020 Dhanesh K M. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {
    
    @IBOutlet weak var characterTableView: UITableView!
    
    var characters = [Character]()
    var isSearching = false
    var filteredData = [CharacterViewModel]()
    var characterViewModels = [CharacterViewModel]()
    
    var searchResultController = UISearchController()
    var detailViewController: DetailViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        initializeSearchController()
        fetchCharacters()
    }
    
    //Initialize search controller and search bar
    func initializeSearchController() {
       searchResultController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.searchBar.sizeToFit()
            self.characterTableView.tableHeaderView = controller.searchBar
            return controller
        })()

    }
    
    //Fetch characters from API
    func fetchCharacters() {
        Service.shared.fetchCharacters(onSuccess: { characters in
            self.characters = characters
            self.characterViewModels = self.characters.map { return
                CharacterViewModel(character: $0)
            }
            DispatchQueue.main.async {
                self.characterTableView.reloadData()
            }
        }) { error in
            debugPrint(error.localizedDescription)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }


    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
                detailViewController = controller
                detailViewController?.character = characters[indexPath.row]

            }
        }
    }

}

extension MasterViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchResultController.isActive {
            return filteredData.count
        }
        return characterViewModels.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CharacterTableViewCell
        let characterViewModel: CharacterViewModel!
        if searchResultController.isActive {
            characterViewModel = filteredData[indexPath.row]
        } else {
            characterViewModel = self.characterViewModels[indexPath.row]
        }
        cell.characterViewModel = characterViewModel
        
        return cell
    }
}

extension MasterViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filteredData = searchNameAndDescription(searchText: searchController.searchBar.text ?? "", characters: characterViewModels)
        characterTableView.reloadData()
    }
    
    func searchNameAndDescription(searchText: String, characters: [CharacterViewModel]) -> [CharacterViewModel]{
        return characters.filter {$0.nameWithDescription.localizedCaseInsensitiveContains(searchText)}
    }
    
}
