//
//  ImageUrlToUIImage.swift
//  Cookiee
//
//  Created by minseo Kyung on 10/26/24.
//

import Foundation
import UIKit

func urlToUIImage(url: String, completion: @escaping (UIImage?) -> Void) {
    guard let url = URL(string: url) else {
        completion(nil)
        return
    }

    URLSession.shared.dataTask(with: url) { data, response, error in
        if let error = error {
            print("Error fetching image: \(error.localizedDescription)")
            completion(nil)
            return
        }

        guard let data = data, let image = UIImage(data: data) else {
            completion(nil)
            return
        }

        // 결과를 메인 스레드에서 반환
        DispatchQueue.main.async {
            completion(image)
        }
    }.resume()
}
