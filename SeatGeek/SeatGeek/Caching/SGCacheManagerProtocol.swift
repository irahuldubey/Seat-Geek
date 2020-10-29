//
//  CacheManagerProtocol.swift
//  SeatGeek
//
//  Created by Rahul Dubey on 10/27/20.
//  Copyright © 2020 com.seatgeek.org. All rights reserved.
//

import Foundation

public protocol SGCacheManagerProtocol {
    
    var primaryCache: SGCacheProviderProtocol { get set }
    
    var secondaryCache: SGCacheProviderProtocol? { get set }
    
    subscript(key: String) -> Data? { get set }
    
    func clearCache()
}
