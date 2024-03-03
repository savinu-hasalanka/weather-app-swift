//
//  WeatherMapViewModel.swift
//  CWK2Template
//
//  Created by girish lukka on 29/10/2023.
//

import Foundation
import SwiftUI

import CoreLocation
import MapKit
class WeatherMapViewModel: ObservableObject {
    @Published var weatherDataManager = WeatherDataManager()
    @Published var coordinates: CLLocationCoordinate2D?
    @Published var city = ""
    @Published var favouriteCities: [String] = []
    
    // weather now data
    @Published var weatherNowDescription = ""
    @Published var weatherNowTemperature = 0.0
    @Published var weatherNowHumidity = 0
    @Published var weatherNowPressure = 0
    @Published var weatherNowWindspeed = 0.0
    @Published var weatherNowIconURL = URL(string: "https://openweathermap.org/img/wn/10d@2x.png")
    
    // weather forecast data
    @Published var weatherHourly: [Current] = []
    @Published var weatherDaily: [Daily] = []
    
    @Published var formattedDate = ""
    
    init() {
        weatherDataManager = WeatherDataManager()
//        print("")
        
        Task {
            do {
                try await fetchNewData(newCity: "London")
                print("Successfully initialised")
            } catch {
                print("Error Occured while initialisng")
            }

        }
    }
    
    func fetchNewData(newCity: String) async throws {
        print("City that was passed into fetchData(): \(newCity)")
        do {
            try await weatherDataManager.refresh(city: newCity)
        } catch  {
            throw error
        }
        await MainActor.run {
//            weatherDataModel = weatherDataManager?.weatherDataModel
            updateCurrentData()
            updateDateTime()
            self.city = weatherDataManager.city ?? ""
            self.coordinates = weatherDataManager.coordinates
            self.weatherHourly = weatherDataManager.weatherDataModel?.hourly ?? []
            self.weatherDaily = weatherDataManager.weatherDataModel?.daily ?? []
//            self.region = weatherDataManager.region ?? MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.5072, longitude: -0.1276), latitudinalMeters: 600, longitudinalMeters: 600)
            print("Updated")
            print("City: \(city)")
            print("Temperature: \(weatherNowTemperature)")
        }
        
    }
    
    func updateCurrentData() {
        if let forecast = weatherDataManager.weatherDataModel {
            weatherNowDescription = forecast.current.weather[0].weatherDescription.rawValue
            weatherNowTemperature = forecast.current.temp
            weatherNowHumidity = forecast.current.humidity
            weatherNowPressure = forecast.current.pressure
            weatherNowWindspeed = forecast.current.windSpeed
            weatherNowWindspeed = forecast.current.windSpeed
            let weatherIconID = forecast.current.weather[0].icon
            let weatherIconURLString = "https://openweathermap.org/img/wn/\(weatherIconID)@2x.png"
            weatherNowIconURL = URL(string: weatherIconURLString)
            print("Weather Icon URL from VM: \(weatherNowIconURL!)")
        }
    }
    
    func updateDateTime() {
        let timestamp = TimeInterval(self.weatherDataManager.weatherDataModel?.current.dt ?? 0)
        self.formattedDate = DateFormatterUtils.formattedDateTime(from: timestamp)
 
        print("Formated Date from updateDateTime(): \(self.formattedDate)")
        
    }
    
    func fetchTouristLocations() -> [Location] {
        let data = weatherDataManager.loadLocationsFromJSONFile(cityName: "")
        return data?.filter {$0.cityName == self.city} ?? []
    }
    
    func addToFavourites(cityName: String) {
        if !favouriteCities.contains(cityName) {
            favouriteCities.append(cityName)
        }
    }
    
    func isFavourite(cityName: String) -> Bool {
        return favouriteCities.contains(cityName)
    }
    
    func removeFromFavourites(cityName: String) {
        if favouriteCities.contains(cityName) {
            let index = favouriteCities.firstIndex(of: cityName)
            favouriteCities.remove(at: index!)   
        }
    }
    
}


