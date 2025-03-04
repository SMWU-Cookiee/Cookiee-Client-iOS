//
//  SignUpView.swift
//  Cookiee
//
//  Created by minseo Kyung on 10/1/24.
//

import SwiftUI

struct SignUpView: View {
    @State var isBackButtonTapped: Bool = false
    @State var isSignUpCanceled: Bool = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    // 백 버튼 커스텀
    var backButton: some View {
        Button {
            self.isBackButtonTapped = true
        } label: {
            HStack {
                Image("ChevronLeftIconBlack")
                    .aspectRatio(contentMode: .fit)
            }
        }
    }
    
    // ViewModel 전달
    @ObservedObject var socialLoginViewModel: SocialLoginViewModel

    // 사용자 입력 필드
    @State var nickname: String = ""
    @State var introduction: String = ""
    
    // 프로필 사진 관련 필드
    @State var showImagePicker = false
    @State var selectedUIImage: UIImage? = nil
    @State var image: Image?
    
    @ObservedObject var signUpViewModel = SignUpViewModel()
    
    func loadImage() {
        guard let selectedImage = selectedUIImage else { return }
        image = Image(uiImage: selectedImage)
        isValidForm()
    }
    
    @State var submitButtonColor: Color = .Gray02
    @State var isSubmitButtonDisabled: Bool = true

    func isValidForm() {
        let isAllInputted = nickname != "" && introduction != "" && image != nil
        submitButtonColor = isAllInputted ? .Brown01 : .Gray02
        isSubmitButtonDisabled = !isAllInputted
    }
    
    var body: some View {
        ZStack {
            VStack {
                // 프로필 이미지
                HStack {
                    if let image = image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipShape(Circle())
                            .frame(width: 129, height: 129)
                            .overlay(
                                Button(action: {
                                    showImagePicker.toggle()
                                }, label: {
                                    Image("ImageBrown")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                })
                            )
                    } else {
                        Circle()
                            .foregroundColor(Color.white)
                            .frame(width: 129, height: 129)
                            .overlay(
                                Circle()
                                    .stroke(Color.Brown02, lineWidth: 1)
                            )
                            .overlay(
                                Button(action: {
                                    showImagePicker.toggle()
                                }, label: {
                                    Image("ImageBrown")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                })
                            )
                    }
                }
                .sheet(isPresented: $showImagePicker, onDismiss: {
                    loadImage()
                }) {
                    ImagePicker(allowEditing: true, image: $selectedUIImage)
                }
                .padding(.bottom, 35)
                
                // 닉네임 편집
                HStack() {
                    Text("닉네임")
                        .font(.Body0_SB)
                        .frame(width: 75, alignment: .leading)
                        .foregroundStyle(Color.Brown00)
                    TextField("\(nickname)", text: $nickname)
                        .placeholder(when: nickname.isEmpty) {
                            Text("닉네임을 입력해주세요.")
                                .foregroundStyle(Color.Brown05)
                                .font(.Body0_M)
                        }
                        .padding(10)
                        .font(.Body1_M)
                        .frame(height: 40)
                        .background(Color.white)
                        .cornerRadius(5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.Brown02, lineWidth: 1)
                        )
                        .onChange(of: nickname) {
                            isValidForm()
                        }
                }
                .padding(.bottom, 10)
                
                // 한 줄 소개 편집
                HStack {
                    Text("한 줄 소개")
                        .font(.Body0_SB)
                        .frame(width: 75, alignment: .leading)
                        .foregroundStyle(Color.Brown00)
                    TextField("\(introduction)", text: $introduction)
                        .placeholder(when: introduction.isEmpty) {
                            Text("한 줄 소개를 입력해주세요.")
                                .foregroundStyle(Color.Brown05)
                                .font(.Body0_M)
                        }
                        .padding(10)
                        .font(.Body1_M)
                        .frame(height: 40)
                        .background(Color.white)
                        .cornerRadius(5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.Brown02, lineWidth: 1)
                        )
                        .onChange(of: introduction) {
                            isValidForm()
                        }
                }
                Spacer()
            }
            .padding()
            .padding(.top, 10)
            
            if signUpViewModel.isLoading {
                VStack {
                    Spacer()
                    ProgressView()
                        .controlSize(.large)
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black.opacity(0.3))
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("회원가입")
                    .font(.Head1_B)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
        .navigationBarItems(
            trailing:
                Button(action: {
                    signUpViewModel.postSignUp(
                        email: socialLoginViewModel.email ?? "",
                        name: socialLoginViewModel.name ?? "",
                        nickname: nickname,
                        selfDescription: introduction,
                        socialId: socialLoginViewModel.socialId ?? "",
                        socialLoginType: socialLoginViewModel.socialLoginType ?? "",
                        selectedUIImage: selectedUIImage
                    )
                }, label: {
                    Text("완료")
                        .font(.Body0_B)
                        .foregroundColor(submitButtonColor)
                })
                .disabled(isSubmitButtonDisabled || signUpViewModel.isLoading)
        )
        
        .navigationDestination(isPresented: $signUpViewModel.isSignUpSuccess) {
            TabBarView()
        }
        
        .showCustomAlert(
            isPresented: $isBackButtonTapped,
            alertContent: {
                VStack(alignment: .center) {
                        Text("입력을 취소하고")
                            .font(.Head1_B)
                            .padding(.bottom, 1)
                        Text("페이지를 나갈까요?")
                            .font(.Head1_B)
                            .padding(.bottom, 9)
                        Text("페이지를 나가면 복구가 어렵습니다.")
                            .font(.Body1_R)
                    }
            },
            firstButton:
                CustomAlertButton(
                    action: { isBackButtonTapped = false },
                    title: Text("취소").foregroundColor(Color.Gray04)
                ),
            secondButton:
                CustomAlertButton(
                    action: {
                        isBackButtonTapped = false
                        isSignUpCanceled = true
                    },
                    title: Text("탈퇴하기").foregroundColor(Color.Brown00))
        )
        
        .navigationDestination(isPresented: $isSignUpCanceled) {
            ContentView()
        }
    }
}
