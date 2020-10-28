//
//  SGMeta.swift
//  SeatGeek
//
//  Created by Rahul Dubey on 10/26/20.
//  Copyright © 2020 com.seatgeek.org. All rights reserved.
//

import Foundation

public struct SGMeta: Decodable {
    let per_page: Int
    let total: Int
    let page: Int
}
