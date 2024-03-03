//
//  HourWeatherView.swift
//  CWK2Template
//
//  Created by girish lukka on 02/11/2023.
//

import SwiftUI

struct HourWeatherView: View {
    @EnvironmentObject var weatherMapViewModel: WeatherMapViewModel
    @State var dateTime: String
    @State var temperature: String
    @State var weatherDescription: String
    @State var url: URL
    

    var body: some View {
        VStack(spacing: 20) {
            Text(dateTime)
                .foregroundStyle(.white)
                .bold()
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                    
                case .success(let returnedImage):
                    returnedImage
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .background(.white)
                        .cornerRadius(15)
                    
                case .failure:
                    Image(systemName: "questionmark.app")
                    
                default:
                    Image(systemName: "questionmark.app")
                }
            }
            VStack {
                Text("\(temperature) °C")
                Text(weatherDescription)
            }
            .foregroundStyle(.white)
            .bold()
        }
        .padding(25)
        .frame(width: 180, height: 200)
        .background(Color("mainBrown"))
        .cornerRadius(20)
    }
}

struct HourWeatherView_Previews: PreviewProvider {
    static var previews: some View {
        HourWeatherView(
            dateTime: "6PM Wed",
            temperature: "14",
            weatherDescription: "Light Rain",
            url: URL(string: "https://openweathermap.org/img/wn/10d@2x.png")!
        )
            .environmentObject(WeatherMapViewModel())
    }
}






