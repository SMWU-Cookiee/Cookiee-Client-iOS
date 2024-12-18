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
        GeometryReader { geometry in
            VStack {
                Text("쿠키 모아보기")
                    .font(Font.Head1_B)
                    .foregroundStyle(Color.Brown00)
                    .frame(height: 44)
                
                VStack(spacing: 0) {
                    if cookieeCollectionViewModel.cookieeCollectionList.isEmpty {
                        VStack(alignment: .center) {
                            
                            Image("CookieeWithQuestionMark")
                                .frame(width: 74, height: 74)
                                .padding(.top, geometry.size.height / 3)
                            
                            Text("모아볼 카테고리가 없어요!")
                                .font(Font.Body0_B)
                                .foregroundStyle(Color.Brown00)
                                .padding(.top, 13)
                            
                            Text("새로운 카테고리를 등록해서 모아보기를 시작하세요!")
                                .font(Font.Body1_M)
                                .foregroundStyle(Color.Brown03)
                                .padding(.top, 1)
                            
                        }
                        .frame(width: geometry.size.width)
                    } else {
                        ForEach(cookieeCollectionViewModel.cookieeCollectionList, id:\.id) { category in
                            CategoryListRowViewForCollection(
                                id: category.categoryId,
                                name: category.categoryName,
                                color: category.categoryColor,
                                isCollectionExist: category.collectionExist
                            )
                        }
                    }
                }

                Spacer()
            }
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

// MARK: - 카테고리 리스트
struct CategoryListRowViewForCollection: View {
    @State var id: Int64
    @State var name: String
    @State var color: String
    @State var isCollectionExist: Bool
    
        
    var body: some View {
        VStack(spacing: 0) {
            NavigationLink(
                destination: CookieeCollectionDetailView(id: id),
                label: {
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
                }
            )

            Divider()
                .foregroundStyle(Color.Gray01)
        }
        .padding(.horizontal, 20)
    }
}


//HStack {
//    NavigationLink(
//        destination: DevelopersView(),
//        label: {
//            Text("개발자 정보")
//                .font(.Body1_M)
//                .foregroundStyle(Color.black)
//            Spacer()
//            Image("ChevronRightSmall")
//                .padding(.horizontal, 10)
//        }
//    )
//    .frame(height: 32)
//}
