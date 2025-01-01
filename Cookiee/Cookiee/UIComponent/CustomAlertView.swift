//
//  AlertView.swift
//  Cookiee
//
//  Created by minseo Kyung on 10/9/24.
//

import SwiftUI

struct CustomAlertView<Content: View>: View {
    let content: Content
    let firstButton: CustomAlertButton
    let secondButton: CustomAlertButton?
    
    var body: some View {
        ZStack{
            Color.black.opacity(0.4).ignoresSafeArea()

            VStack(spacing: 0){
                content
                    .padding(.vertical, 25)
                Divider()
                HStack(spacing: 0){
                    firstButton
                    if secondButton != nil{
                        Divider()
                        secondButton
                    }
                }
                .font(Font.Body0_B)
                .frame(height: 45)
            }
            .frame(width: 267)
            .background(Color.white)
            .cornerRadius(10)
        }
    }
}

struct CustomAlertButton: View {
    typealias Action = () -> Void
    
    let action: Action
    let title: Text
    
    var body: some View {
        Button{
            action()
        } label: {
            title
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

extension View {
    func showCustomAlert<Content: View>(
        isPresented: Binding<Bool>,
        content: @escaping () -> Content,
        firstButton: CustomAlertButton,
        secondButton: CustomAlertButton? = nil
    ) -> some View {
        self
            .fullScreenCover(isPresented: isPresented) {
                ZStack {
                    Color.black.opacity(0.1)
                        .ignoresSafeArea()
                    CustomAlertView(
                        content: content(),
                        firstButton: firstButton,
                        secondButton: secondButton
                    )
                }
                .background(ClearBackground())
            }
            .transaction { transaction in
                transaction.disablesAnimations = isPresented.wrappedValue
            }
    }
}


struct ClearBackground: UIViewRepresentable {
    
    public func makeUIView(context: Context) -> UIView {
        
        let view = ClearBackgroundView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }

    public func updateUIView(_ uiView: UIView, context: Context) {}
}

class ClearBackgroundView: UIView {
    open override func layoutSubviews() {
        guard let parentView = superview?.superview else {
            return
        }
        parentView.backgroundColor = .clear
    }
}



#Preview {
    CustomAlertView(
        content:
            VStack {
                Text("카테고리 추가를 그만할까요?")
                    .font(.Head1_B)
                    .padding(.bottom, 9)
                Text("페이지를 나가면 복구가 어렵습니다.")
                    .font(.Body1_R)
            },
        firstButton: CustomAlertButton(
            action: {
                print("취소 버튼 눌림")
            }, title: Text("취소")
                .font(Font.Body0_B)
                .foregroundColor(.Gray04)),
        secondButton: CustomAlertButton(
            action: {
                print("확인 버튼 눌림")
            }, title: Text("확인")
                .font(Font.Body0_B)
                .foregroundColor(.Brown00))
    )
}


