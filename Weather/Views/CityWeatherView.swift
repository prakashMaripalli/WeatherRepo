//
//  CityWeatherView.swift
//  Weather
//
//  Created by Prakash maripalli on 5/18/23.
//

import SwiftUI
import SDWebImageSwiftUI

enum WeatherConditionType {
    case tempMax, tempMin, humid, wind, pressure
}
struct CityWeatherView: View {
    var weatherData: WeatherData?
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color("bgColor"), Color("bgColor").opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            ScrollView {
                VStack {
                    if let weatherData = weatherData {
                        /// Location name
                        Text(weatherData.name ?? "")
                            .font(.system(size: 35))
                            .foregroundColor(.white)
                        /// Location Temparature
                        Text("\(Int(weatherData.main?.temp ?? 0.0))".degreeCelciusSymbol)
                            .font(.system(size: 55))
                            .foregroundColor(.white)
                        /// Current Weather condition
                        HStack {
                            WebImage(url: iconUrl)
                               .resizable()
                               .scaledToFit()
                               .frame(width: 40, height: 40)
                            Text("\(weatherData.weather?.first?.main ?? "")")
                                .font(.title)
                                .foregroundColor(.white)
                        }
                        /// Min and Max temparature
                        HStack(spacing: 30) {
                            Feature(condition: .tempMax, value: weatherData.main?.tempMax ?? 0.0)
                            Divider()
                                .frame(height:30)
                            Feature(condition: .tempMin, value: weatherData.main?.tempMin ?? 0.0)
                        }
                        .foregroundColor(.white)
                        /// Humid, Wind , Pressure
                        VStack(spacing: 0) {
                            Feature(condition: .humid, value: Double(weatherData.main?.humidity ?? 0))
                                .padding(.vertical)
                            Divider()
                            Feature(condition: .wind, value: weatherData.wind?.speed ?? 0)
                                .padding(.vertical)
                            Divider()
                            Feature(condition: .pressure, value: Double(weatherData.main?.pressure ?? 0))
                                .padding(.vertical)
                        }
                        .padding()
                        .foregroundColor(.black)
                        .background(Color.white)
                        .cornerRadius(8)
                        .padding()
                    }
                    
                    Spacer()
                }
            }
        }
    }
    /// Current weather condition icon.
    private var iconUrl: URL {
        if let icon = weatherData?.weather?.first?.icon, let url = URL(string: "\(ApiConstants.IconUrl)/\(icon)@2x.png") {
            return url
        }
        return URL(string: "")!
    }

   private func weather(conditionType: WeatherConditionType, value: Double) -> (String, String, String) {
        var iconText = ""
        var icon = ""
        var stringBuilder = ""
        switch conditionType {
        case .tempMax:
            icon = "thermometer.sun.fill"
            stringBuilder = "\(Int(value))".degreeCelciusSymbol
        case .tempMin:
            icon = "thermometer.sun"
            stringBuilder = "\(Int(value))".degreeCelciusSymbol
        case .humid:
            iconText = "Humidity"
            icon = "humidity.fill"
            stringBuilder = "\(Int(value))%"
        case .wind:
            iconText = "Wind"
            icon = "wind"
            stringBuilder = "\(Int(value)) km/h"
        case .pressure:
            iconText = "Pressure"
            icon = "rectangle.compress.vertical"
            stringBuilder = "\(Int(value))%"
        }
        return (iconText, icon, stringBuilder)
    }
    /// Commom function for different weather conditions.
    @ViewBuilder
    private func Feature(condition: WeatherConditionType, value: Double) -> some View {
        let (iconText, icon, title) = weather(conditionType: condition, value: value)
        HStack {
            Image(systemName: icon)
            if condition != .tempMax && condition != .tempMin {
                Text(iconText)
                Spacer()
            }
            Text(title)
        }
        .font((condition == .tempMax || condition == .tempMin) ? .title2 : .title3)
    }
}

struct CityWeatherView_Previews: PreviewProvider {
    static var previews: some View {
        CityWeatherView()
    }
}
