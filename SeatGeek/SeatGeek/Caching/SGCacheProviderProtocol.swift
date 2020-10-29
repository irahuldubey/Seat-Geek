//
//  CacheProvider.swift
//  SeatGeek
//
//  Created by Rahul Dubey on 10/27/20.
//  Copyright © 2020 com.seatgeek.org. All rights reserved.
//

import Foundation

public protocol SGCacheProviderProtocol {
    
    func load(key: String) -> Data?
    
    func save(key: String, value: NSData?)
    
    func clearCache()
    
}
