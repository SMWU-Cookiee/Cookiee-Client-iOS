//
//  PrivacyPolicyView.swift
//  Cookiee
//
//  Created by minseo Kyung on 8/20/24.
//

import SwiftUI

struct PrivacyPolicyView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var backButton: some View {
        Button {
            self.presentationMode.wrappedValue.dismiss()
        } label: {
            HStack {
                Image("ChevronLeftIconBlack")
                    .aspectRatio(contentMode: .fit)
            }
        }
    }
    
    @State var showTermsOfService = false
    @State var showPrivacyPolicy = false
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    showTermsOfService = true
                }, label: {
                    Text("이용약관")
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
                Button(action: {
                    showPrivacyPolicy = true
                }, label: {
                    Text("개인정보 활용방침")
                        .font(.Body1_M)
                        .foregroundStyle(Color.black)
                    Spacer()
                    Image("ChevronRightSmall")
                        .padding(.horizontal, 10)
                })
                .frame(height: 32)
            }
            Spacer()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("약관 및 개인정보 활용")
                    .font(.Head1_B)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
        .padding()
        
        .sheet(isPresented: $showTermsOfService) {
            SafariView(url:URL(string: "https://thunder-syrup-94d.notion.site/6a378d5d676444cbad61bbe971591da5?pvs=74")!)
        }
        
        .sheet(isPresented: $showPrivacyPolicy) {
            SafariView(url:URL(string: "https://thunder-syrup-94d.notion.site/cc6dbac1d4ee4a05b7555e4fd398f4a1")!)
        }
        
    }
}

#Preview {
    PrivacyPolicyView()
}

