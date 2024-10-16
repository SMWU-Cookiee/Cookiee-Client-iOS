//
//  TabBarView.swift
//  Cookiee
//
//  Created by minseo Kyung on 8/12/24.
//

import SwiftUI

enum Tab {
    case first
    case second
    case third
}

struct TabBarView : View {
    @State var selectedTab: Tab = .first
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Spacer()
                VStack {
                    switch selectedTab {
                    case .first:
                        HomeCalendarView()
                    case .second:
                        VStack {
                            Spacer()
                            Text("모아보기")
                            Spacer()
                        }
                    case .third:
                        MyPageView()
                    }
                }
                .padding(.bottom, 50)
                Spacer()
                CustomTabView(selectedTab: $selectedTab)
                    .background(Color.White)
                    .shadow(color: .black.opacity(0.05), radius: 13, x: 0, y: -10)
            }
        }
        .navigationBarBackButtonHidden()
    }
}

struct CustomTabView: View {
    @Binding var selectedTab: Tab
    var body: some View {
        HStack {
            HStack() {
                Spacer()
                Button {
                    selectedTab = .first
                } label: {
                    VStack {
                        Image(selectedTab == .first ? "HomeIcon_fill" : "HomeIcon")
                        Text("홈")
                            .font(.caption)
                            .foregroundColor(selectedTab == .first ? .Brown00 : .Gray03)
                    }
                }
                .frame(width: 70)
                Spacer()
                Button {
                    selectedTab = .second
                } label: {
                    VStack {
                        Image(selectedTab == .second ? "CookieeIcon_fill" : "CookieeIcon")
                        Text("모아보기")
                            .font(.caption)
                            .foregroundColor(selectedTab == .second ? .Brown00 : .Gray03)
                    }
                }
                .frame(width: 70)
                Spacer()
                Button {
                    selectedTab = .third
                } label: {
                    VStack {
                        Image(selectedTab == .third ? "MyPageIcon_fill" : "MyPageIcon")
                        Text("마이페이지")
                            .font(.caption)
                            .foregroundColor(selectedTab == .third ? .Brown00 : .Gray03)
                    }
                }
                .frame(width: 70)
                Spacer()
            }
            .padding(.top, 15)

        }
        .frame(height: 50, alignment: .center)
    }
    
}


#Preview {
    TabBarView()
}
