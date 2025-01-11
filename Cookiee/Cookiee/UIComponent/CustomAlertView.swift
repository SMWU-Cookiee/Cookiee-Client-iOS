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

struct CustomAlertModifier<AlertContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    let alertContent: () -> AlertContent
    let firstButton: CustomAlertButton
    let secondButton: CustomAlertButton?

    func body(content: Content) -> some View {
        content
            .fullScreenCover(isPresented: $isPresented, content: {
                ZStack {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                    CustomAlertView(
                        content: alertContent(),
                        firstButton: firstButton,
                        secondButton: secondButton
                    )
                }
                .background(ClearBackground())
                .onAppear {
                    UIView.setAnimationsEnabled(false)
                }
                .onDisappear {
                    UIView.setAnimationsEnabled(true)
                }
            })
            .transaction { transaction in
                transaction.disablesAnimations = $isPresented.wrappedValue
            }
    }
}

extension View {
    func showCustomAlert<AlertContent: View>(
        isPresented: Binding<Bool>,
        alertContent: @escaping () -> AlertContent,
        firstButton: CustomAlertButton,
        secondButton: CustomAlertButton? = nil
    ) -> some View {
        self.modifier(
            CustomAlertModifier(
                isPresented: isPresented,
                alertContent: alertContent,
                firstButton: firstButton,
                secondButton: secondButton
            )
        )
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
