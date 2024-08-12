//
//  DateView.swift
//  Cookiee
//
//  Created by minseo Kyung on 8/12/24.
//

import SwiftUI

struct DateView: View {
    // Back 버튼 커스텀
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var backButton : some View {
            Button{
                self.presentationMode.wrappedValue.dismiss()
            } label: {
                HStack {
                    Image("ChevronLeftIcon")
                        .aspectRatio(contentMode: .fit)
                }
            }
        }

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
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
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
