//
//  FavouriteCityView.swift
//  CWK2Template
//
//  Created by Savinu Hasalanka on 09/01/2024.
//

import SwiftUI

struct FavouriteCityView: View {
    @EnvironmentObject var weatherMapViewModel: WeatherMapViewModel
    @Binding var selection: Int
    @State var isLoading = true
    
    var body: some View {
        
        VStack {
            Text("Favourite Cities")
                .font(.title)
                .bold()
            
            if weatherMapViewModel.favouriteCities.isEmpty {
                Spacer()
                Text("Sorry, No favourite cities currently 🤷‍♂️")
                    .font(.title3)
                    .bold()
                    .padding()
                Spacer()
            }
            
            List {
                ForEach(weatherMapViewModel.favouriteCities, id: \.self) { city in
                    HStack {
                        Text(city)
                            .font(.system(size: 20))
                            .hoverEffect(.lift)
                        Spacer()
                        Image(systemName: "heart.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.red)
                    }
                    .padding(5)
                    .onTapGesture {
                        print("Tapped fav")
                        Task {
                            do {
                                try? await weatherMapViewModel.fetchNewData(newCity: city)
                                print(weatherMapViewModel.city)
                                selection = 0
                            }
                        }
                    }
                }
            }
        }
    }
}
//
//#Preview {
//    FavouriteCityView()
//        .environmentObject(WeatherMapViewModel())
//}

struct FavouriteCityViewPreviews : PreviewProvider {
    
    static var previews: some View {
        FavouriteCityView(selection: .constant(3))
            .environmentObject(WeatherMapViewModel())
    }
    
}
