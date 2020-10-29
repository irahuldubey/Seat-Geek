//
//  RestServerManager.swift
//  SeatGeek
//
//  Created by Rahul Dubey on 10/24/20.
//  Copyright © 2020 com.seatgeek.org. All rights reserved.
//

import Foundation

typealias RestServerResultCompletionHandler = (RestResult) -> ()

public final class RestServerManager {
    
    private let sessionConfiguration: URLSessionConfiguration
    
    private var urlSession: URLSession {
        return URLSession.init(configuration: sessionConfiguration)
    }
    
    public init(sessionConfiguration: URLSessionConfiguration = .default) {
        self.sessionConfiguration = sessionConfiguration
    }
    
    /// HTTP GET Request to make a service call
    ///
    /// - Parameters:
    ///   - urlRequest: urlRequest for service
    ///   - completionHandler: is of type RestServerResultCompletionHandler
    ///   - errorHandler: Throw and Error
    @discardableResult
    func makeServiceRequest(withUrlRequest urlRequest: URLRequest, completionHandler completion: @escaping RestServerResultCompletionHandler) -> URLSessionTask? {
        let dataTask = urlSession.dataTask(with: urlRequest) { (data,response,error) in
            if let data = data {
                completion(.success(data: data))
            }
            if let error = error {
                completion(.failure(error: error))
            }
        }
        dataTask.resume()
        return dataTask
    }
}
