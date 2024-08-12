//
//  DateView.swift
//  Cookiee
//
//  Created by minseo Kyung on 8/12/24.
//

import SwiftUI

struct DateView: View {
    var date: Date?
    
    var body: some View {
        VStack {
            if let date = date {
                Text("Selected Date: \(date, formatter: Self.dateFormatter)")
                    .font(.title)
            } else {
                Text("No Date Selected")
                    .font(.title)
            }
        }
        .padding()
    }
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter
    }()
}

#Preview {
    DateView(date: Date.now)
}
