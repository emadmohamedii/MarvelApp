//
//  UIImageView+Loading.swift
//  CommonUI
//
//  Created by Emad Habib on 08/11/2024.
//
import UIKit
import Kingfisher

public extension UIImageView {
    func cancelDownloading() {
        kf.cancelDownloadTask()
    }
    
    func download(with url: String,placeholderImage: UIImage? = nil){
        if url == ""{
            self.image = placeholderImage
            return
        }
        guard let imageURL = URL.init(string: url) else{
            self.image = placeholderImage
            return
        }
        DispatchQueue.main.async {
            self.kf.indicatorType = .activity
            self.kf.setImage(
                with: imageURL,
                placeholder: placeholderImage,
                options: [
                    .transition(ImageTransition.fade(0.3)),
                    .forceTransition,
                    .keepCurrentImageWhileLoading
                ]
            )
        }
    }
}
