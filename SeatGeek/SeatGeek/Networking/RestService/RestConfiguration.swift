//
//  RestEnums.swift
//  SeatGeek
//
//  Created by Rahul Dubey on 10/24/20.
//  Copyright © 2020 com.seatgeek.org. All rights reserved.
//

import Foundation

public struct RestConfiguration {
    
    public static let timeoutValue: Int = 15
    
    /// RequestType : HTTP protocols
    ///
    /// - HTTP
    /// - HTTPS
    public enum HttpProtocol: String {
      case HTTP = "http"
      case HTTPS = "https"
    }

    /// RequestType : Service Request Type
    ///
    /// - GET: GET type
    /// - POST: POST type
    public enum RequestType: String {
      case GET
      case POST
    }

    /// HTTPHeaderFieldKey: Extra HTTPHeader Parameters Appended
    ///
    /// - applicationJSON: JSON
    public enum HTTPHeaderFieldValue: String {
        case json = "application/json"
    }
    
    enum HTTPHeaderFieldKey: String {
      case contentType = "Content-Type"
    }
}

