//
//  TestViewModel.swift
//  Cookiee
//
//  Created by minseo Kyung on 10/20/24.
//

import SwiftUI
import PhotosUI
import UIKit

@MainActor final class ImagePickerForEventViewModel: ObservableObject {
    
    @MainActor final class ImageAttachment: ObservableObject, Identifiable {
                
        enum Status {
            case loading
            case finished(UIImage)
            case failed(Error)
            
            var isFailed: Bool {
                return switch self {
                case .failed: true
                default: false
                }
            }
        }
        
        enum LoadingError: Error {
            case contentTypeNotSupported
        }
        
        private let pickerItem: PhotosPickerItem
        
        @Published var imageStatus: Status?
        
        nonisolated var id: String {
            pickerItem.identifier
        }
        
        init(_ pickerItem: PhotosPickerItem) {
            self.pickerItem = pickerItem
        }
        
        
        func loadImage() async {
            guard imageStatus == nil || imageStatus?.isFailed == true else {
                return
            }
            imageStatus = .loading
            do {
                if let data = try await pickerItem.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    imageStatus = .finished(uiImage)
                } else {
                    throw LoadingError.contentTypeNotSupported
                }
            } catch {
                imageStatus = .failed(error)
            }
        }
        
        var size: CGSize? {
            if case let .finished(uiImage) = imageStatus {
                return uiImage.size
            }
            return nil
        }
    }
    
    /// An array of items for the picker's selected photos.
    ///
    /// On set, this method updates the image attachments for the current selection.
    @Published var selection = [PhotosPickerItem]() {
        didSet {
            // Update the attachments according to the current picker selection.
            let newAttachments = selection.map { item in
                // Access an existing attachment, if it exists; otherwise, create a new attachment.
                attachmentByIdentifier[item.identifier] ?? ImageAttachment(item)
            }
            // Update the saved attachments array for any new attachments loaded in scope.
            let newAttachmentByIdentifier = newAttachments.reduce(into: [:]) { partialResult, attachment in
                partialResult[attachment.id] = attachment
            }
            // To support asynchronous access, assign new arrays to the instance properties rather than updating the existing arrays.
            attachments = newAttachments
            attachmentByIdentifier = newAttachmentByIdentifier
        }
    }
    
    /// An array of image attachments for the picker's selected photos.
    @Published var attachments = [ImageAttachment]()
    
    /// A dictionary that stores previously loaded attachments for performance.
    private var attachmentByIdentifier = [String: ImageAttachment]()
    
    @Published var isPhotoPickerPresented: Bool = false
}

/// A extension that handles the situation in which a picker item lacks a photo library.
private extension PhotosPickerItem {
    var identifier: String {
        guard let identifier = itemIdentifier else {
            fatalError("The photos picker lacks a photo library.")
        }
        return identifier
    }
}
