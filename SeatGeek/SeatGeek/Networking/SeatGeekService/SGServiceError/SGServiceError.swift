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
        case 100...199:
            return SGServiceErrorCodes.informational.displayMessage
        case 200...299:
            return SGServiceErrorCodes.successful.displayMessage
        case 300...399:
            return SGServiceErrorCodes.redirection.displayMessage
        case 400...499:
            return SGServiceErrorCodes.clientError.displayMessage
        case 500...599: // We can add retries if the server request fails
            return SGServiceErrorCodes.serverError.displayMessage
        default:
            return SGServiceErrorCodes.genericError.displayMessage
        }
    }
  }
  
  public init(with errorCode: Int, errorDescription: String) {
    self.errorCode = errorCode
    self.errorDescription = errorDescription
  }
}


