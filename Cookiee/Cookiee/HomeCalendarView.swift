//
//  HomeCalendarView.swift
//  Cookiee
//
//  Created by minseo Kyung on 8/12/24.
//

import SwiftUI

struct HomeCalendarView: View {
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
                    .padding(.leading, 340 )
                }
                .frame(width: geometry.size.width, height: 45)
                
                // 캘린더 헤더
                HStack {
                    HStack {
                        Button {
                            // action
                        } label: {
                            Image("ChevronLeftIcon")
                        }
                        .padding(.leading, 5)
                        Spacer()
                        Text("2024년 06월")
                            .foregroundStyle(Color.Brown00)
                        Spacer()
                        Button {
                            // action
                        } label: {
                            Image("ChevronRightIcon")
                        }
                        .padding(.trailing, 5)
                    }
                    HStack {
                        // 요일 표시 부분
                    }
                }
                .frame(width: geometry.size.width, height: 45)
                .background(Color.Beige)
                
                // 캘린더 셀
                

            }
        }
    }
}


#Preview {
    HomeCalendarView()
}
