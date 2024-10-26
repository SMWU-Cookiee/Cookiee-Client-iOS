//
//  ImageUrlToUIImage.swift
//  Cookiee
//
//  Created by minseo Kyung on 10/26/24.
//

import Foundation
import UIKit

func urlToUIImage(url: String) -> UIImage? {
    guard let url = URL(string: url) else { return nil }
    do {
        let data = try Data(contentsOf: url)
        return UIImage(data: data)
    } catch {
        return nil
    }
}
