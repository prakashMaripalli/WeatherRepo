//
//  ViewController.swift
//  Weather
//
//  Created by Prakash maripalli on 5/18/23.
//

import UIKit
import CoreLocation
import SwiftUI

class SearchViewController: UIViewController {
   
    //MARK: Outlets
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var currentLocationButton: UIButton!
    
    //MARK: Private Variables
    private var locationViewModel: LocationViewModel!
    
    //MARK: ViewLife Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        /// Instantiate location ViewModel to create location  manager and to get completion
        locationViewModel = LocationViewModel(completion: { place in
            self.fetchWeatherData(query: place)
        })
        /// Prefill last searched city
        if let lastLocation = UserDefaults.standard.value(forKey: AppConstants.lastLocation) as? String {
            searchField.text = lastLocation
        }
    }
    
    
    
    @IBAction func searchAction(_ sender: Any) {
        if let searchText = searchField.text, (searchText.trimmingCharacters(in: .whitespaces).isEmpty) {
            showAlert(messae: "Please enter city name or state name")
        }else{
            fetchWeatherData(query: self.searchField.text)
        }
    }
    @IBAction func currentLocationAction(_ sender: Any) {
        locationViewModel.updateLocations()
    }
    
    //MARK: Private menber Functions
    
    
    /// Update view based on the loading state (When fetching weather data)
    private func updateViews(isLoading: Bool) {
        DispatchQueue.main.async {
            if isLoading {
                self.indicatorView.startAnimating()
                self.searchField.isEnabled = false
                self.searchButton.isEnabled = false
                self.currentLocationButton.isEnabled = false
            }else{
                self.indicatorView.stopAnimating()
                self.searchField.isEnabled = true
                self.searchButton.isEnabled = true
                self.currentLocationButton.isEnabled = true
            }
        }
    }
    
    /// Fetch weather data from API based user input
    private func fetchWeatherData(query: String?) {
        updateViews(isLoading: true)
        /// Async Task
        Task {
            let (weatherData, error) = await WeatherViewModel().fetchWeatherData(query: query)
            
            if let weatherData = weatherData {
                DispatchQueue.main.async {
                    ///Update search field with fetched location
                    self.searchField.text = weatherData.name
                    ///Save fetched Location in UserDefaults
                    UserDefaults.standard.set(self.searchField.text, forKey: AppConstants.lastLocation)
                    UserDefaults.standard.synchronize()
                /// Navigate to Weather Details screen
                    let controller = UIHostingController(rootView: CityWeatherView(weatherData: weatherData))
                    self.navigationController?.pushViewController(controller, animated: true)
                }
            }else if let errorMessage = error?.message {
                self.showAlert(messae: errorMessage)
            }
            self.updateViews(isLoading: false)
        }
    }
}
 


