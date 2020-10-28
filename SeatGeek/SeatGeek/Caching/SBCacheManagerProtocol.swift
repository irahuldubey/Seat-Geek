//
//  CacheManagerProtocol.swift
//  SeatGeek
//
//  Created by Rahul Dubey on 10/27/20.
//  Copyright © 2020 com.seatgeek.org. All rights reserved.
//

import Foundation

public protocol SBCacheManagerProtocol {
    
    var primaryCache: SBCacheProviderProtocol { get set }
    
    var secondaryCache: SBCacheProviderProtocol? { get set }
    
    subscript(key: String) -> Data? { get set }
    
    func clearCache()
}
