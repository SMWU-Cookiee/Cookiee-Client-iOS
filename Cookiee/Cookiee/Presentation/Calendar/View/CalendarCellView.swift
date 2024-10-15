//
//  CalendarCellView.swift
//  Cookiee
//
//  Created by minseo Kyung on 10/15/24.
//

import SwiftUI

extension HomeCalendarView {
    struct CellView: View {
        private var day: Int
        private var clicked: Bool
        private var isToday: Bool
        private var isCurrentMonthDay: Bool
        private var textColor: Color {
            if clicked {
                return Color.black
            } else if isCurrentMonthDay {
                return Color.black
            } else {
                return Color.gray
            }
        }
        private var backgroundColor: Color {
            if clicked {
                return Color.gray
            } else if isToday {
                return Color.white
            } else {
                return Color.white
            }
        }
        private var thumbnailUrl: String?


        init(
            day: Int,
            clicked: Bool = false,
            isToday: Bool = false,
            isCurrentMonthDay: Bool = true,
            thumbnailUrl: String?
        ) {
            self.day = day
            self.clicked = clicked
            self.isToday = isToday
            self.isCurrentMonthDay = isCurrentMonthDay
            self.thumbnailUrl = thumbnailUrl
        }

        var body: some View {
            VStack {
                if let url = thumbnailUrl, !url.isEmpty {
                    AsyncImage(url: URL(string: url)) { phase in
                        switch phase {
                        case .empty:
                            RoundedRectangle(cornerRadius: 2)
                                .fill(Color.white)
                                .overlay(ProgressView())
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 55, height: 95)
                                .clipShape(RoundedRectangle(cornerRadius: 2))
                            
                        case .failure(_):
                            RoundedRectangle(cornerRadius: 2)
                                .fill(Color.white)
                                .overlay(
                                    Image(systemName: "photo")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        .aspectRatio(contentMode: .fit)
                                        .foregroundStyle(Color.gray)
                                )
                        @unknown default:
                            EmptyView()
                        }
                    }
                } else {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(backgroundColor)
                        .overlay(Text(String(day)).foregroundColor(textColor))
                }
            }
            .frame(width: 55, height: 95)
        }
    }
}
