//
//  SearchViewController.swift
//  EpayWeather
//
//  Created by Anas khurshid on 28/11/2021.
//

import Foundation
import UIKit
import CoreLocation



class SearchViewController: UIViewController, UISearchResultsUpdating {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var iconLabel: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    fileprivate let imageUrl = "https://openweathermap.org/img/wn/"
    
    var searchBar: UISearchBar!
    var city = [CityList]()
    var iconText: String?
    var data:[CityList]!
    var filteredData: [CityList]!
    var searchController: UISearchController!
    
    //MARK: ViewModel
    var viewModel: WeatherViewModel? {
        didSet {
            
            viewModel?.iconText.observe {
                [unowned self] in
                self.iconText = "\(imageUrl)\($0)@2x.png"
                self.iconLabel.downloadedFrom(link: self.iconText ?? "")
            }
            //
            viewModel?.temperature.observe {
                [unowned self] in
                self.temperatureLabel.text = $0
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = WeatherViewModel()
        
        data = convertCSVIntoArray()
        tableView.dataSource = self
        tableView.delegate = self
        
        filteredData = data
        setupSearchController()
        
        definesPresentationContext = true
    }
    
    private func setupSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        
        searchController.searchBar.sizeToFit()
        tableView.tableHeaderView = searchController.searchBar
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            
            filteredData = searchText.isEmpty ? data :  data.filter { obj in
                return obj.name.range(of: searchText, options: .caseInsensitive) != nil
            }
            
            
            tableView.reloadData()
        }
    }
    
    
    
    private func convertCSVIntoArray() -> [CityList] {
        
        //locate the file you want to use
        guard let filepath = Bundle.main.path(forResource: "city", ofType: "csv") else {
            return []
        }
        
        //convert that file into one long string
        var data = ""
        do {
            data = try String(contentsOfFile: filepath)
        } catch {
            print(error)
            return []
        }
        
        //now split that string into an array of "rows" of data.  Each row is a string.
        var rows = data.components(separatedBy: "\n")
        
        //if you have a header row, remove it here
        rows.removeFirst()
        
        //now loop around each row, and split it into each of its columns
        for row in rows {
            let columns = row.components(separatedBy: ",")
            
            //check that we have enough columns
            if columns.count == 7 {
                let name = columns[1]
                let  lat = columns[5]
                let  lon = columns[6]
                
                
                let person = CityList(name: name, lat: Double(lat)!, lon: Double(lon)!)
                city.append(person)
            }
        }
        return city
    }
    
    
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let objData = filteredData[indexPath.row]
        
        let loc = CLLocation(latitude: objData.lat, longitude: objData.lon)
        viewModel?.locationDidUpdate(location: loc)
        self.cityLabel.text = objData.name
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell")!
        cell.textLabel?.text = filteredData[indexPath.row].name
        return cell
    }
}
