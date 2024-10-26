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

    var spacing: CGFloat = 10
    var trialingSpace: CGFloat = 30
    
    @GestureState var offset: CGFloat = 0
    @State var currentIndex: Int = 0
    
    var body: some View {
        VStack {
            GeometryReader { proxy in
                let width = proxy.size.width - (trialingSpace - spacing)
                let adjustmentWidth = (trialingSpace / 2) - spacing
                
                HStack(spacing: spacing) {
                    ForEach(viewModel.attachments) { imageAttachment in
                        ImageAttachmentView(imageAttachment: imageAttachment)
                        .frame(width: proxy.size.width - trialingSpace)
                    }
                    if (viewModel.selection.count < 5) {
                        VStack {
                            Button(action: {
                                viewModel.isPhotoPickerPresented = true
                            }, label: {
                                VStack {
                                    Image("PlusGray")
                                        .resizable()
                                        .frame(width: 35, height: 35)
                                        .padding(10)
                                }
                                .frame(width: 270, height: 360)
                            })
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.Gray04, lineWidth: 1)
                        )
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
                )
            }
            .animation(.easeInOut, value: offset == 0)
        }
        .frame(height: 360)
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
                    Image("Photo")
                        .resizable()
                        .frame(width: 35, height: 35)
                        .padding(10)
                    
                    Text("최대 5장까지 추가할 수 있어요.")
                        .foregroundStyle(Color.Gray04)
                        .font(Font.Body1_M)
                }
                .frame(width: 270, height: 360)
            })
        }
        
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.Gray04, lineWidth: 1)
        )
    }
}
