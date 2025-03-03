//
//  ImageCarousel.swift
//  Cookiee
//
//  Created by minseo Kyung on 10/20/24.
//

import SwiftUI
import PhotosUI

struct ImageCarouselForPhotoPicker: View {
    @ObservedObject var viewModel: ImagePickerForEventViewModel

    var spacing: CGFloat = 15
    var trialingSpace: CGFloat = 30
    
    @GestureState var offset: CGFloat = 0
    @State var currentIndex: Int = 0
    @State var indexToDeleteInImageAttachment: Int = -1
    
    var body: some View {
        VStack {
            GeometryReader { proxy in
                let width = proxy.size.width - (trialingSpace - spacing)
                let adjustmentWidth = (trialingSpace / 2) - spacing
                
                HStack(spacing: spacing) {
                    ForEach(Array(viewModel.attachments.enumerated()), id: \.element.id) { index, imageAttachment in
                        imageAttachmentCard(for: imageAttachment, at: index, width: width, proxy: proxy)
                    }
                    if (viewModel.selection.count < 5) {
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
    
    private func overlayForDeletion(at index: Int, imageAttachment: ImagePickerForEventViewModel.ImageAttachment) -> some View {
        VStack {
            Button(action: {
                viewModel.attachments.remove(at: index)
                viewModel.selection.remove(at: index)
                indexToDeleteInImageAttachment = -1
            }, label: {
                Image("TrashIconWhite")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 34, height: 34)
            })
        }
        .frame(width: (imageAttachment.size?.width ?? 360) * 360 / (imageAttachment.size?.height ?? 360), height: 360)
        .background(Color.black.opacity(0.5))
        .onTapGesture {
            if (indexToDeleteInImageAttachment == index) {
                indexToDeleteInImageAttachment = -1
            }
        }
    }
    
    private func imageAttachmentCard(for imageAttachment: ImagePickerForEventViewModel.ImageAttachment, at index: Int, width: CGFloat, proxy: GeometryProxy) -> some View {
        ZStack {
            ImageAttachmentView(imageAttachment: imageAttachment)
                .onTapGesture {
                    indexToDeleteInImageAttachment = index
                }
                .overlayIf(indexToDeleteInImageAttachment == index, overlayForDeletion(at: index, imageAttachment: imageAttachment))
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

                if (viewModel.selection.count < 5) {
                    currentIndex = max(min(currentIndex + Int(roundIndex), viewModel.attachments.count), 0)
                } else {
                    currentIndex = max(min(currentIndex + Int(roundIndex), viewModel.attachments.count - 1), 0)
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
                viewModel.isPhotoPickerPresented = true
            }, label: {
                VStack {
                    Image("PlusBrown")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .padding(10)
                }
                .frame(width: 270, height: 360)
            })
        }
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.Brown04, lineWidth: 1)
        )
        .frame(width: proxy.size.width - trialingSpace)
        .background(Color.white)
    }
}

struct ImageAttachmentView: View {
    
    @ObservedObject var imageAttachment: ImagePickerForEventViewModel.ImageAttachment
    
    var body: some View {
        HStack {
            switch imageAttachment.imageStatus {
            case .finished(let image):
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 360)
            case .failed:
                Image(systemName: "exclamationmark.triangle.fill")
            default:
                ProgressView()
            }
        }.task {
            await imageAttachment.loadImage()
        }
    }
}

struct InitialAddMessageCardView: View {
    @ObservedObject var viewModel: ImagePickerForEventViewModel
    
    var body: some View {
        VStack {
            Button(action: {
                viewModel.isPhotoPickerPresented = true
            }, label: {
                VStack {
                    Image("ImageIconBrown04")
                        .resizable()
                        .frame(width: 35, height: 35)
                        .padding(10)
                    
                    Text("최대 5장까지 추가할 수 있어요.")
                        .foregroundStyle(Color.Brown04)
                        .font(Font.Body1_M)
                }
                .frame(width: 270, height: 360)
            })
        }
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.Brown04, lineWidth: 1)
        )
    }
}
