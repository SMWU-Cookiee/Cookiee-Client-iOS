//
//  MapSearchByName.swift
//  Cookiee
//
//  Created by minseo Kyung on 1/14/25.
//

import SwiftUI
import MapKit

struct EventMapLocationSearchView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    // 백 버튼 커스텀
    var backButton: some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            HStack {
                Image("ChevronLeftIconBlack")
                    .aspectRatio(contentMode: .fit)
            }
            .padding(.leading, 5)
        }
    }

    @ObservedObject var locationSearchService: EventMapLocationSearchViewModel
    @State private var selectedLocation: MapLocationDTO? = nil
    @State private var selectedLocationMapData: MapLocationDTO? = nil
    @State private var isPlaceSelected: Bool = false
    @State private var cameraPosition: MapCameraPosition = .camera(.init(centerCoordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0), distance: 1))
    @Binding var selectedLocationData: EventWherePlace?
    @Binding var placeText: String

    var body: some View {
        VStack {
            VStack {
                HStack {
                    backButton
                    EventMapLocationSearchBarUIView(text: $locationSearchService.searchQuery)
                }
                .padding(.bottom, 7)
                .padding(.horizontal, 5)
                .background(Color.white)
            }
            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
            
            ScrollView {
                ForEach(locationSearchService.completions) { completion in
                    Button(action: {
                        searchLocation(for: completion)
                    }, label: {
                        HStack {
                            Image("PlacePin")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .padding(.leading, 15)
                                .padding(.trailing, 2)

                            VStack(alignment: .leading) {
                                
                                Text(completion.title)
                                    .foregroundStyle(Color.black)
                                    .font(Font.Body0_M)
                                    .padding(.bottom, 1)
                                
                                Text(completion.subtitle)
                                    .font(Font.Body1_R)
                                    .foregroundColor(Color.Gray05)
                                    .multilineTextAlignment(.leading)
                                
                            }
                            Spacer()
                        }
                        .padding(.vertical, 3)
                    })
                    Divider()
                }
            }
            
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        
        .sheet(isPresented: $isPlaceSelected, onDismiss: {
            selectedLocationMapData = nil
            selectedLocation = nil
        }, content: {
            VStack {
                if selectedLocationMapData != nil {
                    MapLocationDetailView(region: selectedLocationMapData!, cameraPosition: $cameraPosition, isPlaceSelected: $isPlaceSelected, selectedLocationData: $selectedLocationData, placeText: $placeText, parentPresentationMode: presentationMode)
                } else {
                    ProgressView()
                }
            }
            .padding(.top, 12)
            .presentationDetents([.fraction(0.7)])
            .presentationDragIndicator(.visible)
            .onAppear() {
                selectedLocationMapData = selectedLocation
            }
        })
    }

    func searchLocation(for suggestedCompletion: MKLocalSearchCompletion) {
        let searchRequest = MKLocalSearch.Request(completion: suggestedCompletion)
        selectedLocation = nil
        search(using: searchRequest)
    }

    func search(using searchRequest: MKLocalSearch.Request) {
        searchRequest.resultTypes = .address

        let localSearch = MKLocalSearch(request: searchRequest)

        localSearch.start { (response, error) in
            guard error == nil else { return }

            guard let place = response?.mapItems[0] else { return }

            let placeName = place.name ?? "알 수 없는 장소명"
            let placeAddress = place.placemark.title ?? "알 수 없는 주소"
            let placeLatitude = Double(place.placemark.coordinate.latitude)
            let placeLongtitude = Double(place.placemark.coordinate.longitude)
    
            selectedLocation = MapLocationDTO(
                name: placeName,
                fullAddress: placeAddress,
                latitude: placeLatitude,
                longitude: placeLongtitude
            )
            isPlaceSelected = true
        }
    }

    struct MapLocationDetailView: View {
        var region: MapLocationDTO
        @Binding var cameraPosition: MapCameraPosition
        @Binding var isPlaceSelected: Bool
        @Binding var selectedLocationData: EventWherePlace?
        @Binding var placeText: String
        var parentPresentationMode: Binding<PresentationMode>

        var body: some View {
            VStack {
                HStack {
                    Text("\(region.name) 으로 장소를 추가할까요?")
                        .multilineTextAlignment(.center)
                        .font(Font.Head1_B)
                        .padding(15)
                }

                Map(position: $cameraPosition, bounds: nil, interactionModes: .all, scope: nil) {
                    Annotation("\(region.name)", coordinate: region.coordinate) {
                        Image("CookieePin")
                    }
                }
                .mapControlVisibility(.visible)

                HStack {
                    Button(action: {
                        isPlaceSelected = false
                    }, label: {
                        VStack {
                            Text("취소")
                                .font(Font.Body0_SB)
                                .foregroundStyle(Color.Brown00)
                        }
                    })
                    .frame(width: 120, height: 44)
                    .cornerRadius(10)
                    .overlay(content: {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.Brown00, lineWidth: 1)
                    })

                    Button(action: {
                        placeText = ""
                        isPlaceSelected = false
                        selectedLocationData = EventWherePlace(
                            latitude: region.latitude.description,
                            longitude: region.longitude.description,
                            name: region.name,
                            fullAddress: region.fullAddress
                        )
                        parentPresentationMode.wrappedValue.dismiss()
                    }, label: {
                        VStack {
                            Text("추가하기")
                                .font(Font.Body0_SB)
                                .foregroundStyle(.white)
                        }
                    })
                    .frame(width: 224, height: 44)
                    .background(Color.Brown00)
                    .cornerRadius(10)
                }
                .padding(.vertical, 8)
            }
            .onAppear {
                cameraPosition = .camera(
                    .init(centerCoordinate: CLLocationCoordinate2D(
                        latitude: region.latitude,
                        longitude: region.longitude
                    ), distance: 500)
                )
            }
        }
    }
}
