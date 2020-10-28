//
//  SGServiceErrorCodes.swift
//  SeatGeek
//
//  Created by Rahul Dubey on 10/25/20.
//  Copyright © 2020 com.seatgeek.org. All rights reserved.
//

import Foundation

public enum SGServiceErrorCodes: Int {
  
  case invalidQuery = 404
  case invalidParameters = 400
  case defaultError
  
  var displayMessage: String {
    switch self {
    case .defaultError: return "Unable to get data, please try later"
    case .invalidParameters: return "Invalid Parameters"
    case .invalidQuery: return "Invalid Query"
    }
  }
}
