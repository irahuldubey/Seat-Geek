//
//  SGServiceErrorCodes.swift
//  SeatGeek
//
//  Created by Rahul Dubey on 10/25/20.
//  Copyright © 2020 com.seatgeek.org. All rights reserved.
//

import Foundation

// Reference: https://en.wikipedia.org/wiki/List_of_HTTP_status_codes
public enum SGServiceErrorCodes: Int {
  
  case informational
  case successful
  case redirection
  case clientError
  case serverError
  case genericError
  
  var displayMessage: String {
    switch self {
        case .informational: return "The request was received, continuing process"
        case .successful: return "Invalid Parameters"
        case .redirection: return "Further action needs to be taken in order to complete the request"
        case .clientError: return "The request contains bad syntax or cannot be fulfilled"
        case .serverError: return "The server failed to fulfil an apparently valid request"
        case .genericError: return "Could not complete request"
    }
  }
}



