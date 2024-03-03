//
//  WeatherForcastView.swift
//  CWK2Template
//
//  Created by girish lukka on 29/10/2023.
//

import SwiftUI

struct WeatherForecastView: View {
    @EnvironmentObject var weatherMapViewModel: WeatherMapViewModel
    
    var body: some View {
        
        NavigationView {
            ScrollView {
                VStack (alignment: .leading) {
                    Text("Hourly Weather")
                        .font(.title)
                        .bold()
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(weatherMapViewModel.weatherHourly) {
                                HourWeatherView(
                                    dateTime: DateFormatterUtils.formattedDateWithDay(from: TimeInterval($0.dt)),
                                    temperature: "\($0.temp)",
                                    weatherDescription: $0.weather[0].weatherDescription.rawValue,
                                    url: URL(string: "https://openweathermap.org/img/wn/\($0.weather[0].icon)@2x.png")!
                                )
                            }
                        }
                    } // Horizontal Scroll View
                    
                    VStack (alignment: .leading) {
                        Text("Daily Weather")
                            .font(.title)
                            .bold()
                        ScrollView {
                            ForEach(weatherMapViewModel.weatherDaily) {
                                DailyWeatherView(
                                    weatherDescription: $0.weather[0].weatherDescription.rawValue,
                                    date: DateFormatterUtils.formattedDateWithWeekdayAndDay(from: TimeInterval($0.dt)),
                                    maxTemperature: "\($0.temp.max)",
                                    minTemperature: "\($0.temp.min)",
                                    url: URL(string: "https://openweathermap.org/img/wn/\($0.weather[0].icon)@2x.png")!
                                )
                                
                            }
                        }
                        .listStyle(GroupedListStyle())
                        .frame(height: 500)
                    }
//                    .padding()
                    .padding(.top, 50)
                }
                .padding(3)
                
                
            } // Main Scroll View
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Image(systemName: "sun.min.fill")
                        Text("Weather Forecast for: \(weatherMapViewModel.city)")
                    }.padding()
                    
                }
            }
        }
        .padding()
    }
    
}

struct WeatherForcastView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherForecastView()
            .environmentObject(WeatherMapViewModel())
    }
}
