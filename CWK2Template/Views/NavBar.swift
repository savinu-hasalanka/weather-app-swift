//
//  NavBar.swift
//  CWK2Template
//
//  Created by girish lukka on 29/10/2023.
//

import SwiftUI

struct NavBar: View {
    @EnvironmentObject var weatherMapViewModel: WeatherMapViewModel
    @State private var selection: Int = 0
    var body: some View {
        TabView (selection: $selection) {
            Group {
                WeatherNowView()
                    .tabItem {
                        Label("City", systemImage: "magnifyingglass")
                    }
                    .tag(0)
                WeatherForecastView()
                    .tabItem {
                        Label("Forecast", systemImage: "calendar")
                    }
                    .tag(1)
                TouristPlacesMapView()
                    .tabItem {
                        Label("Place Map", systemImage: "map")
                    }
                    .tag(2)
                    
                FavouriteCityView(selection: $selection)
                    .tabItem {
                        Label("Favourites", systemImage: "heart")
                    }
                    .tag(3)
                    .tint(.brown)
            }
            .toolbarBackground(.visible, for: .tabBar)
        }
        .tint(Color("mainBrown"))
    }
}

struct NavBar_Previews: PreviewProvider {
    static var previews: some View {
        NavBar()
            .environmentObject(WeatherMapViewModel())
        
    }
}

