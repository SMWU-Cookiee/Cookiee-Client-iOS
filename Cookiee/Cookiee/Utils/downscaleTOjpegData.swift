//
//  downscaleTOjpegData.swift
//  Cookiee
//
//  Created by minseo Kyung on 10/27/24.
//

import SwiftUI

extension UIImage {
    public func downscaleTOjpegData(maxBytes: UInt) -> Data? {
        var quality = 1.0
        while quality > 0 {
            guard let jpeg = jpegData(compressionQuality: quality)
            else { return nil }
            if jpeg.count <= maxBytes {
                return jpeg
            }
            quality -= 0.1
        }
        return nil
    }
}
