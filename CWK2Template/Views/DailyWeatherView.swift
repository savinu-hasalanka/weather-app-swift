//
//  DailyWeatherView.swift
//  CWK2Template
//
//  Created by girish lukka on 02/11/2023.
//

import SwiftUI

struct DailyWeatherView: View {
    @State var weatherDescription: String
    @State var date: String
    @State var maxTemperature: String
    @State var minTemperature: String
    @State var url: URL
    
    var body: some View {
        
        HStack {
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                    
                case .success(let returnedImage):
                    returnedImage
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .background(Color("mainBrown"))
                        .cornerRadius(15)
                    
                case .failure:
                    Image(systemName: "questionmark.app")
                    
                default:
                    Image(systemName: "questionmark.app")
                }
            }
            Spacer()
            VStack (alignment: .leading) {
                Text(date)
                    .bold()
                Text(weatherDescription)
                    .foregroundColor(.gray)
            }
            .frame(width: 140)
            
            Spacer()
            Text("\(maxTemperature)°C / \(minTemperature)°C")
                
        }
        .padding(.vertical, 10)
        

    }
}

struct DailyWeatherView_Previews: PreviewProvider {
    static var day = WeatherMapViewModel().weatherDaily
    static var previews: some View {
        DailyWeatherView(
            weatherDescription: "Moderate Rain",
            date: "Wednessday 18",
            maxTemperature: "15",
            minTemperature: "16",
            url: URL(string: "https://openweathermap.org/img/wn/10d@2x.png")!
        )
            
    }
}
