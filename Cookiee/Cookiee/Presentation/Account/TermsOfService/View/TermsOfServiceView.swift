//
//  TermsOfServiceView.swift
//  Cookiee
//
//  Created by minseo Kyung on 12/17/24.
//

import SwiftUI

struct TermsOfServiceView: View {
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
                
            }
        }
        .padding()
    }
}

#Preview {
    TermsOfServiceView()
}
