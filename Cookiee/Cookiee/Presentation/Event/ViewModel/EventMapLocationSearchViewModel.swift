//
//  LocationSearchService.swift
//  Cookiee
//
//  Created by minseo Kyung on 1/14/25.
//

import Foundation
import SwiftUI
import MapKit
import Combine

extension MKLocalSearchCompletion: @retroactive Identifiable {}

class EventMapLocationSearchViewModel: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    @Published var searchQuery = ""
    var completer: MKLocalSearchCompleter
    @Published var completions: [MKLocalSearchCompletion] = []
    var cancellable: AnyCancellable?

    override init() {
        completer = MKLocalSearchCompleter()
        super.init()
        cancellable = $searchQuery.assign(to: \.queryFragment, on: self.completer)
        completer.delegate = self
    }

    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.completions = completer.results
    }
}
