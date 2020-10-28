//
//  SeatGeekServiceAPI.swift
//  SeatGeek
//
//  Created by Rahul Dubey on 10/24/20.
//  Copyright © 2020 com.seatgeek.org. All rights reserved.
//

import Foundation

public protocol SGServiceAPI {
  
  func fetchEvent(withQuery queryString: String, pagination: Pagination, withCompletionHandler completion: @escaping (SGServiceResponse) -> ()) throws -> Void
  
  func fetchEventDetails(with eventId: String, withCompletionHandler completionHandler:  @escaping (Result<SGEvent, SGServiceError>) -> Void) throws -> Void
    
  func fetchImage(with urlString: String, completionHandler completion: @escaping (Data?) -> ()) throws -> Void
    
}
