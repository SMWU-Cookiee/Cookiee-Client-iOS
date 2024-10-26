//
//  ImageCarouselForUIImage.swift
//  Cookiee
//
//  Created by minseo Kyung on 10/26/24.
//

import SwiftUI

struct ImageCarouselForUIImage: View {
    @StateObject var imagePickerForEventViewModel: ImagePickerForEventViewModel
    @StateObject var imageViewModelForPut: ImageViewModelForPut

    var spacing: CGFloat = 10
    var trialingSpace: CGFloat = 30
    
    @GestureState var offset: CGFloat = 0
    @State var currentIndex: Int = 0
    @State var isDelete: Bool = false
    
    var body: some View {
        VStack {
            GeometryReader { proxy in
                let width = proxy.size.width - (trialingSpace - spacing)
                let adjustmentWidth = (trialingSpace / 2) - spacing
                
                HStack(spacing: spacing) {
                    ForEach(Array(imageViewModelForPut.uiImageList.enumerated()), id: \.element) { index, uiImage in
                        ZStack {
                            
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 360)
                                .onTapGesture {
                                    isDelete.toggle()
                                }
                                .overlayIf(
                                    isDelete,
                                    VStack {
                                        Button(action: {
                                            if isDelete {
                                                imageViewModelForPut.deleteFromList(index: index)
                                            }
                                        }, label: {
                                            Image("TrashIconWhite")
                                        })
                                    }
                                        .frame(width:  uiImage.size.width * 360 / uiImage.size.height, height: 360)
                                        .aspectRatio(contentMode: .fit)
                                        .background(Color.black.opacity(0.5))
                                )
                        }
                        .frame(width: proxy.size.width - trialingSpace)
                    }


                    ForEach(imagePickerForEventViewModel.attachments) { imageAttachment in
                        ImageAttachmentView(imageAttachment: imageAttachment)
                        .frame(width: proxy.size.width - trialingSpace)
                    }

                    if (imageViewModelForPut.uiImageList.count + imagePickerForEventViewModel.attachments.count < 5) {
                        VStack {
                            Button(action: {
                                imagePickerForEventViewModel.isPhotoPickerPresented = true
                            }, label: {
                                VStack {
                                    Image("PlusGray")
                                        .resizable()
                                        .frame(width: 35, height: 35)
                                        .padding(10)
                                }
                            })
                            .frame(width: 270, height: 360)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.Gray04, lineWidth: 1)
                            )
                        }
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
                            
                            if (imageViewModelForPut.uiImageList.count + imagePickerForEventViewModel.attachments.count < 5) {
                                currentIndex = max(min(currentIndex + Int(roundIndex), imageViewModelForPut.uiImageList.count + imagePickerForEventViewModel.attachments.count), 0)
                            } else {
                                currentIndex = max(min(currentIndex + Int(roundIndex), imageViewModelForPut.uiImageList.count + imagePickerForEventViewModel.attachments.count - 1), 0)
                            }
                            
                        }
                        .onChanged { value in
                            let offsetX = value.translation.width
                            let progress = -offsetX / width
                            _ = progress.rounded()
                        }
                )
            }
            .animation(.easeInOut, value: offset == 0)
        }
        .frame(height: 360)
    }
}
