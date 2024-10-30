//
//  downscaleTOjpegData.swift
//  Cookiee
//
//  Created by minseo Kyung on 10/27/24.
//

import SwiftUI

extension UIImage {
    public func downscaleTOjpegData(maxBytes: UInt) -> Data {
        var quality = 1.0
        var compressedData: Data? = nil
        
        while quality > 0 {
            compressedData = jpegData(compressionQuality: quality)
            guard let jpeg = compressedData else { return Data() }
            
            if jpeg.count <= maxBytes {
                return jpeg
            }
            quality -= 0.1
        }
        
        print("❌ downscaleTOjpegData: maxBytes를 넘음.")
        return compressedData ?? Data()
    }
}

