//
//  TouristPlaceView.swift
//  CWK2Template
//
//  Created by Savinu Hasalanka on 08/01/2024.
//

import SwiftUI

struct TouristPlaceView: View {
    @State var imageName: String
    @State var placeName: String
    
    var body: some View {
        HStack(spacing: 20) {
            Image(imageName)
                .resizable()
                .frame(width: 100, height: 120)
                .cornerRadius(10)
            Text(placeName)
        }
    }
}

#Preview {
    TouristPlaceView(imageName: "london-museum-1", placeName: "London Musuem")
}
