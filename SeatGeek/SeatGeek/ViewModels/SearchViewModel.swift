//
//  SearchViewModel.swift
//  SeatGeek
//
//  Created by Rahul Dubey on 10/25/20.
//  Copyright © 2020 com.seatgeek.org. All rights reserved.
//

import Foundation
import UIKit

protocol SearchViewModelDelegate: class {
    func onFetchSuccess(with newIndexPathsToReload: [IndexPath]?)
    func onFetchFailure(with error: String)
}

internal final class SearchViewModel {
    
    private weak var delegate: SearchViewModelDelegate?
    private var sbCacheManager: SBCacheManagerProtocol?
    private var eventResult =  [EventModel]()
    
    private var isFetchInProgress = false
    
    private var currentPage = 1
    private var totalCount = 0
    
    private let sgService: SGServiceAPI
    private var currentSearchText: String = ""
    private var metaObject: SGMeta?
    private var debounce: Debouncer = Debouncer(delay: 0.2)
    
    private let DEFAULT_LIMIT = "20"
    
    //MARK: - Initializer
    
    init(withAPI sgService: SGServiceAPI = SGService(),
         delegate: SearchViewModelDelegate,
         sbCacheManager: SBCacheManagerProtocol = SBCacheManager.shared) {
        self.sgService = sgService
        self.delegate = delegate
        self.sbCacheManager = sbCacheManager
    }
    
    var totalSearchResultCount: Int {
        return totalCount
    }
    
    var currentCount: Int {
        return self.eventResult.count
    }
    
    func event(at index: Int) -> EventModel {
        return self.eventResult[index]
    }
    
    // Update the data source in this class and pass the index path to the view controller to update the search results viewcontroller
    func eventIndexPath(for identifier: String, isFavorite: Bool) -> IndexPath? {
        for (index, value) in  eventResult.enumerated() {
            if value.identifier == identifier {
                let eventModel = EventModel.init(identifier: value.identifier,
                                                 title: value.title,
                                                 shortTitle: value.shortTitle,
                                                 location: value.location,
                                                 date: value.date,
                                                 imageUrl: value.imageUrl,
                                                 isFavorite: isFavorite)
                eventResult.remove(at: index)
                eventResult.insert(eventModel, at: index)
                return IndexPath.init(row: index, section: 0)
            }
        }
        return nil
    }
    
    func removeAllEvents() {
        self.eventResult.removeAll()
    }
    
    func cancelFetch() {
        debounce.cancelWorkItem()
    }
    
    func fetchResults(for query: String) {
        
        guard !isFetchInProgress else { return }
        
        guard !query.isEmpty else { return }
        
        currentSearchText = query
        isFetchInProgress = true
        removeAllEvents() // remove current search text and add new one when searched for it
        
        let pagination: Pagination = Pagination(pageNumber: String(1), pageLimit: DEFAULT_LIMIT)
        
        // Throttle for 200ms, this is usualy done to avoid extra search query item if user is not interested in those keywords
        debounce.dispatchDebounce {
            do {
                try self.sgService.fetchEvent(withQuery: query, pagination: pagination, withCompletionHandler: { (result) in
                    switch(result) {
                    case .success(let eventResponse):
                        // Increase the current page count to 2 in the first fetch
                        self.currentPage += 1
                        self.isFetchInProgress = false
                        self.totalCount = eventResponse.meta?.total ?? 0
                        let eventList = self.massageEventData(response: eventResponse)
                        self.eventResult.append(contentsOf: eventList)
                        DispatchQueue.main.async {
                            self.delegate?.onFetchSuccess(with: .none)
                        }
                    case .failure(let error):
                        self.isFetchInProgress = false
                        DispatchQueue.main.async {
                            self.delegate?.onFetchFailure(with: error.displayError)
                        }
                    }
                })
            }
            catch _ {
                //Add to Logger Error
                debugPrint("Search View Model: unable to fetch result for query \(query)")
            }
        }
    }
    
    
    func loadMoreResultsOnPagination() {
        guard !isFetchInProgress else { return }
        
        guard !self.currentSearchText.isEmpty else { return }
        
        isFetchInProgress = true

        // When we have less than page limits set the limit what is remaining items than 20 items
        let pageDifference = self.totalCount - self.currentCount
        let pageTotal = (pageDifference > 20) ? DEFAULT_LIMIT : String(pageDifference)
        let pagination: Pagination = Pagination(pageNumber: String(self.currentPage), pageLimit: pageTotal)

        do {
            try self.sgService.fetchEvent(withQuery: self.currentSearchText, pagination: pagination, withCompletionHandler: { (result) in
                switch(result) {
                case .success(let eventResponse):
                    self.currentPage += 1
                    self.isFetchInProgress = false
                    self.totalCount = eventResponse.meta?.total ?? 0
                    let eventList = self.massageEventData(response: eventResponse)
                    self.eventResult.append(contentsOf: eventList)
                    
                    // For pagination page is greater than 1
                    if let page = eventResponse.meta?.page, page > 1 {
                        DispatchQueue.main.async {
                            let indexPathsToReload = self.calculateIndexPathsToReload(from: eventList)
                            self.delegate?.onFetchSuccess(with: indexPathsToReload)
                        }
                    }
                    
                case .failure(let error):
                    self.isFetchInProgress = false
                    DispatchQueue.main.async {
                        self.delegate?.onFetchFailure(with: error.displayError)
                    }
                }
            })
        }
        catch _ {
            //Add to Logger Error
            debugPrint("Search View Model: unable to fetch next results for query \(currentSearchText)")
        }
    }
    
    private func massageEventData(response eventObj: SGResponse) -> [EventModel] {
        let events = eventObj.events
        let compactEvents = events.compactMap { (event) -> EventModel? in
            return EventModel(identifier: String(event.identifier),
                              title: event.title,
                              shortTitle: event.shortTitle,
                              location: event.venue.displayLocation,
                              date: event.datetime,
                              imageUrl: event.performers?.first?.image ?? "",
                              isFavorite: isFavoriteEvent(identifier: String(event.identifier))
            )}
        return compactEvents
    }
    
    private func calculateIndexPathsToReload(from event: [EventModel]) -> [IndexPath] {
        let startIndex = eventResult.count - event.count
        let endIndex = startIndex + event.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
    
    private func isFavoriteEvent(identifier: String) -> Bool {
        guard let cacheManager = sbCacheManager else {
            return false
        }
        
        if let value = cacheManager[identifier], let isFav = try? JSONDecoder().decode(Bool.self, from: value)  {
            return isFav
        }
        
        return false
    }
}

