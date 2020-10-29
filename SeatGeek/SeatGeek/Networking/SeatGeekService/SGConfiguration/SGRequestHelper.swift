//
//  SGUrlRequest.swift
//  SeatGeek
//
//  Created by Rahul Dubey on 10/25/20.
//  Copyright © 2020 com.seatgeek.org. All rights reserved.
//

import Foundation

public enum SeatGeekServiceType {
    case searchQuery
    case detailsEvent
}

struct QueryItemKeys {
    static let page = "page"
    static let perPage = "per_page"
    static let clientId = "client_id"
    static let query = "q"
}

public struct Pagination {
    let pageNumber: String
    let pageLimit: String
}

// Need to make a generic class to handle the URLRequest for all the service requests
final class SGRequestHelper {
    
    static func searchURL(with queryString: String, pagination: Pagination) -> URLRequest? {
     
        let urlQueryParameters: [String: String] = [QueryItemKeys.page : pagination.pageNumber,
                                                    QueryItemKeys.perPage: pagination.pageLimit,
                                                    QueryItemKeys.query: queryString]
        
        let sgServiceConfiguration = SGServiceConfiguration.init(withServiceType: .searchQuery,
                                                     queryParams: urlQueryParameters,
                                                     queryString: queryString)
        
        let sgServiceURL = sgServiceConfiguration.getURL()
        
        guard let url = sgServiceURL else { return nil }
        
        var urlRequest = URLRequest.init(url: url)
        urlRequest.httpMethod = RestConfiguration.RequestType.GET.rawValue
        urlRequest.timeoutInterval = Double(RestConfiguration.timeoutValue)
        urlRequest.cachePolicy = URLRequest.CachePolicy.reloadRevalidatingCacheData
        urlRequest.addValue(RestConfiguration.HTTPHeaderFieldValue.json.rawValue,
                            forHTTPHeaderField: RestConfiguration.HTTPHeaderFieldKey.contentType.rawValue)
        return urlRequest
    }
    
    static func eventDetails(with eventId: String) -> URLRequest? {
        
        let sgServiceConfiguration = SGServiceConfiguration.init(withServiceType: .detailsEvent, eventId: eventId)
        let sgServiceURL = sgServiceConfiguration.getURL()

        guard let url = sgServiceURL else { return nil }

        var urlRequest = URLRequest.init(url: url)
        urlRequest.httpMethod = RestConfiguration.RequestType.GET.rawValue
        urlRequest.timeoutInterval = Double(RestConfiguration.timeoutValue)
        urlRequest.cachePolicy = URLRequest.CachePolicy.reloadRevalidatingCacheData
        urlRequest.addValue(RestConfiguration.HTTPHeaderFieldValue.json.rawValue,
                            forHTTPHeaderField: RestConfiguration.HTTPHeaderFieldKey.contentType.rawValue)
        return urlRequest
    }
}
