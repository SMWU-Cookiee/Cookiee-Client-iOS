//
//  HomeCalendarView.swift
//  Cookiee
//
//  Created by minseo Kyung on 8/12/24.
//

import SwiftUI

struct HomeCalendarView: View {
    @State var month: Date = Date()
    @State var clickedCurrentMonthDates: Date?
    
    @ObservedObject var homeCalendarViewModel = CalendarThumnailViewModel()
    
    init(
        month: Date = Date(),
        clickedCurrentMonthDates: Date? = nil
    ) {
        _month = State(initialValue: month)
        _clickedCurrentMonthDates = State(initialValue: clickedCurrentMonthDates)
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack {
                    Image("cookiee_typo_small")
                    HStack {
                        Button {
                            // action
                        } label: {
                            Image("Download")
                        }
                    }
                    .padding(.leading, 340)
                }
                .frame(width: geometry.size.width, height: 45)
                
                VStack {
                    CalendarHeaderView
                    CalendarGridView
                    Spacer()
                }
                .background(Color.Beige)
            }
        }
        .onAppear() {
            homeCalendarViewModel.loadThumbnailList()
        }
    }
    
    private var CalendarHeaderView: some View {
        VStack(alignment: .center) {
            YearMonthControllerView
                .padding(.bottom, 5)
                .padding(.top, 5)
            
            HStack {
                ForEach(Self.weekdaySymbols.indices, id: \.self) { symbol in
                    Text(Self.weekdaySymbols[symbol])
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .font(.Body1_R)
                }
            }
            .padding(.top, 5)
        }
        .frame(height: 75)
    }

    private var YearMonthControllerView: some View {
        HStack {
            Button(
                action: {
                    changeMonth(by: -1)
                },
                label: {
                    Image("ChevronLeftIcon")
                }
            )
            .padding(.leading, 7)
            
            Spacer()
            
            Text(month, formatter: Self.calendarHeaderDateFormatter)
                .font(.Head1_M)
                .foregroundStyle(Color.Brown00)
            
            Spacer()
            
            Button(
                action: {
                    changeMonth(by: 1)
                },
                label: {
                    Image("ChevronRightIcon")
                }
            )
            .padding(.trailing, 7)
        }
        .frame(maxWidth: .infinity)
    }

      
    private var CalendarGridView: some View {
        let daysInMonth = numberOfDays(in: month)
        let firstWeekday = firstWeekdayOfMonth(in: month) - 1
        let lastDayOfMonthBefore = numberOfDays(in: previousMonth())
        let numberOfRows = Int(ceil(Double(daysInMonth + firstWeekday) / 7.0))
        let visibleDaysOfNextMonth = numberOfRows * 7 - (daysInMonth + firstWeekday)

        return LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0, alignment: .top), count: 7), spacing: 2) {
            ForEach(-firstWeekday ..< daysInMonth + visibleDaysOfNextMonth, id: \.self) { index in
                CalendarGridGroupCellView(index: index, daysInMonth: daysInMonth, firstWeekday: firstWeekday, lastDayOfMonthBefore: lastDayOfMonthBefore)
            }
        }
    }

    private func CalendarGridGroupCellView(index: Int, daysInMonth: Int, firstWeekday: Int, lastDayOfMonthBefore: Int) -> some View {
        Group {
            if index >= 0 && index < daysInMonth {
                let date = getDate(for: index)
                let day = Calendar.current.component(.day, from: date)
                let clicked = clickedCurrentMonthDates == date
                let isToday = date.formattedCalendarDayDate == today.formattedCalendarDayDate
                let thumbnailData = filterThumbnailUrlByDate(date: date)
                
                NavigationLink(
                    destination: DateView(date: date, thumbnailId: thumbnailData?.thumbnailId),
                    label: {
                        CellView(day: day, clicked: clicked, isToday: isToday, thumbnailUrl: thumbnailData?.thumbnailUrl)
                    }
                )
            } else if let prevMonthDate = Calendar.current.date(
                byAdding: .day,
                value: index + lastDayOfMonthBefore,
                to: previousMonth()
            ) {
                let day = Calendar.current.component(.day, from: prevMonthDate)
                CellView(day: day, isCurrentMonthDay: false, thumbnailUrl: nil)
            }
        }
        .onTapGesture {
            handleTap(index: index, daysInMonth: daysInMonth)
        }
    }

    private func handleTap(index: Int, daysInMonth: Int) {
        if index >= 0 && index < daysInMonth {
            let date = getDate(for: index)
            clickedCurrentMonthDates = date
        }
    }

}
