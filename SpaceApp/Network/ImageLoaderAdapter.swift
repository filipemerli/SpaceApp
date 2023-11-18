//
//  ImageLoaderAdapter.swift
//  SpaceApp
//
//  Created by Filipe Merli on 14/11/2023.
//

import UIKit

protocol ImageLoaderProtocol: AnyObject {
    func loadImage(at url: URL, imageView: UIImageView)
    func cancelImageLoad(imageView: UIImageView)
}

class ImageLoaderAdapter: ImageLoaderProtocol {
// TODO: One layer to convert String to URL and if it fails, do not go to network.
    func loadImage(at url: URL, imageView: UIImageView) {
        UIImageLoader.loader.load(url, for: imageView)
    }

    func cancelImageLoad(imageView: UIImageView) {
        UIImageLoader.loader.cancel(for: imageView)
    }
}
