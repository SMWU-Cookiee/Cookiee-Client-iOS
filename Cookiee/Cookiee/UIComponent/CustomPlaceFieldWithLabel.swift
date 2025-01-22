//
//  CustomPlaceFieldWithLabel.swift
//  Cookiee
//
//  Created by minseo Kyung on 1/23/25.
//

import SwiftUI

struct CustomPlaceFieldWithLabel: View {
    var label: String
    @Binding var text: String
    var placeholder: String
    @ObservedObject var locationSearchService: EventMapLocationSearchViewModel
    @Binding var place: EventWherePlace?
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(label)
                    .font(.Body1_M)
                    .foregroundStyle(Color.Gray05)
                    .frame(width: 75, alignment: .leading)
                
                Spacer()
                NavigationLink(
                    destination: EventMapLocationSearchView(
                        locationSearchService: locationSearchService,
                        selectedLocationData: $place
                    ),
                    label: {
                        Image("MapIcon")
                    }
                )
            }
            
            CustomTextField(target: $text, placeholder: placeholder)
                .focused($isFocused)
        }
        .padding(.bottom, 25)
    }
}
