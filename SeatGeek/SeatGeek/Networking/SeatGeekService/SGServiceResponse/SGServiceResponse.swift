//
//  SGServiceResponse.swift
//  SeatGeek
//
//  Created by Rahul Dubey on 10/24/20.
//  Copyright © 2020 com.seatgeek.org. All rights reserved.
//

import Foundation

public enum SGServiceResponse {
  case success(response: SGResponse)
  case failure(error: SGServiceError?)
}
