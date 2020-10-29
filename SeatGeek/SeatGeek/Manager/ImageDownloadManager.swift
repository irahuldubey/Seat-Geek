//
//  ImageDownloadManager.swift
//  SeatGeek
//
//  Created by Rahul Dubey on 10/27/20.
//  Copyright © 2020 com.seatgeek.org. All rights reserved.
//

import Foundation
import UIKit

public final class ImageDownloadManager {
    
    //Create an instance of Seat Geek Service API
    private let sgService: SGServiceAPI
    
    init(with sgService: SGServiceAPI = SGService()) {
        self.sgService = sgService
    }
    
    //Create a default Global Queue
    private let imageQueue = DispatchQueue.global()
    
    //Create a Singleton Class
    static let sharedInstance = ImageDownloadManager()
    
    public func downloadImage(with imageURL: String, withCompletionHandler completion: @escaping (UIImage?) -> Void) {
        
        guard !imageURL.isEmpty else {
            completion(nil)
            return
        }
        
        imageQueue.async {
            do {
                try self.sgService.fetchImage(with: imageURL) { (data) in
                    DispatchQueue.main.async {
                        if let data = data {
                            let image = UIImage.init(data: data)
                            completion(image)
                        } else {
                            completion(nil)
                        }
                    }
                }
            } catch {
                debugPrint("Error downloading image")
            }
        }
    }
}
