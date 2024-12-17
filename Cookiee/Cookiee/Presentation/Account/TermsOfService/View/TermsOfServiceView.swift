//
//  TermsOfServiceView.swift
//  Cookiee
//
//  Created by minseo Kyung on 12/17/24.
//

import SwiftUI

struct TermsOfServiceView: View {
    @ObservedObject var termsOfServiceViewModel = TermsOfServiceViewModel()
    
    @State var showTermsOfService = false
    @State var showPrivacyPolicy = false
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                HStack {
                    Image("cookiee_typo")
                        .resizable()
                        .frame(width: 134, height: 28)
                    Spacer()
                }
                .padding(.bottom, 19)
                HStack {
                    Text("서비스 이용을 위해\n이용약관에 동의해주세요.")
                        .font(Font.Head0_B_24)
                    Spacer()
                }
            }
            
            Spacer()
            
            HStack {
                termsOfServiceView
            }
            
            Spacer()
        }
        .padding()
        
        .sheet(isPresented: $showTermsOfService) {
            SafariView(url:URL(string: "https://thunder-syrup-94d.notion.site/6a378d5d676444cbad61bbe971591da5?pvs=74")!)
        }

        .sheet(isPresented: $showPrivacyPolicy) {
            SafariView(url:URL(string: "https://thunder-syrup-94d.notion.site/cc6dbac1d4ee4a05b7555e4fd398f4a1")!)
        }
    }
    
    private var termsOfServiceView: some View {
        VStack(spacing: 0) {
            HStack {
                Toggle("이용약관 전체 동의", isOn: $termsOfServiceViewModel.allPermit)
                    .toggleStyle(CheckboxToggleStyle())
                    .foregroundColor(Color.black)
                    .font(Font.Head0_B)

                Spacer()
            }
            
            
            Divider()
                .padding(.vertical, 12)

            HStack(alignment: .center, spacing: 0) {
                Toggle("", isOn: $termsOfServiceViewModel.termsOfServicePermit)
                    .toggleStyle(CheckboxToggleStyle())

                Button {
                    showTermsOfService = true
                } label: {
                    HStack(spacing: 0){
                        Text("[필수]")
                            .font(Font.Body0_M)
                            .foregroundColor(Color.Gray04)
                        Text(" 이용약관")
                            .underline()
                            .font(Font.Body0_M)
                            .foregroundColor(Color.Gray04)
                    }
                }
                Spacer()
            }

            .padding(.bottom, 8)

            HStack(spacing: 0) {
                Toggle("", isOn: $termsOfServiceViewModel.privacyPolicyPermit)
                    .toggleStyle(CheckboxToggleStyle())

                Button {
                    showPrivacyPolicy = true
                } label: {
                    HStack(spacing: 0) {
                        Text("[필수]")
                            .font(Font.Body0_M)
                            .foregroundColor(Color.Gray04)
                        Text(" 개인정보 활용방침")
                            .underline()
                            .font(Font.Body0_M)
                            .foregroundColor(Color.Gray04)
                    }
                }
                Spacer()
            }
        }
    }
}

#Preview {
    TermsOfServiceView()
}

struct CheckboxToggleStyle: ToggleStyle {
    @Environment(\.isEnabled) var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        Button(action: {
            configuration.isOn.toggle() 
        }, label: {
            HStack {
                Image(configuration.isOn ? "AgreeIconFill" : "AgreeIconBlank")
                    .frame(width: 24, height: 24)
                    .foregroundColor(Color.Gray03)
                configuration.label
            }
        })
        .buttonStyle(PlainButtonStyle())
        .disabled(!isEnabled)
    }
}
