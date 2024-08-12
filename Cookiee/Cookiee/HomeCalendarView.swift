//
//  HomeCalendarView.swift
//  Cookiee
//
//  Created by minseo Kyung on 8/12/24.
//

import SwiftUI

struct HomeCalendarView: View {
    @State private var month: Date = Date()
    @State private var clickedCurrentMonthDates: Date?
    
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
                // 쿠키 타이틀 헤더
                ZStack {
                    Image("cookiee_icon_small")
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
                
                // 캘린더
                VStack {
                    headerView
                    calendarGridView
                    Spacer()
                }
                .background(Color.Beige)
                

            }
        }
    }
    
    // 헤더
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

    // 연월 표기
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
            .disabled(!canMoveToPreviousMonth())
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
            .disabled(!canMoveToNextMonth())
            .padding(.trailing, 7)
        }
        .frame(maxWidth: .infinity)
    }

      
      // 캘린더 그리드 뷰
      private var calendarGridView: some View {
        let daysInMonth: Int = numberOfDays(in: month)
        let firstWeekday: Int = firstWeekdayOfMonth(in: month) - 1
        let lastDayOfMonthBefore = numberOfDays(in: previousMonth())
        let numberOfRows = Int(ceil(Double(daysInMonth + firstWeekday) / 7.0))
        let visibleDaysOfNextMonth = numberOfRows * 7 - (daysInMonth + firstWeekday)
        
          return LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0, alignment: .top), count: 7), spacing: 1) {
          ForEach(-firstWeekday ..< daysInMonth + visibleDaysOfNextMonth, id: \.self) { index in
            Group {
              if index > -1 && index < daysInMonth {
                let date = getDate(for: index)
                let day = Calendar.current.component(.day, from: date)
                let clicked = clickedCurrentMonthDates == date
                let isToday = date.formattedCalendarDayDate == today.formattedCalendarDayDate
                
                CellView(day: day, clicked: clicked, isToday: isToday)
              } else if let prevMonthDate = Calendar.current.date(
                byAdding: .day,
                value: index + lastDayOfMonthBefore,
                to: previousMonth()
              ) {
                let day = Calendar.current.component(.day, from: prevMonthDate)
                
                CellView(day: day, isCurrentMonthDay: false)
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


// 캘린더 셀
private struct CellView: View {
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
  
  fileprivate init(
    day: Int,
    clicked: Bool = false,
    isToday: Bool = false,
    isCurrentMonthDay: Bool = true
  ) {
    self.day = day
    self.clicked = clicked
    self.isToday = isToday
    self.isCurrentMonthDay = isCurrentMonthDay
  }
  
  fileprivate var body: some View {
    VStack {
        RoundedRectangle(cornerRadius: 2)
            .fill(backgroundColor)
            .overlay(Text(String(day)))
            .foregroundColor(textColor)
    }
    .frame(width: 55, height: 95)
  }
}

#Preview {
    HomeCalendarView()
}

private extension HomeCalendarView {
  var today: Date {
    let now = Date()
    let components = Calendar.current.dateComponents([.year, .month, .day], from: now)
    return Calendar.current.date(from: components)!
  }
  
  static let calendarHeaderDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "YYYY년 MM월"
    return formatter
  }()
  
  static let weekdaySymbols: [String] = Calendar.current.shortWeekdaySymbols
}

private extension HomeCalendarView {
  /// 특정 해당 날짜
  func getDate(for index: Int) -> Date {
    let calendar = Calendar.current
    guard let firstDayOfMonth = calendar.date(
      from: DateComponents(
        year: calendar.component(.year, from: month),
        month: calendar.component(.month, from: month),
        day: 1
      )
    ) else {
      return Date()
    }
    
    var dateComponents = DateComponents()
    dateComponents.day = index
    
    let timeZone = TimeZone.current
    let offset = Double(timeZone.secondsFromGMT(for: firstDayOfMonth))
    dateComponents.second = Int(offset)
    
    let date = calendar.date(byAdding: dateComponents, to: firstDayOfMonth) ?? Date()
    return date
  }
  
  /// 해당 월에 존재하는 일자 수
  func numberOfDays(in date: Date) -> Int {
    return Calendar.current.range(of: .day, in: .month, for: date)?.count ?? 0
  }
  
  /// 해당 월의 첫 날짜가 갖는 해당 주의 몇번째 요일
  func firstWeekdayOfMonth(in date: Date) -> Int {
    let components = Calendar.current.dateComponents([.year, .month], from: date)
    let firstDayOfMonth = Calendar.current.date(from: components)!
    
    return Calendar.current.component(.weekday, from: firstDayOfMonth)
  }
  
  /// 이전 월 마지막 일자
  func previousMonth() -> Date {
    let components = Calendar.current.dateComponents([.year, .month], from: month)
    let firstDayOfMonth = Calendar.current.date(from: components)!
    let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: firstDayOfMonth)!
    
    return previousMonth
  }
  
  /// 월 변경
  func changeMonth(by value: Int) {
    self.month = adjustedMonth(by: value)
  }
  
  /// 이전 월로 이동 가능한지 확인
  func canMoveToPreviousMonth() -> Bool {
    let currentDate = Date()
    let calendar = Calendar.current
    let targetDate = calendar.date(byAdding: .month, value: -3, to: currentDate) ?? currentDate
    
    if adjustedMonth(by: -1) < targetDate {
      return false
    }
    return true
  }
  
  /// 다음 월로 이동 가능한지 확인
  func canMoveToNextMonth() -> Bool {
    let currentDate = Date()
    let calendar = Calendar.current
    let targetDate = calendar.date(byAdding: .month, value: 3, to: currentDate) ?? currentDate
    
    if adjustedMonth(by: 1) > targetDate {
      return false
    }
    return true
  }
  
  /// 변경하려는 월 반환
  func adjustedMonth(by value: Int) -> Date {
    if let newMonth = Calendar.current.date(byAdding: .month, value: value, to: month) {
      return newMonth
    }
    return month
  }
}
extension Date {
  static let calendarDayDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMMM yyyy dd"
    return formatter
  }()
  
  var formattedCalendarDayDate: String {
    return Date.calendarDayDateFormatter.string(from: self)
  }
}
