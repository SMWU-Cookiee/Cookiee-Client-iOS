//
//  DateView.swift
//  Cookiee
//
//  Created by minseo Kyung on 8/12/24.
//

import SwiftUI

struct DateView: View {
    @State var date: Date?
    var body: some View {
        Text("\(String(describing: date))")
    }
}

#Preview {
    DateView(date: Date.now)
}
