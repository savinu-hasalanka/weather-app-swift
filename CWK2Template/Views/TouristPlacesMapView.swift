//
//  TouristPlacesMapView.swift
//  CWK2Template
//
//  Created by girish lukka on 29/10/2023.
//

import Foundation
import SwiftUI
import CoreLocation
import MapKit

struct TouristPlacesMapView: View {
    @EnvironmentObject var weatherMapViewModel: WeatherMapViewModel
    @State var locations: [Location] = []
    @State var mapRegion = MKCoordinateRegion()

    var body: some View {
        NavigationView {
            VStack(spacing: 5) {
                
                Map(coordinateRegion: $mapRegion,
                            annotationItems: locations)
                        { place in
                            MapMarker(coordinate: place.coordinates,
                                   tint: Color.purple)
                        }
                        .edgesIgnoringSafeArea(.all)
                        .frame(height: 300)
                
                Spacer()
                
                Text("Tourist Attraction in \(weatherMapViewModel.city)")
                    .font(.title2)
                    .bold()
                    .padding()
                
                if locations.isEmpty {
                    Text("Sorry, No available data 🤷‍♂️")
                        .font(.title3)
                        .bold()
                        .padding()
                } else {
                    List {
                        ForEach(locations) { location in
//                            TouristPlaceView(imageName: $0.imageNames[0], placeName: $0.name)
                            NavigationLink {
                                DetailedTouristPlaceView(location: location)
                            } label: {
                                TouristPlaceView(imageName: location.imageNames[0], placeName: location.name)
                            }
                        }
                        
                        
                    }
                    .listStyle(.plain)
                    .padding()
                }
                
                Spacer()
                
            }
        }
        .onAppear {
            mapRegion = MKCoordinateRegion(
                center: CLLocationCoordinate2D(
                    latitude: weatherMapViewModel.coordinates?.latitude ?? 51.5072,
                    longitude: weatherMapViewModel.coordinates?.longitude ?? -0.1276
                ),
                latitudinalMeters: 5000,
                longitudinalMeters: 5000
            )
            locations = weatherMapViewModel.fetchTouristLocations()
        }
    }
}




struct TouristPlacesMapView_Previews: PreviewProvider {
    static var previews: some View {
        TouristPlacesMapView()
            .environmentObject(WeatherMapViewModel())
    }
}
