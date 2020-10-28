//
//  SGEvent.swift
//  SeatGeek
//
//  Created by Rahul Dubey on 10/25/20.
//  Copyright © 2020 com.seatgeek.org. All rights reserved.
//

import Foundation

public struct SGEvent: Decodable {
    
    let identifier: Int
    let title: String
    let datetime: String
    let venue: SGVenue
    let performers: [SGPerformer]?
    let shortTitle: String

    enum CodingKeys: String, CodingKey {
             case identifier = "id"
             case title
             case venue = "venue"
             case datetime = "datetime_utc"
             case performers
             case shortTitle = "short_title"
      }
}
