//
//  LocationViewModel.swift
//  Weather
//
//  Created by Prakash maripalli on 5/19/23.
//

import UIKit
import CoreLocation

class LocationViewModel: NSObject {
    
    //MARK: Private Variables
    private var completionHandler: ((String) -> Void)?
    private var locationManager: CLLocationManager?
    private let geoCoder = CLGeocoder()
    private var didUpdateLocation = false

    //MARK: Initializers
    override init() {
        super.init()
        setupLocationManager()
    }
    
    required init(completion: @escaping (String) -> Void) {
        super.init()
        setupLocationManager()
        self.completionHandler = completion
    }
    //MARK: Initialize LocationManager
    private func setupLocationManager() {
        let manager = CLLocationManager()
        manager.delegate = self
        manager.requestAlwaysAuthorization()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager = manager
    }
    //Force update location
    func updateLocations() {
        didUpdateLocation = false
        locationManager?.startUpdatingLocation()
    }
}

extension LocationViewModel: CLLocationManagerDelegate {
    //MARK: CLLocationManagerDelegate function
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        ///Avoiding Multipule location updates
        
        if let location  = locations.first, !didUpdateLocation {
            ///Reverse geo code location to get exact locality
            geoCoder.reverseGeocodeLocation(location) { placemarks, error in
                if let place = placemarks?.first {
                    self.completionHandler?(place.locality ?? "")
                    ///Stop updating location
                    self.didUpdateLocation = true
                    manager.stopUpdatingLocation()
                }
            }
        }
    }

}
