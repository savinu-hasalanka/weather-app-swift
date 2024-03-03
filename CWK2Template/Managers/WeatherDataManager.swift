//
//  WeatherDataManager.swift
//  CWK2Template
//
//  Created by Savinu Hasalanka on 07/01/2024.
//

import Foundation
import CoreLocation
import MapKit

public enum WeatherError: Error {
    case invalidLocation
    case invalidURL
    case failedToDecodeJSON
    case noNetworkConnection
    case defaultError
}

class WeatherDataManager: ObservableObject {
    var coordinates: CLLocationCoordinate2D?
    private var region: MKCoordinateRegion = MKCoordinateRegion()
    @Published var city: String?
    @Published var weatherDataModel: WeatherDataModel?
    
//    init(city: String) async {
//        await refresh(city: city)
//    }
    
    func foo() {
        print("Foooo")
    }
    
    
    
    func refresh(city: String) async throws {
        print("Helloooo")
        print("City from Refresh: \(city)")
        do {
            try await getCoordinatesForCity(city: city)
            print("Latitude that's ging pass into loadData(): \(self.coordinates?.latitude ?? 12345.67)")
            print("Longitude that's ging pass into loadData(): \(self.coordinates?.longitude ?? 12345.67)")
            let weatherData = try await loadData(lat: coordinates?.latitude ?? 51.503300, lon: coordinates?.longitude ?? -0.079400)
            self.city = city
//            print("WeatherDataModel from refresh(): \(weatherDataModel)")
            print("City from refresh: \(self.city ?? "Empty City")")
            print("Latitude from Refresh: \(self.coordinates?.latitude ?? 12345.67)")
            print("Longitude from Refresh: \(self.coordinates?.longitude ?? 12345.67)")
            print("Updated city from Refresh: \(self.city ?? "Some value .......")")
            print("The most lastest temperature from refesh: \(weatherData.current.temp)")
            print("The most lastest temperature from refesh (weatherDataModel): \(weatherDataModel!.current.temp)")
            print("Weather data loaded: \(String(describing: weatherData.timezone))")
            
        } catch {
            // Handle errors if necessary
            print("City from refresh CATCH CLAUSE: \(self.city ?? "Empty City")")
            print("Error loading weather data: \(error)")
            throw error
        }
    }
    
    func getCoordinatesForCity(city: String) async throws {
        // MARK:  complete the code to get user coordinates for user entered place
        // and specify the map region
        
        let geocoder = CLGeocoder()
        if let placemarks = try? await geocoder.geocodeAddressString(city),
           let location = placemarks.first?.location?.coordinate {
            
            DispatchQueue.main.async {
                self.coordinates = location
                print("Latitude: \(self.coordinates?.latitude ?? 12345.67)")
                print("Longitude: \(self.coordinates?.longitude ?? 12345.67)")
                self.region = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            }
        } else {
            // Handle error here if geocoding fails
            print("Error: Unable to find the coordinates for the club.")
            throw WeatherError.invalidLocation
            
        }
    }
    
