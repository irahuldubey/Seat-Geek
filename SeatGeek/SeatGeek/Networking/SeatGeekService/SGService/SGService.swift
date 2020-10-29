//
//  SeatGeekService.swift
//  SeatGeek
//
//  Created by Rahul Dubey on 10/24/20.
//  Copyright © 2020 com.seatgeek.org. All rights reserved.
//

import Foundation

public final class SGService: SGServiceAPI {
    
    private let serverManager: RestServerManager!
    private var apiServiceTask: URLSessionTask?
    
    // intializer - manager: is of type RestServerManager
    public init(with manager: RestServerManager = RestServerManager()) {
        serverManager = manager
    }

    // queryString: is of type String
    // pagination: is of type Pagination
    // completionHandler: is of type Result <SGResponse, SGServiceError>
    public func fetchEvent(withQuery queryString: String, pagination: Pagination, withCompletionHandler completion: @escaping (Result<SGResponse, SGServiceError>)-> ()) throws -> Void {

        guard queryString.count > 0 else { return }
        
        // cancel the previous task if the new task is fired
        // this is called as chaining so we don't make the HE srevices calls which are not needed.
        apiServiceTask?.cancel()
        
        // create a urlrequest and pass it to the API client to fetch the search result
        guard let urlRequest = SGRequestHelper.searchURL(with: queryString, pagination: pagination) else { return }
        
        // make an http request
        apiServiceTask = serverManager.makeServiceRequest(withUrlRequest: urlRequest) { (result) in
            let genericError = SGServiceError.init(with: 0, errorDescription: "Unable to receive error message")
            switch result {
            case .success(data: let data):
                guard let data = data else { return }
                if let serviceResponse = SGServiceParser.parseEventsJSON(data: data) {
                    completion(.success(serviceResponse))
                } else {
                    completion(.failure(genericError))
                }
            case .failure(error: let error):
                if let nsError = error as NSError? {
                    let errorObj = SGServiceError.init(with: nsError.code, errorDescription: nsError.description)
                    completion(.failure(errorObj))
                } else {
                    completion(.failure(genericError))
                }
            }
        }
    }
    
    // eventId: is of type String
    // completionHandler: is of type Result <SGEvent, SGServiceError>
    public func fetchEventDetails(with eventId: String, withCompletionHandler completionHandler:  @escaping (Result<SGEvent, SGServiceError>) -> Void)  {
        
        guard eventId.count > 0 else { return }
        
        apiServiceTask?.cancel()

        guard let urlRequest = SGRequestHelper.eventDetails(with: eventId) else { return }
        
        apiServiceTask = serverManager.makeServiceRequest(withUrlRequest: urlRequest, completionHandler: { (result) in
            let genericError = SGServiceError.init(with: 0, errorDescription: "Unable to receive error message")
            switch result {
            case .success(data: let data):
                guard let data = data else { return }
                if let serviceResponse = SGServiceParser.parseEventJSON(data: data) {
                    completionHandler(.success(serviceResponse))
                } else {
                    completionHandler(.failure(genericError))
                }
            case .failure(error: let error):
                if let nsError = error as NSError? {
                    let errorObj = SGServiceError.init(with: nsError.code, errorDescription: nsError.description)
                    completionHandler(.failure(errorObj))
                } else {
                    completionHandler(.failure(SGServiceError.init(with: 0, errorDescription: "Unable to receive error message")))
                }
            }
        })
    }
    
    // urlString: is of type String
    // completionHandler: is of type Date
    public func fetchImage(with urlString: String, completionHandler completion: @escaping (Data?) -> ()) throws -> Void {

        guard let url = URL.init(string: urlString) else {
            completion(nil)
            return
        }
        
        let urlRequest = URLRequest.init(url: url)
        
        serverManager.makeServiceRequest(withUrlRequest: urlRequest) { (result) in
            switch result {
            case .success(data: let data):
              completion(data)
            case .failure(error: _):
                completion(nil)
            }
        }
    }
}
