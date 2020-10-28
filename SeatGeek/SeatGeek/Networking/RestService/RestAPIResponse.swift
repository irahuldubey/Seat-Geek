//
//  RestAPIResponse.swift
//  SeatGeek
//
//  Created by Rahul Dubey on 10/24/20.
//  Copyright © 2020 com.seatgeek.org. All rights reserved.
//

import Foundation

///
/// RestResult: Returns Success and Failure
///
/// - success: Data as success
/// - failure: Error received from server
enum RestResult {
  case success(data: Data?)
  case failure(error: Error?)
}

