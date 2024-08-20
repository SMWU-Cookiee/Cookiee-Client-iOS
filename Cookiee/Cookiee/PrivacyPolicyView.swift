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
    
    var body: some View {
        VStack {
            HStack {
                Link(destination: URL(string: "https://thunder-syrup-94d.notion.site/6a378d5d676444cbad61bbe971591da5?pvs=74")!) {
                    Text("이용약관")
                        .font(.Body1_M)
                        .foregroundStyle(Color.black)
                    Spacer()
                    Image("ChevronRightSmall")
                        .padding(.horizontal, 10)
                }
                .frame(height: 32)
            }
            Divider()
            HStack {
                Link(destination: URL(string: "https://thunder-syrup-94d.notion.site/cc6dbac1d4ee4a05b7555e4fd398f4a1?pvs=74")!) {
                    Text("개인정보 활용방침")
                        .font(.Body1_M)
                        .foregroundStyle(Color.black)
                    Spacer()
                    Image("ChevronRightSmall")
                        .padding(.horizontal, 10)
                }
                .frame(height: 32)
            }
            Spacer()
        }
        .navigationBarTitle(
            Text("약관 및 개인정보 활용")
                .font(.Head1_B)
        )
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
        .padding()
        .padding(.top, 10)
    }
}

#Preview {
    PrivacyPolicyView()
}

