//
//  ViewController.swift
//  EpayWeather
//
//  Created by Anas khurshid on 28/11/2021.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var iconLabel: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var forecastCollection: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tabsView: TabsView!
    @IBOutlet weak var mainVIew: UIView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet weak var forecastHourView: UIView!
    @IBOutlet weak var forecastDailyView: UIView!
    @IBOutlet weak var lastUpdated: UILabel!
    
    //MARK: - vars
    var iconText1: String?
    var forecastModels: [ForecastViewModel]?
    var forecastDailyModels: [ForecastDailyViewModel]?
    var refreshControl = UIRefreshControl()
    var currentIndex: Int = 0
    
    fileprivate let imageUrl = "https://openweathermap.org/img/wn/"
    
    
    //MARK: ViewModel
    var viewModel: WeatherViewModel? {
        didSet {
            
            viewModel?.iconText.observe {
                [unowned self] in
                self.iconText1 = "\(imageUrl)\($0)@2x.png"
                self.iconLabel.downloadedFrom(link: self.iconText1 ?? "")
            }
            //
            viewModel?.temperature.observe {
                [unowned self] in
                self.temperatureLabel.text = $0
            }
            setForcastView()
            setForcastDailyView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = WeatherViewModel()
        let loc = CLLocation(latitude: 22.9068, longitude: 43.1729)
        viewModel?.locationDidUpdate(location: loc)
        
        forecastCollection.dataSource = self
        forecastCollection.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        let now = Date.now
        let date = now.formatted(date: .abbreviated, time: .omitted)
        lastUpdated.text = "Last updated on \(date)"
        setAdditionalLayout()
        setupTabs()
        setFlowLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        scrollView.refreshControl = refreshControl
    }
    
    @objc func refresh(sender:AnyObject) {
        switchWeather(position: currentIndex)
        refreshControl.endRefreshing()
    }
    
    
    private func setAdditionalLayout() {
        mainVIew.backgroundColor = UIColor(red: 135/255, green: 206/255, blue: 235/255, alpha: 1)
        forecastHourView.layer.cornerRadius = 8
        forecastHourView.layer.masksToBounds = true
        
        forecastDailyView.layer.cornerRadius = 8
        forecastDailyView.layer.masksToBounds = true
    }
    
    private func setFlowLayout() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width/4, height: 180)
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = 0.0
        
        
        forecastCollection.collectionViewLayout = flowLayout
    }
    
    private func setForcastView() {
        viewModel?.forecasts.observe {
            
            [unowned self] (forecastViewModels) in
            if forecastViewModels.count > 0 {
                
                
                self.forecastModels = forecastViewModels
                forecastCollection.reloadData()
                
            }
        }
    }
    
    private func setForcastDailyView() {
        viewModel?.forecastsDaily.observe {
            
            [unowned self] (forecastDailyViewModels) in
            if forecastDailyViewModels.count > 0 {
                
                
                self.forecastDailyModels = forecastDailyViewModels
                tableView.reloadData()
                
            }
        }
    }
    
    func setupTabs() {
        // Add Tabs (Set 'icon'to nil if you don't want to have icons)
        tabsView.tabs = [
            Tab(title: "Rio de Janeiro"),
            Tab(title: "Beijing"),
            Tab(title: "Los Angeles")
        ]
        
        
        tabsView.tabMode = .fixed
        
        // TabView Customization
        tabsView.titleColor = .white
        tabsView.iconColor = .white
        tabsView.indicatorColor = .white
        tabsView.titleFont = UIFont.systemFont(ofSize: 20, weight: .semibold)
        // tabsView.collectionView.backgroundColor = .cyan
        
        // Set TabsView Delegate
        tabsView.delegate = self
        
        // Set the selected Tab when the app starts
        tabsView.collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .centeredVertically)
    }
    
}

extension ViewController: TabsDelegate {
    
    func tabsViewDidSelectItemAt(position: Int) {
        
        switchWeather(position: position)
        scrollToItem(position: position)
    }
    
    
    private func switchWeather(position: Int) {
        if position != currentIndex {
            switch (position){
            case 0:
                let loc = CLLocation(latitude: 22.9068, longitude: 43.1729)
                viewModel?.locationDidUpdate(location: loc)
                currentIndex = 0
                break
            case 1:
                let loc = CLLocation(latitude: 39.9042, longitude: 116.4074)
                viewModel?.locationDidUpdate(location: loc)
                currentIndex = 1
                break
            case 2:
                let loc = CLLocation(latitude: 34.0522, longitude: 118.2437)
                viewModel?.locationDidUpdate(location: loc)
                currentIndex = 2
                break
            default:
                let loc = CLLocation(latitude: 22.9068, longitude: 43.1729)
                viewModel?.locationDidUpdate(location: loc)
                currentIndex = 0
                break
                
            }
        }
    }
    
    private func scrollToItem(position: Int) {
        tabsView.collectionView.scrollToItem(at: IndexPath(item: position, section: 0), at: .centeredHorizontally, animated: true)
    }
}




extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.forecastModels?.count ?? 0
        
    }
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "hourforecast", for: indexPath) as!
        ForecastView
        
        let rowObj =  forecastModels?[indexPath.row]
        let iconText = rowObj?.iconText ?? "02d"
        let iconURL = "\(imageUrl)\(iconText)@2x.png"
        
        let time = rowObj?.time
        let temprature = rowObj?.temperature
        let pop = rowObj?.pop
        
        cell.timeLabel.text = time
        cell.temperatureLabel.text = temprature
        cell.iconLabel.downloadedFrom(link: iconURL)
        cell.pop.text = pop
        
        return cell
    }
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecastDailyModels?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "daysforecast", for: indexPath) as!
        ForecastDailyView
        
        let rowObj =  forecastDailyModels?[indexPath.row]
        let iconText = rowObj?.iconLabel ?? "02d"
        let iconURL = "\(imageUrl)\(iconText)@2x.png"
        
        let dateFull = rowObj?.dateFull
        
        let temprature = rowObj?.temperatureLabel
        let weatherCondition = rowObj?.weatherDescription
        
        cell.weatherDescription.text = weatherCondition
        cell.temperatureLabel.text = temprature
        cell.dateFull.text = dateFull
        cell.iconLabel.downloadedFrom(link: iconURL)
        
        return cell
    }
}



