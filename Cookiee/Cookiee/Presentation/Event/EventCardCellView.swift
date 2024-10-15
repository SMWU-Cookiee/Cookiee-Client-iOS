//
//  EventCardCellView.swift
//  Cookiee
//
//  Created by minseo Kyung on 10/15/24.
//

import SwiftUI

struct EventCardCellView: View {
    private var thumbnailUrl: String
    private var firstCategory: String
    private var firstCategoryColor: String
    private var eventId: String
    private var toggleModal: () -> Void
    
    init(thumbnailUrl: String, firstCategory: String, firstCategoryColor: String, eventId: String, toggleModal: @escaping () -> Void) {
        self.thumbnailUrl = thumbnailUrl
        self.firstCategory = firstCategory
        self.firstCategoryColor = firstCategoryColor
        self.eventId = eventId
        self.toggleModal = toggleModal
    }
    
    var body: some View {
        ZStack {
            Button {
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
