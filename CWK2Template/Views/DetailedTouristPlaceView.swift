//
//  DetailedTouristPlaceView.swift
//  CWK2Template
//
//  Created by Savinu Hasalanka on 09/01/2024.
//

import SwiftUI

struct DetailedTouristPlaceView: View {
    @State var location: Location
    
    var body: some View {
        VStack {
            Text(location.name)
                .font(.title)
                .bold()
            Image(location.imageNames[0])
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 300)
            Spacer()
            Text(location.description)
                .font(.title2)
            Spacer()
            Button {
                print("Image tapped!")
                if let url = URL(string: location.link) {
                    UIApplication.shared.open(url)
                }
            } label: {
                Text("Explore more !")
                    .frame(width: 200, height: 60)
                    .foregroundColor(.white)
                    .bold()
                    .background(Color("mainBrown"))
                    .clipShape(.capsule)
            }
            
        }
        .padding()
    }
}

//#Preview {
//    DetailedTouristPlaceView()
//}
