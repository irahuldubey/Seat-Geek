//
//  SBFileCacheProvider.swift
//  SeatGeek
//
//  Created by Rahul Dubey on 10/27/20.
//  Copyright © 2020 com.seatgeek.org. All rights reserved.
//

import Foundation

public class SBFileCacheProvider: SBCacheProviderProtocol {
    
    private var loggingEnabled: Bool
    private let cacheDirectory: String
    
    init(cacheDir: String, enableLogging: Bool = true) {
        cacheDirectory = cacheDir
        loggingEnabled = enableLogging
    }
    
    public func load(key: String) -> Data? {
        
        guard let path = fileURL(fileName: key) else {
            return nil
        }
        
        var data: Data?
        do {
            data = try Data(contentsOf: path)
        } catch {
            consoleOutput("SBFileCacheProvider - Failed to create object", error)
        }
        return data
    }
    
    public func save(key: String, value: NSData?) {
        
        guard let path = fileURL(fileName: key) else { return }
        
        guard let newValue = value as Data? else {
            try? FileManager.default.removeItem(at: path)
            return
        }
        
        do {
            try newValue.write(to: path, options: .atomic)
        } catch {
            consoleOutput("SBFileCacheProvider Failed to write data on file", error)
        }
    }
    
    public func clearCache() {
        deleteCacheDirectory()
    }
    
    private func fileURL(fileName name: String) -> URL? {
        guard let escapedName = name.addingPercentEncoding(withAllowedCharacters: .alphanumerics) else {
            return nil
        }
        
        var cachesDir: URL?
        do {
            cachesDir = try cachesDirectory()
        } catch {
            consoleOutput("SBFileCacheProvider Cannot fetch from cache", error)
            return nil
        }
        return cachesDir?.appendingPathComponent(escapedName)
    }
    
    private func cachesDirectory() throws -> URL? {
        
        var cachesDir: URL? = nil
            
        do {
            cachesDir = try FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent(cacheDirectory, isDirectory: true)
        } catch {
            throw error
        }
        
        guard let directory = cachesDir else { return nil }
        
        do {
            try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil)
        } catch {
            throw error
        }
        return directory
    }
    
    private func deleteCacheDirectory() {
        
        var cachesDir: URL?
        
        do {
            cachesDir = try cachesDirectory()
        } catch {
            consoleOutput("SBFileCacheProvider to fetch from dirctory", error)
            return
        }
        
        guard let dir = cachesDir else {
            return
        }
        
        do {
            try FileManager.default.removeItem(at: dir)
        } catch {
            consoleOutput("SBFileCacheProvider deleting files from the caches directory: ", error)
        }
        
    }
    
    private func consoleOutput(_ items: Any...) {
        guard loggingEnabled else { return }
        debugPrint(items)
    }
}
