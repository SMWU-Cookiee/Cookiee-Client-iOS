//
//  MapSearchByName.swift
//  Cookiee
//
//  Created by minseo Kyung on 1/14/25.
//

import SwiftUI
import MapKit

struct MapLocationSearchView: View {
    @ObservedObject var locationSearchService = LocationSearchService()
    @State private var selectedLocation: MapLocationDTO? = nil
    @State private var annotationItems: [MapLocationDTO] = []
    @State private var isPlaceSelected: Bool = false

    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $locationSearchService.searchQuery)
                
                List(locationSearchService.completions) { completion in
                    VStack(alignment: .leading) {
                        Text(completion.title)
                        Text(completion.subtitle)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .onTapGesture {
                        isPlaceSelected = true
                        searchLocation(for: completion)
                    }
                }
            }
        }
        .sheet(isPresented: $isPlaceSelected, content: {
            VStack {
                if let region = selectedLocation {
                    HStack {
                        Text("\(region.title) 으로 장소를 추가할까요?")
                            .font(Font.Head1_B)
                            .padding(15)
                    }
                   
                    Map() {
                        Annotation("\(region.title)", coordinate: region.coordinate) {
                            Image("CookieePin")
                        }
                    }
                }
            }
            .padding(.top, 12)
            .presentationDetents([.fraction(0.65)])
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
                
                // map 중앙 설정
                searchRequest.region = MKCoordinateRegion(
                    center: coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
                )
            }

            // annotationItems를 채우기
            annotationItems = response.mapItems.compactMap { (item: MKMapItem) -> MapLocationDTO? in
                let coordinate = item.placemark.coordinate
                return MapLocationDTO(
                    title: item.name ?? "알 수 없는 장소",
                    subtitle: item.placemark.title ?? "주소 없음",
                    latitude: coordinate.latitude,
                    longitude: coordinate.longitude
                )
            }
        }
    }
}

