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
    @State var indexToDelete: Int = -1
    
    
    var body: some View {
        VStack {
            GeometryReader { proxy in
                let width = proxy.size.width - (trialingSpace - spacing)
                let adjustmentWidth = (trialingSpace / 2) - spacing
                
                HStack(spacing: spacing) {
                    ForEach(Array(imageViewModelForPut.uiImageList.enumerated()), id: \.element) { index, uiImage in
                        imageCard(for: uiImage, at: index, width: width, proxy: proxy)
                    }

                    
                    ForEach(Array(imagePickerForEventViewModel.attachments.enumerated()), id: \.element.id) { index, imageAttachment in
                        imageAttachmentCard(for: imageAttachment, at: index, width: width, proxy: proxy)
                    }


                    if (imageViewModelForPut.uiImageList.count + imagePickerForEventViewModel.attachments.count < 5) {
                        AddButtonView(proxy: proxy)
                    }
                }
                .padding(.horizontal, spacing)
                .offset(x: (CGFloat(currentIndex) * -width) + (currentIndex != 0 ? adjustmentWidth : 0) + offset)
                .gesture(dragGesture(width: width))
            }
            .animation(.easeInOut, value: offset == 0)
        }
        .frame(height: 360)
    }
    
    private func overlayForDeletion(at index: Int, uiImage: UIImage) -> some View {
            VStack {
                Button(action: {
                    imageViewModelForPut.deleteFromList(index: index)
                }, label: {
                    Image("TrashIconWhite")
                })
            }
            .frame(width: uiImage.size.width * 360 / uiImage.size.height, height: 360)
            .aspectRatio(contentMode: .fit)
            .background(Color.black.opacity(0.5))
            .onTapGesture {
                if (indexToDelete == index) {
                    indexToDelete = -1
                }
            }
        }

    private func overlayForDeletion(at index: Int, imageAttachment: ImagePickerForEventViewModel.ImageAttachment) -> some View {
        let width = imageAttachment.size?.width ?? 0 * 360 / (imageAttachment.size?.height ?? 1) 
        
        return VStack {
            Button(action: {
                imagePickerForEventViewModel.attachments.remove(at: index)
                indexToDelete = -1
            }, label: {
                Image("TrashIconWhite")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            })
        }
        .frame(width: width, height: 360)
        .background(Color.black.opacity(0.5))
        .onTapGesture {
            if (indexToDelete == index) {
                indexToDelete = -1
            }
        }
    }

    
    private func imageCard(for uiImage: UIImage, at index: Int, width: CGFloat, proxy: GeometryProxy) -> some View {
        ZStack {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 360)
                .onTapGesture {
                    indexToDelete = index
                }
                .overlayIf(indexToDelete == index, overlayForDeletion(at: index, uiImage: uiImage))

        }
        .frame(width: proxy.size.width - trialingSpace)
        .background(Color.white)
    }
    
    private func imageAttachmentCard(for imageAttachment: ImagePickerForEventViewModel.ImageAttachment, at index: Int, width: CGFloat, proxy: GeometryProxy) -> some View {
        ZStack {
            ImageAttachmentView(imageAttachment: imageAttachment)
                .onTapGesture {
                    indexToDelete = index
                }
                .overlayIf(indexToDelete == index, overlayForDeletion(at: index, imageAttachment: imageAttachment))
        }
        .frame(width: proxy.size.width - trialingSpace)
        .background(Color.white)
    }
    
    private func dragGesture(width: CGFloat) -> some Gesture {
        DragGesture()
            .updating($offset) { value, out, _ in
                out = (value.translation.width / 1.5)
            }
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
    }
    
    private func AddButtonView(proxy: GeometryProxy) -> some View {
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
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.Gray04, lineWidth: 1))
        }
        .frame(width: proxy.size.width - trialingSpace)
        .background(Color.white)
    }
}
