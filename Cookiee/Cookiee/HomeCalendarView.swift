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
                .frame(width: geometry.size.width ,height: 45)
            }
        }
    }
}


#Preview {
    HomeCalendarView()
}
