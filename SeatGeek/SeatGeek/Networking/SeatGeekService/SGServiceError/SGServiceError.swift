//
//  SGServiceError.swift
//  SeatGeek
//
//  Created by Rahul Dubey on 10/24/20.
//  Copyright © 2020 com.seatgeek.org. All rights reserved.
//

import Foundation

public struct SGServiceError: Error {

  public let errorCode: Int
  public let errorDescription: String
  
  public var displayError: String {
    get {
      switch errorCode {
      case 404:
        return SGServiceErrorCodes.invalidQuery.displayMessage
      case 400:
        return SGServiceErrorCodes.invalidParameters.displayMessage
      default:
        return errorDescription //Handle other cases as well as of now display Error Description as default
      }
    }
  }
  
  public init(with errorCode: Int, errorDescription: String) {
    self.errorCode = errorCode
    self.errorDescription = errorDescription
  }
}
