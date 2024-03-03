//
//  NewWeatherNowView.swift
//  CWK2Template
//
//  Created by Savinu Hasalanka on 09/01/2024.
//

import SwiftUI

struct WeatherNowView: View {
    @EnvironmentObject var weatherMapViewModel: WeatherMapViewModel
    @State var cityName = ""
    
    @State private var showAlert = false
    @State private var alertType: WeatherError? = nil
    
    @State private var favourite: Bool = false
    
    var body: some View {
            VStack (alignment: .leading) {
                VStack (alignment: .leading)  {
                    
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 23))
                        
                        TextField("Enter location", text: $cityName)
                            .font(.system(size: 20, weight: .regular))
                            .foregroundStyle(.black)
                            .background(.white)
                            .cornerRadius(4.0)
                            .frame(width: 300)
                            .onSubmit {
                                print(cityName)
                                refreshUI(cityName: cityName)
                            }
                    
                    }
                    
                    Spacer()
                    
                    HStack {
                        
                        VStack (alignment: .leading) {
                            Text("\(weatherMapViewModel.city)")
                                .font(.system(size: 50))
                                .bold()
                            Text("\(weatherMapViewModel.formattedDate)")
                                .font(.system(size: 15))
                        }
                        
                        Spacer()
                        Button {
                            favourite.toggle()
                            favourite ? weatherMapViewModel.addToFavourites(cityName: weatherMapViewModel.city) : weatherMapViewModel.removeFromFavourites(cityName: weatherMapViewModel.city)
                            
                            print(weatherMapViewModel.favouriteCities)
                            
                        } label: {
                            Image(systemName: "heart.fill")
                                .font(.system(size: 40))
                                .foregroundColor(favourite ? .red : .white)
                        }
                        
                    }
                    .padding(.trailing)
                    
                    
                    Spacer()
                    
                    VStack (alignment: .leading, spacing: 0) {
                        Text(String(format: "%.0f°C", weatherMapViewModel.weatherNowTemperature))
                            .font(.system(size: 70))
                            .bold()
                        HStack {
                            AsyncImage(url: weatherMapViewModel.weatherNowIconURL) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                    
                                case .success(let returnedImage):
                                    returnedImage
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 40)
                                        .background(.white)
                                        .opacity(0.7)
                                        .cornerRadius(3.0)
                                    
                                case .failure:
                                    Image(systemName: "questionmark.app")
                                    
                                default:
                                    Image(systemName: "questionmark.app")
                                }
                            }
                            Text(weatherMapViewModel.weatherNowDescription.capitalized)
                                .font(.system(size: 20))
                                .bold()
                        }
                    }
                    .padding(.top, 150)
                    Spacer()
                }
                .padding(.leading, 40)
                .padding(.top, 50)
                
                Divider()
                    .frame(maxWidth: 600, minHeight: 1.5, alignment: .leading)
                    .overlay(Color.gray)
                
                BottomViewPanel()
        }
        .foregroundStyle(.white)
        .background(
            Image("new_background")
                .blur(radius: 3.0)
                .brightness(-0.2)
                .ignoresSafeArea(.keyboard)
        )
        .onAppear {
            favourite = weatherMapViewModel.isFavourite(cityName: weatherMapViewModel.city)
        }
        .alert(isPresented: $showAlert, content: {
            getAlert()
        })
        
    }
    
    func refreshUI(cityName: String) {
        Task {
            do {
                try await weatherMapViewModel.fetchNewData(newCity: cityName)
                favourite = weatherMapViewModel.isFavourite(cityName: cityName)
                
            } catch WeatherError.invalidLocation {
                alertType = .invalidLocation
                showAlert.toggle()
                
            } catch WeatherError.invalidURL {
                alertType = .invalidURL
                showAlert.toggle()
                
            } catch WeatherError.failedToDecodeJSON {
                alertType = .failedToDecodeJSON
                showAlert.toggle()
                
            } catch  {
                alertType = .defaultError
                showAlert.toggle()
            }
            self.cityName = ""
        }
    }
    
    
    func getAlert() -> Alert {
        print("get alert was called")
        switch alertType {
        case .invalidLocation:
            return Alert(title: Text("Invalid Location"))
        case .invalidURL:
            return Alert(title: Text("Invalid URL"))
        case .failedToDecodeJSON:
            return Alert(title: Text("Decoding failed. Contact your developer."))
        case .defaultError:
            return Alert(title: Text("Error"))
        default:
            return Alert(title: Text("Error"))
        }
    }
    
}

struct BottomViewPanel: View {
    @EnvironmentObject var weatherMapViewModel: WeatherMapViewModel
    
    var body: some View {
        HStack {
            VStack (spacing: 15) {
                Text("Wind")
                    .font(.system(size: 15))
                    .bold()
                Text(String(format: " %.0f ", weatherMapViewModel.weatherNowWindspeed))
                    .font(.system(size: 30))
                    .bold()
                Text("mph")
                    .font(.system(size: 15))
                    .bold()
                ProgressView(value: weatherMapViewModel.weatherNowWindspeed, total: 100)
                    .scaleEffect(x: 1.5, y: 2, anchor: .center)
                    .frame(width: 50)
                    .tint(weatherMapViewModel.weatherNowWindspeed > 25 ? .red : .green)
            }
            
            Spacer()
            
            VStack (spacing: 15) {
                Text("Humidity")
                    .bold()
                    .font(.system(size: 15))
                Text(" \(weatherMapViewModel.weatherNowHumidity) ")
                    .font(.system(size: 30))
                    .bold()
                Text("%")
                    .font(.system(size: 15))
                    .bold()
                ProgressView(value: Double(weatherMapViewModel.weatherNowHumidity), total: 100)
                    .scaleEffect(x: 1.5, y: 2, anchor: .center)
                    .frame(width: 50)
                    .tint(weatherMapViewModel.weatherNowHumidity > 50 ? .red : .green)
            }
            
            Spacer()
            
            VStack (spacing: 15) {
                Text("Pressure")
                    .bold()
                    .font(.system(size: 15))
                Text("\(weatherMapViewModel.weatherNowPressure)")
                    .font(.system(size: 30))
                    .bold()
                Text("hPa")
                    .font(.system(size: 15))
                    .bold()
                ProgressView(value: 40, total: 100)
                    .scaleEffect(x: 1.5, y: 2, anchor: .center)
                    .frame(width: 50)
                    .tint(weatherMapViewModel.weatherNowPressure > 1400 ? .red : .green)
            }
        }
        .padding(40)
        .frame(height: 200)
    }
}

#Preview {
    WeatherNowView()
        .environmentObject(WeatherMapViewModel())
}
