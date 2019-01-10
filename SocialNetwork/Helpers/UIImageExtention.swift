//
//  UIImageED.swift
//  SocialNetwork
//
//  Created by Ira Golubovich on 1/9/19.
//  Copyright © 2019 Ira Golubovich. All rights reserved.
//

import UIKit


extension UIImageView {
    func setRoundedImage(_ image: UIImage?) {
        guard let image = image else {
            return
        }
        DispatchQueue.main.async { [weak self]  in
            guard let strongSelf = self else { return }
            strongSelf.image = image
            strongSelf.roundedImage(10.0)
        }
    }
}

private extension UIImageView {
    func roundedImage(_ cornerRadius: CGFloat, withBorder: Bool = true) {
        layer.borderWidth = 1.0
        layer.masksToBounds = false
        layer.cornerRadius = cornerRadius
        if withBorder {
            layer.borderColor = UIColor.white.cgColor
        }
        clipsToBounds = true
    }
}
//    extension UIImage{
//    
//    static func downloadImageFromUrl(_ url: String, completionHandler: @escaping (UIImage?) -> Void) {
//        guard let url = URL(string: url) else {
//            completionHandler(nil)
//            return
//        }
//        let task: URLSessionDataTask = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) -> Void in
//            guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
//                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
//                let data = data, error == nil,
//                let image = UIImage(data: data) else {
//                    completionHandler(nil)
//                    return
//            }
//            completionHandler(image)
//        })
//        task.resume()
//    }
//}
