//
//  SGVenue.swift
//  SeatGeek
//
//  Created by Rahul Dubey on 10/25/20.
//  Copyright © 2020 com.seatgeek.org. All rights reserved.
//

import Foundation

public struct SGVenue: Decodable {
    
    let displayLocation: String
    
    enum CodingKeys: String, CodingKey {
        case displayLocation = "display_location"
    }
}
