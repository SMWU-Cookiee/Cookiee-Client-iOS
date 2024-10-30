//
//  CookieeCollectionView.swift
//  Cookiee
//
//  Created by minseo Kyung on 10/31/24.
//

import SwiftUI

struct CookieeCollectionView: View {
    @ObservedObject var cookieeCollectionViewModel = CookieeCollectionViewModel()

    
    var body: some View {
        VStack {
            Text("쿠키 모아보기")
                .font(Font.Head1_B)
                .foregroundStyle(Color.Brown00)
                .frame(height: 44)
            
            VStack(spacing: 0) {
                ForEach(cookieeCollectionViewModel.cookieeCollectionList, id:\.id) { category in
                    CategoryListRowViewForCollection(
                        id: category.categoryId.description,
                        name: category.categoryName,
                        color: category.categoryColor,
                        isCollectionExist: category.collectionExist
                    )
                }
            }

            Spacer()
        }
        .onAppear() {
            DispatchQueue.main.async {
                cookieeCollectionViewModel.loadCookieeCollectionListData()
           }
        }
    }
}

#Preview {
    CookieeCollectionView()
}

// MARK: - 카테고리 리스트 (수정 버튼, 삭제 버튼)
struct CategoryListRowViewForCollection: View {
    @State var id: String = ""
    @State var name: String = ""
    @State var color: String
    @State var isCollectionExist: Bool
    
        
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Rectangle()
                    .fill(Color(hex: color))
                    .frame(width: 25, height: 25)
                    .cornerRadius(5.0)
                    .padding(.trailing, 20)
                
                HStack {
                    Text(name)
                        .font(.Body0_M)
                        .foregroundStyle(Color.Gray07)
                    Spacer()
                }
                
                if isCollectionExist {
                    Image("CookieeIcon_fill")

                }
            }
            .frame(height: 48)
            
            Divider()
                .foregroundStyle(Color.Gray01)
        }
        .padding(.horizontal, 20)
    }
}
