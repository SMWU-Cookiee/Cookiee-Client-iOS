//
//  CustomPlaceFieldWithLabel.swift
//  Cookiee
//
//  Created by minseo Kyung on 1/23/25.
//

import SwiftUI

struct CustomPlaceFieldWithLabel: View {
    var label: String
    @Binding var placeText: String
    var placeholder: String
    @ObservedObject var locationSearchService: EventMapLocationSearchViewModel
    @Binding var place: EventWherePlace?
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(label)
                    .font(.Body1_M)
                    .foregroundStyle(Color.Brown02)
                    .frame(width: 75, alignment: .leading)
                
                Spacer()
                NavigationLink(
                    destination: EventMapLocationSearchView(
                        locationSearchService: locationSearchService,
                        selectedLocationData: $place,
                        placeText: $placeText
                    ),
                    label: {
                        Image("MapIcon")
                    }
                )
            }
            
            if place == nil {
                CustomTextField(target: $placeText, placeholder: placeholder)
                    .focused($isFocused)
            } else {
                HStack {
                    Image("PlacePinBrown")
                    Text("\(String(describing: place!.name))")
                        .font(.Body0_M)
                        .foregroundStyle(Color.Brown00)
                    Spacer()
                    Button(action: {
                        place = nil
                    }, label: {
                        Image("XmarkSmall")
                            .padding(.horizontal, 3)
                    })
                }
                .padding(10)
                .frame(maxWidth: .infinity, maxHeight: 40)
                .background(Color.white)
                .cornerRadius(5)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.Brown02, lineWidth: 1)
                )
            }
            
        }
        .padding(.bottom, 25)
    }
}
