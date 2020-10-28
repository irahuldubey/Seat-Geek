//
//  DetailsViewModel.swift
//  SeatGeek
//
//  Created by Rahul Dubey on 10/27/20.
//  Copyright © 2020 com.seatgeek.org. All rights reserved.
//

import Foundation
import UIKit

protocol DetailsViewModelDelegate: class {
    func onFetchSuccess(with event: EventModel)
    func onFetchFailure(with error: String)
}

internal final class DetailsViewModel {
    
    private weak var delegate: DetailsViewModelDelegate?
    private var sgCacheManager: SBCacheManagerProtocol?

    private var eventResult =  [EventModel]()
    private let sgService: SGServiceAPI

    
    //MARK: - Initializer
    
    init(withAPI sgService: SGServiceAPI = SGService(),
         delegate: DetailsViewModelDelegate,
         cacheManager: SBCacheManagerProtocol = SBCacheManager.shared) {
        self.sgService = sgService
        self.delegate = delegate
        self.sgCacheManager = cacheManager
    }

    func fetchEventDetails(with identifier: String) {
        
        guard identifier.count > 0  else { return }
        
        do {
            try sgService.fetchEventDetails(with: identifier) { (response) in
                switch response {
                case .success(response: let eventResponse):
                    DispatchQueue.main.async {
                        let eventModel = EventModel.init(identifier: String(eventResponse.identifier),
                                                         title: eventResponse.title,
                                                         shortTitle: eventResponse.shortTitle,
                                                         location: eventResponse.venue.displayLocation,
                                                         date: eventResponse.datetime,
                                                         imageUrl: eventResponse.performers?.first?.image ?? "",
                                                         isFavorite: self.isFavoriteEvent(identifier: String(eventResponse.identifier)))
                        self.delegate?.onFetchSuccess(with: eventModel)
                    }
                case .failure(error: let error):
                    DispatchQueue.main.async {
                        self.delegate?.onFetchFailure(with: error.displayError)
                    }
                }
            }
        } catch _ {
            debugPrint("Unable to fetch event details")
        }
    }
    
    private func isFavoriteEvent(identifier: String) -> Bool {
           guard let cacheManager = sgCacheManager else {
               return false
           }
           
           if let value = cacheManager[identifier] {
               if let isFav = try? JSONDecoder().decode(Bool.self, from: value) {
                   return isFav
               }
           }
           
           return false
    }
    
    func toggleFavorite(eventWith identifier: String, withCompletionHandler completion: (Bool) -> ()) {
        
        guard var cacheManager = sgCacheManager else {
            completion(false)
            return
        }
        
        if isFavoriteEvent(identifier: identifier) {
            if let boolData = try? JSONEncoder().encode(false) {
                cacheManager[identifier] = boolData
            }
            completion(false)
        } else {
            if let boolData = try? JSONEncoder().encode(true) {
                cacheManager[identifier] = boolData
            }
            completion(true)
        }
    }
}
