//
//  SeatGeekService.swift
//  SeatGeek
//
//  Created by Rahul Dubey on 10/24/20.
//  Copyright © 2020 com.seatgeek.org. All rights reserved.
//

import Foundation

public final class SGService: SGServiceAPI {
    
    private var serverManager: RestServerManager!
    private var apiServiceTask: URLSessionTask?
    
    public init(with manager: RestServerManager = RestServerManager()) {
        serverManager = manager
    }
    
    public func fetchEvent(withQuery queryString: String, pagination: Pagination, withCompletionHandler completion: @escaping (SGServiceResponse) -> ()) throws {
        
        guard queryString.count > 0 else { return }
        
        // cancel the previous task if the new task is fired
        // this is called as chaining so we don't make the HE srevices calls which are not needed.
        apiServiceTask?.cancel()
        
        // create a urlrequest and pass it to the API client to fetch the search result
        guard let urlRequest = SGRequestHelper.searchURL(with: queryString, pagination: pagination) else { return }
        
        // make an http request
        apiServiceTask = serverManager.makeServiceRequest(withUrlRequest: urlRequest) { (result) in
            switch result {
            case .success(data: let data):
                guard let data = data else { return }
                let serviceResponse = SGServiceParser.parseEventsJSON(data: data)!
                completion(.success(response: serviceResponse))
            case .failure(error: _):
                completion(.failure(error: nil))
            }
        }
    }
    
    public func fetchEventDetails(with eventId: String, withCompletionHandler completionHandler:  @escaping (Result<SGEvent, SGServiceError>) -> Void)  {
        
        guard eventId.count > 0 else { return }
        
        apiServiceTask?.cancel()

        guard let urlRequest = SGRequestHelper.eventDetails(with: eventId) else { return }
        
        apiServiceTask = serverManager.makeServiceRequest(withUrlRequest: urlRequest, completionHandler: { (result) in
            switch result {
            case .success(data: let data):
                guard let data = data else { return }
                let serviceResponse = SGServiceParser.parseEventJSON(data: data)!
                completionHandler(.success(serviceResponse))
            case .failure(error: _):
                let errorObj = SGServiceError.init(with: 400, errorDescription: "Failed to Load")
                completionHandler(.failure(errorObj))
            }
        })
    }
    
    public func fetchImage(with urlString: String, completionHandler completion: @escaping (Data?) -> ()) throws -> Void {

        guard let url = URL.init(string: urlString) else { return }
        
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
