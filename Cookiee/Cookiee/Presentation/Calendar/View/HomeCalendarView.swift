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
                    headerView
                    calendarGridView
                    Spacer()
                }
                .background(Color.Beige)
            }
        }
        .onAppear() {
            homeCalendarViewModel.loadThumbnailList()
        }
    }
    
    private var headerView: some View {
        VStack(alignment: .center) {
            yearMonthView
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

    private var yearMonthView: some View {
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

      
    private var calendarGridView: some View {
        let daysInMonth: Int = numberOfDays(in: month)
        let firstWeekday: Int = firstWeekdayOfMonth(in: month) - 1
        let lastDayOfMonthBefore = numberOfDays(in: previousMonth())
        let numberOfRows = Int(ceil(Double(daysInMonth + firstWeekday) / 7.0))
        let visibleDaysOfNextMonth = numberOfRows * 7 - (daysInMonth + firstWeekday)
        
        return LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0, alignment: .top), count: 7), spacing: 2) {
            ForEach(-firstWeekday ..< daysInMonth + visibleDaysOfNextMonth, id: \.self) { index in
                Group {
                    if index > -1 && index < daysInMonth {
                        let date = getDate(for: index)
                        let day = Calendar.current.component(.day, from: date)
                        let clicked = clickedCurrentMonthDates == date
                        let isToday = date.formattedCalendarDayDate == today.formattedCalendarDayDate
                        
                        let thumbnailUrl = filterThumbnailUrlByDate(date: date)
                        
                        NavigationLink(
                            destination: DateView(date: date),
                            label: {
                                CellView(day: day, clicked: clicked, isToday: isToday, thumbnailUrl: thumbnailUrl)
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
                    if 0 <= index && index < daysInMonth {
                        let date = getDate(for: index)
                        clickedCurrentMonthDates = date
                    }
                }
            }
        }
    }
}
