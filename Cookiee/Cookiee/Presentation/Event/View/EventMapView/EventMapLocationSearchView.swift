//
//  MapSearchByName.swift
//  Cookiee
//
//  Created by minseo Kyung on 1/14/25.
//

import SwiftUI
import MapKit

struct EventMapLocationSearchView: View {
    @ObservedObject var locationSearchService = EventMapLocationSearchViewModel()
    @State private var selectedLocation: MapLocationDTO? = nil
    @State private var isPlaceSelected: Bool = false
    @State private var cameraPosition: MapCameraPosition = .camera(.init(centerCoordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0), distance: 1))

    var body: some View {
        VStack {
            VStack {
                VStack {
                    EventMapLocationSearchBarUIView(text: $locationSearchService.searchQuery)
                }
                .padding([.bottom, .horizontal], 7)
                .background(Color.white)
            }
            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
            
            ScrollView {
                ForEach(locationSearchService.completions) { completion in
                    Button(action: {
                        searchLocation(for: completion)
                        isPlaceSelected = true
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
                        Divider()
                    })
                    
                }
            }
            
            Spacer()
        }
        .sheet(isPresented: $isPlaceSelected, onDismiss: {
            selectedLocation = nil
        }, content: {
            VStack {
                if let region = selectedLocation {
                    MapLocationDetailView(region: region, cameraPosition: $cameraPosition)
                } else {
                    ProgressView()
                }
            }
            .padding(.top, 12)
            .presentationDetents([.fraction(0.7)])
            .presentationDragIndicator(.visible)
        })
    }

    private func searchLocation(for completion: MKLocalSearchCompletion) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = completion.title
        
        let search = MKLocalSearch(request: searchRequest)
        search.start { response, error in
            guard let response = response else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            // 첫 번째 검색 결과 설정
            if let selectedPlace = response.mapItems.first?.placemark {
                let coordinate = selectedPlace.coordinate
                selectedLocation = MapLocationDTO(
                    title: selectedPlace.name ?? "알 수 없는 장소",
                    subtitle: selectedPlace.title ?? "알 수 없는 장소",
                    latitude: coordinate.latitude,
                    longitude: coordinate.longitude
                )

                print("\(String(describing: selectedPlace.name)), \(String(describing: selectedPlace.title)), \(coordinate.latitude), \(coordinate.longitude)")
            }
        }
    }

    private struct MapLocationDetailView: View {
        var region: MapLocationDTO
        @Binding var cameraPosition: MapCameraPosition
        
        var body: some View {
            VStack {
                HStack {
                    Text("\(region.title) 으로 장소를 추가할까요?")
                        .font(Font.Head1_B)
                        .padding(15)
                }
                
                Map(position: $cameraPosition, bounds: nil, interactionModes: .all, scope: nil) {
                    Annotation("\(region.title)", coordinate: region.coordinate) {
                        Image("CookieePin")
                    }
                }
                .mapControlVisibility(.visible)
                
                HStack {
                    Button(action: {}, label: {
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
                    
                    Button(action: {}, label: {
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

#Preview {
    EventMapLocationSearchView()
}

