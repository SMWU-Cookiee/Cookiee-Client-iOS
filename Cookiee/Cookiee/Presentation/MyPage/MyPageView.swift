//
//  MyPageView.swift
//  Cookiee
//
//  Created by minseo Kyung on 8/20/24.
//

import SwiftUI

struct MyPageView: View {
    @ObservedObject var signOutViewModel = SignOutViewModel()
    @ObservedObject var profileViewModel = ProfileViewModel()

    @State var isSignOutButtonTapped: Bool = false
    
    var body: some View {
        VStack (alignment: .leading) {
            VStack {
                HStack {
                    VStack {
                        if let imageURL = profileViewModel.profile.profileImage {
                            AsyncImage(url: URL(string: imageURL)) { phase in
                                switch phase {
                                case .empty:
                                    Circle()
                                        .fill(Color.Gray01)
                                        .frame(width: 60, height: 60)
                                        .overlay(ProgressView())
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 60, height: 60)
                                        .clipShape(Circle())
                                    
                                case .failure(_):
                                    RoundedRectangle(cornerRadius: 2)
                                        .fill(Color.white)
                                        .overlay(
                                            Image(systemName: "photo")
                                                .resizable()
                                                .frame(width: 60, height: 60)
                                                .aspectRatio(contentMode: .fit)
                                                .foregroundStyle(Color.gray)
                                        )
                                @unknown default:
                                    EmptyView()
                                }
                            }
                        } else {
                            Circle()
                                .foregroundColor(Color.Gray01)
                                .frame(width: 60, height: 60)
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        Text(profileViewModel.profile.nickname)
                            .font(.Body0_SB)
                            .foregroundColor(Color.Brown00)
                        Spacer()
                        Text(profileViewModel.profile.selfDescription)
                            .font(.Body1_M)
                            .foregroundColor(Color.Brown02)
                    }
                    .frame(height: 50)
                    .padding(.horizontal)
                    Spacer()
                    NavigationLink(
                        destination: ProfileEditView(),
                        label: {
                            Text("프로필 수정")
                                .font(.Body2_R)
                                .foregroundColor(Color.Gray04)
                            Image("ChevronRightSmall")
                        }
                    )
                }
                .frame(height: 100)
                .padding(.horizontal)
                .background(Color.Gray00)
                .cornerRadius(10)
            }
            .padding(.bottom, 30)
            
            VStack(alignment: .leading) {
                HStack {
                    NavigationLink(
                        destination: CategoryListView(),
                        label: {
                            Text("카테고리 관리")
                                .font(.Body1_M)
                                .foregroundStyle(Color.black)
                            Spacer()
                            Image("ChevronRightSmall")
                                .padding(.horizontal, 10)
                        }
                    )
                    .frame(height: 32)
                }
                
                Divider()
                
                HStack {
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        Text("사용 가이드")
                            .font(.Body1_M)
                            .foregroundStyle(Color.black)
                        Spacer()
                        Image("ChevronRightSmall")
                            .padding(.horizontal, 10)
                    })
                    .frame(height: 32)
                }
                
                Divider()
                
                HStack {
                    NavigationLink(
                        destination: PrivacyPolicyView(),
                        label: {
                            Text("약관 및 개인정보 활용")
                                .font(.Body1_M)
                                .foregroundStyle(Color.black)
                            Spacer()
                            Image("ChevronRightSmall")
                                .padding(.horizontal, 10)
                        }
                    )
                    .frame(height: 32)
                }
                
                Divider()
                
                HStack {
                    NavigationLink(
                        destination: DevelopersView(),
                        label: {
                            Text("개발자 정보")
                                .font(.Body1_M)
                                .foregroundStyle(Color.black)
                            Spacer()
                            Image("ChevronRightSmall")
                                .padding(.horizontal, 10)
                        }
                    )
                    .frame(height: 32)
                }
                
                Divider()
                
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Text("로그아웃")
                        .font(.Body1_M)
                        .foregroundStyle(Color.black)
                    Spacer()
                })
                .frame(height: 32)
                
                Divider()
                
                Button(action: {
                    isSignOutButtonTapped = true
                }, label: {
                    Text("회원 탈퇴")
                        .font(.Body1_M)
                        .foregroundStyle(Color.black)
                    Spacer()
                })
                .frame(height: 32)
                
                Divider()
                
                HStack {
                    Text("버전 정보")
                        .font(.Body1_M)
                        .foregroundStyle(Color.black)
                    Spacer()
                    Text("v 1.0.0")
                        .font(.Body1_M)
                        .foregroundStyle(Color.Gray05)
                }
                .frame(height: 32)
                
            }
            Spacer()
            Text(verbatim: "Contact: apps.cookiee@gmail.com")
                .font(.Body1_R)
                .foregroundStyle(Color.Gray03)
            
        }
        .padding(.horizontal, 15)
        .padding(.top, 15)
        .padding(.bottom, 10)
        .showCustomAlert(
            isPresented: $isSignOutButtonTapped,
            content: {
                    VStack {
                        Text("회원탈퇴할까요?")
                            .font(.Head1_B)
                            .padding(.bottom, 9)
                        Text("회원 탈퇴 시, 개인 정보 및 기존에 등록된 \n이벤트, 카테고리 정보가 모두 삭제됩니다")
                            .font(.Body1_R)
                    }
            },
            firstButton:
                CustomAlertButton(
                    action: { isSignOutButtonTapped = false },
                    title: Text("취소").foregroundColor(Color.Gray04)
                ),
            secondButton:
                CustomAlertButton(
                    action: {
                        isSignOutButtonTapped = false
                        signOutViewModel.deleteSignOut()
                    },
                    title: Text("탈퇴하기").foregroundColor(Color.Brown00))
        )
        .navigationDestination(isPresented: $signOutViewModel.isSignOutSuccess, destination: {
            ContentView()
        })
        .onAppear() {
            profileViewModel.loadUserProfile()
        }
    }
}

#Preview {
    MyPageView()
}
