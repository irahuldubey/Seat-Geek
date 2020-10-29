//
//  SGSearchResultCell.swift
//  SeatGeek
//
//  Created by Rahul Dubey on 10/25/20.
//  Copyright © 2020 com.seatgeek.org. All rights reserved.
//

import Foundation
import UIKit

public final class SGSearchResultCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var sgImageView: UIImageView!
    @IBOutlet weak var heartImageView: UIImageView!
    
    private var sgService: SGServiceAPI = SGService()
    private var sgCacheManager: SGCacheManagerProtocol = SGCacheManager.shared
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = .white
        self.contentView.backgroundColor = .white
        self.sgImageView.layer.cornerRadius = 7.0
        self.sgImageView.clipsToBounds = true
        self.heartImageView.isHidden = true
        self.sgImageView.contentMode = .scaleAspectFill
    }
    
    override public func prepareForReuse() {
        self.titleLabel.text = nil
        self.timeLabel.text = nil
        self.sgImageView.image = nil
        self.locationLabel.text = nil
        self.heartImageView.isHidden = true
    }
    
    public func setUp(with event: SGEventModel) {
        
        self.downloadImage(with: event.imageUrl)
        
        // Update the UI on the main Queue
        DispatchQueue.main.async {
            self.titleLabel.text = event.title
            self.locationLabel.text = event.location
            self.timeLabel.text = Date.formatDateDisplayValueFrom(string: event.date)?.formatInDayMonthYearValue()
            self.heartImageView.isHidden = !event.isFavorite
        }
    }
    
    // We can use third party SDK to download image, Kingfisher, SDWebImage are few options which does the download and caching of the images, for this exercise I wanted to avoid using any third party SDK because of min requirement.
    private func downloadImage(with imageURL: String) {
        let imageDownloadService = ImageDownloadManager.sharedInstance
        imageDownloadService.downloadImage(with: imageURL) { [weak self] (image) in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                strongSelf.sgImageView.image = image
            }
        }
    }
}

// MARK: isFavorite
extension SGSearchResultCell {
    private func isFavoriteEvent(identifier: String) -> Bool {
        if let value = sgCacheManager[identifier] {
            if let isFav = try? JSONDecoder().decode(Bool.self, from: value) {
                return isFav
            }
        }
        return false
    }
}