    func loadData(lat: Double, lon: Double) async throws -> WeatherDataModel {
        print("Latitude that was passed into loadData(): \(self.coordinates?.latitude ?? 12345.67)")
        print("Longitude that was passed into loadData(): \(self.coordinates?.longitude ?? 12345.67)")
        // MARK:  add your appid in the url below:
        if let url = URL(string: "https://api.openweathermap.org/data/3.0/onecall?lat=\(lat)&lon=\(lon)&units=metric&appid=889398029281a0d748e9795454b16980") {
            let session = URLSession(configuration: .default)
            
            print("https://api.openweathermap.org/data/3.0/onecall?lat=\(lat)&lon=\(lon)&units=metric&appid=889398029281a0d748e9795454b16980")
            
            do {
                let (data, _) = try await session.data(from: url)
                
                let weatherDataModel = try JSONDecoder().decode(WeatherDataModel.self, from: data)
                print("Weather weather: \(weatherDataModel.current.temp)")
                DispatchQueue.main.async {
                    self.weatherDataModel = weatherDataModel
                    
                    print("The most lastest temperature from loadData() (weatherDataModel): \(self.weatherDataModel!.current.temp)")
                    print("weatherDataModel loaded")
                }
                
                
                // MARK:  The code below is to help you see number of records and different time stamps that has been retrieved as part of api response.
                
                print("MINUTELY")
                if let count = weatherDataModel.minutely?.count {
                    if let firstTimestamp = weatherDataModel.minutely?[0].dt {
                        let firstDate = Date(timeIntervalSince1970: TimeInterval(firstTimestamp))
                        let formattedFirstDate = DateFormatterUtils.shared.string(from: firstDate)
                        print("First Timestamp: \(formattedFirstDate)")
                    }
                    
                    if let lastTimestamp = weatherDataModel.minutely?[count - 1].dt {
                        let lastDate = Date(timeIntervalSince1970: TimeInterval(lastTimestamp))
                        let formattedLastDate = DateFormatterUtils.shared.string(from: lastDate)
                        print("Last Timestamp: \(formattedLastDate)")
                    }
                } // minute
                
                print("Hourly start")
                
                let hourlyCount = weatherDataModel.hourly.count
                print(hourlyCount)
                if hourlyCount > 0 {
                    let firstTimestamp = weatherDataModel.hourly[0].dt
                    let firstDate = Date(timeIntervalSince1970: TimeInterval(firstTimestamp))
                    let formattedFirstDate = DateFormatterUtils.shared.string(from: firstDate)
                    print("First Hourly Timestamp: \(formattedFirstDate)")
                    print("Temp in first hour: \(weatherDataModel.hourly[0].temp)")
                }
                
                if hourlyCount > 0 {
                    let lastTimestamp = weatherDataModel.hourly[hourlyCount - 1].dt
                    let lastDate = Date(timeIntervalSince1970: TimeInterval(lastTimestamp))
                    let formattedLastDate = DateFormatterUtils.shared.string(from: lastDate)
                    print("Last Hourly Timestamp: \(formattedLastDate)")
                    print("Temp in last hour: \(weatherDataModel.hourly[hourlyCount - 1].temp)")
                }
                
                print("//Hourly Complete")
                
                print("Daily start")
                let dailyCount = weatherDataModel.daily.count
                print(dailyCount)
                
                if dailyCount > 0 {
                    let firstTimestamp = weatherDataModel.daily[0].dt
                    let firstDate = Date(timeIntervalSince1970: TimeInterval(firstTimestamp))
                    let formattedFirstDate = DateFormatterUtils.shared.string(from: firstDate)
                    print("First daily Timestamp: \(formattedFirstDate)")
                    print("Temp for first day: \(weatherDataModel.daily[0].temp)")
                }
                
                if dailyCount > 0 {
                    let firstTimestamp = weatherDataModel.daily[dailyCount-1].dt
                    let firstDate = Date(timeIntervalSince1970: TimeInterval(firstTimestamp))
                    let formattedFirstDate = DateFormatterUtils.shared.string(from: firstDate)
                    print("Last daily Timestamp: \(formattedFirstDate)")
                    print("Temp for last day: \(weatherDataModel.daily[dailyCount-1].temp)")
                }
                print("//daily complete")
                return weatherDataModel
            } catch {
                
                if let decodingError = error as? DecodingError {
                    print("Decoding error: \(decodingError)")
                    throw WeatherError.failedToDecodeJSON
                } else {
                    //  other errors
                    print("Error: \(error)")
                }
                throw error // Re-throw the error to the caller
            }
        } else {
            throw WeatherError.invalidURL
        }
    }
    
    
    func loadLocationsFromJSONFile(cityName: String) -> [Location]? {
        if let fileURL = Bundle.main.url(forResource: "places", withExtension: "json") {
            do {
                let data = try Data(contentsOf: fileURL)
                let decoder = JSONDecoder()
                let allLocations = try decoder.decode([Location].self, from: data)
                
                return allLocations
            } catch {
                print("Error decoding JSON: \(error)")
            }
        } else {
            print("File not found")
        }
        return nil
    }
}
