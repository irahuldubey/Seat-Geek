//
//  CacheManager.swift
//  SeatGeek
//
//  Created by Rahul Dubey on 10/27/20.
//  Copyright © 2020 com.seatgeek.org. All rights reserved.
//

import Foundation

public class SGCacheManager: SGCacheManagerProtocol {
    
    public static let shared: SGCacheManagerProtocol = SGCacheManager()
    
    public var primaryCache: SGCacheProviderProtocol = SGMemoryCacheProvider()
    public var secondaryCache: SGCacheProviderProtocol? = SGFileCacheProvider(cacheDir: "FavoriteDirectory")
    
    public subscript(key: String) -> Data? {
        get {
            guard let result = primaryCache.load(key: key) else {
                if let file = secondaryCache?.load(key: key) {
                    primaryCache.save(key: key, value: file as NSData?)
                    return file
                }
                return nil
            }
            return result
        }
        set {
            let data: NSData? = newValue as NSData?
            primaryCache.save(key: key, value: data)
            secondaryCache?.save(key: key, value: data)
        }
    }
    
    public func clearCache() {
        primaryCache.clearCache()
        secondaryCache?.clearCache()
    }
}
