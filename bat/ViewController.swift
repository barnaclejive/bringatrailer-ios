//
//  ViewController.swift
//  bat
//
//  Created by Mike Peterson on 7/27/19.
//  Copyright © 2019 foobax. All rights reserved.
//

import UIKit
import Alamofire

enum SortMode: Int {
    case date_asc
    case date_desc
    case price_asc
    case price_desc
}

enum FilterMode: Int {
    case all
    case sold
    case unsold
}

class ViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    var allCars = [Car]()
    var displayCars = [Car]()
    var searchTerm = ""
    var sortMode: SortMode = .date_desc
    var filterMode: FilterMode = .all

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // table config
        tableView.register(UINib(nibName: String(describing: CarCell.self), bundle: nil), forCellReuseIdentifier: String(describing: CarCell.self))
        tableView.tableFooterView = UITableViewHeaderFooterView(frame: CGRect.zero)
        
        // nav
        navigationController?.hidesBarsOnSwipe = true
        
        let sortButton = UIBarButtonItem(title: "Sort", style: .plain, target: self, action: #selector(sortAction(sender:)))
        let filterButton = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(filterAction(sender:)))
        navigationItem.rightBarButtonItems = [filterButton, sortButton]
        
        // search bar
        let searchBar = UISearchBar(frame: CGRect.zero)
        searchBar.delegate = self
        navigationItem.titleView = searchBar
    }
    
    @IBAction func sortAction(sender: UIView) {
        
        let sortAlert = UIAlertController(title: "Sort", message: nil, preferredStyle: .actionSheet)
        
        let dateDescAction = UIAlertAction(title: "Date (Latest - Oldest)", style: .default) { (action) in
            self.sortMode = .date_desc
            self.doSort()
        }
        
        let dateAscAction = UIAlertAction(title: "Date (Oldest - Latest)", style: .default) { (action) in
            self.sortMode = .date_asc
            self.doSort()
        }
        
        let priceDescAction = UIAlertAction(title: "Price (Highest - Lowest)", style: .default) { (action) in
            self.sortMode = .price_desc
            self.doSort()
        }
        
        let priceAscAction = UIAlertAction(title: "Price (Lowest - Highest)", style: .default) { (action) in
            self.sortMode = .price_asc
            self.doSort()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            sortAlert.dismiss(animated: true, completion: nil)
        }
        
        sortAlert.addAction(dateDescAction)
        sortAlert.addAction(dateAscAction)
        sortAlert.addAction(priceDescAction)
        sortAlert.addAction(priceAscAction)
        sortAlert.addAction(cancelAction)
        present(sortAlert, animated: true, completion: nil)
    }
    
    @IBAction func filterAction(sender: UIView) {
        
        let filterAlert = UIAlertController(title: "Filter", message: nil, preferredStyle: .actionSheet)
        
        let allAction = UIAlertAction(title: "All", style: .default) { (action) in
            self.filterMode = .all
            self.doSort()
        }
        
        let soldAction = UIAlertAction(title: "Only Sold", style: .default) { (action) in
            self.filterMode = .sold
            self.doSort()
        }
        
        let unsoldAction = UIAlertAction(title: "Only Unsold", style: .default) { (action) in
            self.filterMode = .unsold
            self.doSort()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            filterAlert.dismiss(animated: true, completion: nil)
        }
        
        filterAlert.addAction(allAction)
        filterAlert.addAction(soldAction)
        filterAlert.addAction(unsoldAction)
        filterAlert.addAction(cancelAction)
        present(filterAlert, animated: true, completion: nil)
    }
    
    private func doSort() {
        
        displayCars.removeAll()
        displayCars.append(contentsOf: allCars)
        
        if (sortMode == .date_desc) {
            displayCars.sort {
                $0.timestamp > $1.timestamp
            }
            
        } else if (sortMode == .date_asc) {
            displayCars.sort {
                $0.timestamp < $1.timestamp
            }
        } else if (sortMode == .price_desc) {
            displayCars.sort {
                $0.amount > $1.amount
            }
        } else if (sortMode == .price_asc) {
            displayCars.sort {
                $0.amount < $1.amount
            }
        }
        
        if (filterMode == .sold) {
            displayCars = displayCars.filter {
                !$0.reserveMet
            }
        } else if (filterMode == .unsold) {
            displayCars = displayCars.filter {
                $0.reserveMet
            }
        }
        
        self.tableView.reloadData()
    }
}

// table extension
extension ViewController: UITableViewDelegate {
    
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayCars.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CarCell.self)) as! CarCell
        cell.configureForProduct(displayCars[indexPath.row])
        return cell
    }
}

// search extensions
extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let searchTerm = searchBar.text else {
            return
        }
        
        self.view.alpha = 0.85
        spinner.startAnimating()
        
        Parser.getCars(searchTerm: searchTerm) { cars in
            
            self.spinner.stopAnimating()
            self.view.alpha = 1
            
            self.allCars.removeAll()
            self.allCars.append(contentsOf: cars)
            self.doSort()
        }
    }
}

