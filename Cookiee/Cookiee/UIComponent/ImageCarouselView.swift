//
//  ImageCarouselView.swift
//  Cookiee
//
//  Created by minseo Kyung on 8/16/24.
//

import SwiftUI

struct ImageCarouselView: View {
    var imageUrls: [String]
    var spacing: CGFloat
    var trialingSpace: CGFloat
    @Binding var index: Int
    
    @GestureState var offset: CGFloat = 0
    @State var currentIndex: Int = 0
    
    init(spacing: CGFloat = 10, trialingSpace: CGFloat = 30, index: Binding<Int>, imageUrls: [String]) {
        self.imageUrls = imageUrls
        self.spacing = spacing
        self.trialingSpace = trialingSpace
        self._index = index
    }
    
    var body: some View {
        VStack {
            GeometryReader { proxy in
                let width = proxy.size.width - (trialingSpace - spacing)
                let adjustmentWidth = (trialingSpace / 2) - spacing
                
                HStack(spacing: spacing) {
                    ForEach(Array(imageUrls.enumerated()), id: \.offset) { offset, url in
                        fetchImageByURL(url: url)
                        .frame(width: proxy.size.width - trialingSpace)
                    }
                }
                .padding(.horizontal, spacing)
                .offset(x: (CGFloat(currentIndex) * -width) + (currentIndex != 0 ? adjustmentWidth : 0) + offset)
                .gesture(
                    DragGesture()
                        .updating($offset, body: { value, out, _ in
                            out = (value.translation.width / 1.5)
                        })
                        .onEnded { value in
                            let offsetX = value.translation.width
                            let progress = -offsetX / width
                            let roundIndex = progress.rounded()
                            
                            currentIndex = max(min(currentIndex + Int(roundIndex), imageUrls.count - 1), 0)
                            
                            index = currentIndex
                        }
                        .onChanged { value in
                            let offsetX = value.translation.width
                            let progress = -offsetX / width
                            let roundIndex = progress.rounded()
                            
                            index = max(min(currentIndex + Int(roundIndex), imageUrls.count - 1), 0)
                        }
                )
            }
            .animation(.easeInOut, value: offset == 0)
            
            HStack(spacing: 8) {
                ForEach(0..<imageUrls.count, id: \.self) { i in
                    Button(action: {
                        withAnimation {
                            currentIndex = i
                            index = i
                        }
                    }) {
                        Circle()
                            .fill(i == currentIndex ? Color.Brown00 : Color.Brown04)
                            .frame(width: 6, height: 6)
                    }
                }
            }
        }
    }
}


