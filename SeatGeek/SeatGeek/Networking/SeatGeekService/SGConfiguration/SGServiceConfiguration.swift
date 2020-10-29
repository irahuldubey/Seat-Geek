//
//  API.swift
//  SeatGeek
//
//  Created by Rahul Dubey on 10/24/20.
//  Copyright © 2020 com.seatgeek.org. All rights reserved.
//

import Foundation

final public class SGServiceConfiguration {
    
    private let api = "api.seatgeek.com"
    private let version = "2"
    private let endpoints = "events"
    private let clientId = "MjEzNjIxMjZ8MTYwMzM0NjQyNy4xNTMzMjA4"
    
    public var eventId: String?
    public var queryString: String?
    public var queryParams: [String: String]?
    public var serviceType: SeatGeekServiceType
    
    private var path: String {
        if serviceType == .searchQuery {
            return "/\(version)/\(endpoints)"
        }
        
        if serviceType == .detailsEvent,
            let eventId = self.eventId {
            return "/\(version)/\(endpoints)/\(eventId)"
        }
        
        return ""
    }
    
    private var scheme: String {
        return RestConfiguration.HttpProtocol.HTTPS.rawValue
    }
    
    private var urlQueryItem: [URLQueryItem] {
        var queryItems: [URLQueryItem] = [URLQueryItem.init(name: QueryItemKeys.clientId, value: clientId)]
        if let optionalQueryItems = queryParams {
            optionalQueryItems.forEach { (key, value) in
                queryItems.append(URLQueryItem.init(name: key, value: value))
            }
            return queryItems
        }
        return queryItems
    }
    
    public init(withServiceType sgServiceType: SeatGeekServiceType,
                queryParams: [String: String]? = nil,
                queryString: String? = nil,
                eventId: String? = nil) {
        self.serviceType = sgServiceType
        self.queryString = queryString
        self.eventId = eventId
        self.queryParams = queryParams
    }
    
    private func getUrlComponents() -> URLComponents? {
        guard var components = URLComponents(string: self.path) else { return nil }
        components.host = api
        components.scheme = scheme
        components.queryItems = urlQueryItem
        return components
    }
    
    public func getURL() -> URL? {
        if let components = getUrlComponents(),
            let url = components.url {
            return url
        }
        return nil
    }
}
