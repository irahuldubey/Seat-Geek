//
//  SGResponse.swift
//  SeatGeek
//
//  Created by Rahul Dubey on 10/24/20.
//  Copyright © 2020 com.seatgeek.org. All rights reserved.
//

import Foundation

public struct SGResponse: Decodable {
    let events: [SGEvent]
    let meta: SGMeta?
}

