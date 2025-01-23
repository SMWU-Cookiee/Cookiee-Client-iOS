//
//  SearchBar.swift
//  Cookiee
//
//  Created by minseo Kyung on 1/14/25.
//

import SwiftUI
import MapKit

struct EventMapLocationSearchBarUIView: UIViewRepresentable {
    @Binding var text: String

    class Coordinator: NSObject, UISearchBarDelegate {
        @Binding var text: String

        init(text: Binding<String>) {
            _text = text
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
    }

    func makeCoordinator() -> EventMapLocationSearchBarUIView.Coordinator {
        return Coordinator(text: $text)
    }

    func makeUIView(context: UIViewRepresentableContext<EventMapLocationSearchBarUIView>) -> UISearchBar {
        let searchBar = UISearchBar()
        searchBar.delegate = context.coordinator
        searchBar.searchBarStyle = .minimal
        searchBar.barTintColor = UIColor(Color.Gray01)
        searchBar.placeholder = "장소를 검색하세요"
        searchBar.searchTextField.font = UIFont.Body0_R_UIFont
        
        return searchBar
    }

    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<EventMapLocationSearchBarUIView>) {
        uiView.text = text
    }
}
