//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Prakash maripalli on 5/18/23.
//

import Foundation

class WeatherViewModel {
    /// Fetching the weather data based on the query
    func fetchWeatherData(query: String?) async -> (WeatherData?, ErrorResponse?) {
        
        guard let url = URL(string: ApiConstants.EndPoint) else { return (nil, .init(cod: "", message: "Invalid URL string"))}
        
        /// Prepare url components
        var components = URLComponents()
        components.scheme = url.scheme
        components.host = url.host
        components.path = url.path
            components.queryItems = [
                URLQueryItem(name: "q", value: query),
                URLQueryItem(name: "appid", value: AppConstants.APIKey)
            ]

            // Getting a URL from our components is as simple as
            // accessing the 'url' property.
            let finalUrl = components.url
        
        do {
            let (data, response) = try await URLSession.shared.data(from: finalUrl!)
            
            /// handle response
            if let response = response as? HTTPURLResponse {
                if response.statusCode == 200 {
                    /// on success decode to Weather data model
                    return (try JSONDecoder().decode(WeatherData.self, from: data), nil)
                }else if response.statusCode == 404 {
                    /// on failure decode to Error response model
                    return (nil, try JSONDecoder().decode(ErrorResponse.self, from: data))
                }
            }
        }catch {
            /// handle error
            return (nil, .init(cod: nil, message: error.localizedDescription))
        }
        
        return (nil, nil)
    }
}
