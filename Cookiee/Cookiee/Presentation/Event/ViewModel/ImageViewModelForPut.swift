//
//  ImageViewModelForPut.swift
//  Cookiee
//
//  Created by minseo Kyung on 10/26/24.
//

import Foundation
import UIKit

class ImageViewModelForPut: ObservableObject {
    @Published var uiImageList: [UIImage] = []
    
    func deleteFromList(index: Int) {
        uiImageList.remove(at: index)
    }

}
