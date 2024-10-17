//
//  EventCardCellView.swift
//  Cookiee
//
//  Created by minseo Kyung on 10/15/24.
//

import SwiftUI

struct EventCardCellView: View {
    @StateObject var eventViewModel : EventViewModel
    var thumbnailUrl: String
    var firstCategory: String
    var firstCategoryColor: String
    var eventId: Int64
    var toggleModal: () -> Void
    
    var body: some View {
        ZStack {
            Button {
                eventViewModel.selectedEventId = eventId
                toggleModal()
            } label: {
                ZStack {
                    AsyncImage(url: URL(string: thumbnailUrl)) { phase in
                        switch phase {
                        case .empty:
                            VStack {
                                ProgressView()
                                    .frame(height: 240)
                            }
                        case .success(let image):
                            ZStack (alignment: .bottomTrailing) {
                                image
                                    .resizable()
                                    .clipShape(RoundedRectangle(cornerRadius: 5))
                                CategoryLabel(name: firstCategory, color: firstCategoryColor)
                                .padding(.trailing, 6)
                                .padding(.bottom, 8)
                            }
                        case .failure:
                            Image(systemName: "photo")
                                .resizable()
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                                
                        @unknown default:
                            EmptyView()
                        }
                    }
                }
                .cornerRadius(5)
                .frame(height: 240)
            }
            
        }
        .frame(height: 240)
    }
}
