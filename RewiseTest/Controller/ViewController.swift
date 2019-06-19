//
//  ViewController.swift
//  RewiseTest
//
//  Created by MAHESH MOHAN BHONDAVE on 18/06/19.
//  Copyright © 2019 Mahesh Bhondave. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, CLLocationManagerDelegate
{
    @IBOutlet weak var citiesTableView: UITableView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var citiesArray = [CityClass]()
    var searchedResult = [CityClass]()
    var isSearch = false
    
    let locationManager = CLLocationManager()
    var currentLocation = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        citiesTableView.register(UINib.init(nibName: "UserCC", bundle: nil), forCellReuseIdentifier: "UserCC")
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        self.indicator.isHidden = false
        indicator.startAnimating()
        getCityDataFromJsonFile()
    }
    
    func getCityDataFromJsonFile()
    {
        // Load Json File
        DispatchQueue.global(qos: .background).async
            {
                if let path = Bundle.main.path(forResource: "cities", ofType: "json") {
                    do {
                        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                        
                        let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                        
                        if let jsonResult = jsonResult as? [Dictionary<String,Any>] {
                            
                            DispatchQueue.main.async {
                                self.indicator.stopAnimating()
                                self.indicator.isHidden = true
                                
                                let sortedArray = (jsonResult as NSArray).sortedArray(using: [NSSortDescriptor(key: "name", ascending: true)]) as! [[String:AnyObject]]
                                
                                for obj in sortedArray
                                {
                                    let city = CityClass(UserDict: obj)
                                    self.citiesArray.append(city)
                                }
                                self.citiesTableView.reloadData()
                            }
                        }
                    }
                    catch
                    {
                        // handle error
                    }
                }
        }
    }
}

//Mark:- Delegates and DataSource

extension ViewController
{
    //MARK:- UITableView  DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if isSearch == true{
            return searchedResult.count
        }else{
            return citiesArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:UserCC = self.citiesTableView.dequeueReusableCell(withIdentifier: "UserCC", for: indexPath) as! UserCC
        let city = self.getCityData(indexPath: indexPath)
        cell.nameLbl.text = "\(city.name ?? "")"
        cell.countryLbl.text = "\(city.country ?? "")"
        
        let distanceInKiloMeters = (CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude).distance(from: CLLocation(latitude: city.coord?.latitude ?? 0.0, longitude: city.coord?.longitude ?? 0.0)))/1000
        
        cell.calculatedDistance.text = String(format: "%.2f KM", distanceInKiloMeters)
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }
    
    //MARK:- UISearchBar  Delegates
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.searchedResult = searchText.isEmpty ? self.citiesArray : self.citiesArray.filter({(dataString: CityClass) -> Bool in
            // If dataItem matches the searchText, return true to include it
            return dataString.name?.contains(searchText) ?? false
            //return dataString.name?.range(of: searchText, options: .caseInsensitive) != nil
        })
        
        if searchText.isEmpty{
            isSearch = false
        }
        else
        {
            isSearch = true
        }
        
        self.citiesTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        searchBar.resignFirstResponder()
    }
    
    func getCityData(indexPath:IndexPath) -> (CityClass)
    {
        if self.isSearch == true{
            if(self.searchedResult.count != 0)
            {
                return self.searchedResult[indexPath.row]
            }
        }
        return self.citiesArray[indexPath.row]
    }
    
    //MARK:- Location Manager  Delegates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations[0].coordinate)
        
        currentLocation = locations[0].coordinate
        citiesTableView.reloadData()
    }
}




