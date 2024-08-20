//
//  MyPageView.swift
//  Cookiee
//
//  Created by minseo Kyung on 8/20/24.
//

import SwiftUI

struct MyPageView: View {
    var body: some View {
        VStack (alignment: .leading) {
            VStack {
                HStack {
                    Image("testimage")
                        .resizable()
                        .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                        .frame(width: 70, height: 70)
                    VStack(alignment: .leading) {
                        Text("김쿠키")
                            .font(.Body0_SB)
                            .foregroundColor(Color.Brown00)
                        Spacer()
                        Text("맛있는거 많이 먹기")
                            .font(.Body1_M)
                            .foregroundColor(Color.Brown02)
                    }
                    .frame(height: 50)
                    .padding()
                    Spacer()
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        HStack {
                            Text("프로필 수정")
                                .font(.Body2_R)
                            .foregroundColor(Color.Gray04)
                            Image("ChevronRightSmall")
                        }
                    })
                }
                .padding()
                .background(Color.Gray00)
                .cornerRadius(10)
            }
            VStack(alignment: .leading) {
                HStack {
                    MenuButton(menuName: "카테고리 관리") {
                        // 카테고리 관리로 이동
                    }
                    Spacer()
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        Image("ChevronRightSmall")
                            .padding(.horizontal, 10)
                    })
                }
                Divider()
                HStack {
                    MenuButton(menuName: "사용 가이드") {
                        
                    }
                    Spacer()
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        Image("ChevronRightSmall")
                            .padding(.horizontal, 10)
                    })
                }
                Divider()
                HStack {
                    MenuButton(menuName: "약관 및 개인정보 활용") {
                        
                    }
                    Spacer()
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        Image("ChevronRightSmall")
                            .padding(.horizontal, 10)
                    })
                }
                Divider()
                MenuButton(menuName: "개발자 정보") {
                    
                }
                Divider()
                MenuButton(menuName: "로그아웃") {
                    
                }
                Divider()
                MenuButton(menuName: "회원 탈퇴") {
                    
                }
                Divider()
                HStack {
                    MenuButton(menuName: "버전 정보") {
                        
                    }
                    Spacer()
                    Text("v 1.0.1")
                        .font(.Body1_M)
                        .foregroundStyle(Color.Gray05)
                }
            }
            Spacer()
            Text(verbatim: "Contact: apps.cookiee@gmail.com")
                .font(.Body1_R)
                .foregroundStyle(Color.Gray03)
                
        }
        .padding()
    }
}

#Preview {
    MyPageView()
}

struct MenuButton: View {
    var menuName: String
    var menuAction: () -> Void
    
    var body: some View {
        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
            Text(menuName)
                .font(.Body1_M)
                .foregroundStyle(Color.black)
        })
        .frame(height: 32)
    }
}
