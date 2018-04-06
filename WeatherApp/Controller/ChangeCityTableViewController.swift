//
//  ChangeCityTableViewController.swift
//  WeatherApp
//
//  Created by Simon Winther on 2018-04-03.
//  Copyright © 2018 Simon Winther. All rights reserved.
//

import UIKit

protocol ChangeCityDelegate2 {
    func userEnteredANewCity (city: String)
}

struct Cities: Decodable {
    var name : String
}





class ChangeCityTableViewController: UITableViewController, UISearchResultsUpdating {

    

    var delegate : ChangeCityDelegate2?
    
    var newCity = ""
    
    var arrayOfCityNames : [Cities]?
    
    var searchResult : [Cities]? = []
    
    var searchController : UISearchController!
    
    override func viewDidLoad() {
        
        definesPresentationContext = true
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        
        
        navigationItem.searchController = searchController
        
//        _ = CAGradientLayer()
//        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "sunsetBeach.jpg")!)
//        super.viewDidLoad()
        
        //print("i viewdidload")
        //print(delegate)
        
        arrayOfCityNames = loadJson() as? [Cities]
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchController.searchBar.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateTable()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text?.lowercased() {
            searchResult = arrayOfCityNames?.filter({ $0.name.lowercased().contains(text) })
        } else {
            searchResult = []
        }
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    var shouldUseSearchResult : Bool {
        if let text = searchController.searchBar.text {
            if text.isEmpty {
                return false
            } else {
                return searchController.isActive
            }
        } else {
            return false
        }
    }
    
    func loadJson() -> [Cities?]? {
        if let url = Bundle.main.url(forResource: "city.list", withExtension: "json") {
            
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode([Cities].self, from: data)
                
                return jsonData
                
                
            }
            catch {
                print("error:\(error)")
            }
        }
        return nil
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shouldUseSearchResult {
            return searchResult!.count
        } else {
        return arrayOfCityNames!.count
    }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let array : [Cities]
        
        if shouldUseSearchResult {
            array = searchResult!
        } else {
            array = arrayOfCityNames!
            
        }
        cell.textLabel?.text = array[indexPath.row].name

        return cell
    }
    
    func animateTable() {
        tableView.reloadData()
        let cells = tableView.visibleCells
        
        let tableViewHeight = tableView.bounds.size.height
        
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
        }
        
        var delayCounter = 0
        for cell in cells {
            UIView.animate(withDuration: 1.75, delay: Double(delayCounter) * 0.05, usingSpringWithDamping: 0.7, initialSpringVelocity:0, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            delayCounter += 1
        }
    }
    
    
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if (segue.identifier == "showMain") {
//            let destination = segue.destination as! ViewController,
//            rowIndex = tableView.indexPathForSelectedRow!.row
//            destination.city = searchResults[rowIndex].name!
//        }
//    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if shouldUseSearchResult {
           newCity = searchResult![indexPath.row].name
        } else {
           newCity = arrayOfCityNames![indexPath.row].name
        }
        //print(newCity)
        
        delegate?.userEnteredANewCity(city: newCity)
        
        //print(delegate)
        
       self.navigationController?.popViewController(animated: true)
    }

}
